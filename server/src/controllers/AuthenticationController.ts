import WebSocket from "ws";
import { authenticateJWT, generateAccessToken, generateRefreshToken } from "../middleware/authMiddleware";
import User, { IUser } from "../models/User";
import WebSocketResponder from "../utils/WSResponder";
import clientManager from "../utils/clientManager";
import { ErrorCodes, SuccessCodes } from "../utils/responseCodes";
import http from "http";
import { WSAuthentiacationResponse, WSAuthenticationRequest } from "../utils/types";

const failedCase = { success: false }

async function authenticateUser(ws: WebSocket, req: http.IncomingMessage): Promise<{ success: boolean; uId?: string | undefined; responseHandler?: WebSocketResponder | undefined; }> {
    const responseHandler = new WebSocketResponder(ws);
    const fullUrl = new URL(req.url!, `http://${req.headers.host}`);

    if (fullUrl.pathname === "/authenticate") {
        responseHandler.sendMessageFromCode(SuccessCodes.AWAITING_CREDENTIALS);

        return await new Promise(resolve => {
            ws.once("message", async (message: string) => {
                let req: WSAuthenticationRequest;
                try {
                    req = JSON.parse(message) as WSAuthenticationRequest;
                } catch (error) {
                    responseHandler.invalidParametersError()
                    responseHandler.closeClient()
                    return resolve(failedCase);
                }

                // if not trying to authenticate
                if (req.type !== "Authentication") {
                    responseHandler.closeClient(ErrorCodes.UNKNOWN_ACTION_TYPE);
                    return resolve(failedCase);
                }

                if (!req.data.email) {
                    responseHandler.invalidParametersError();
                    responseHandler.closeClient();
                    return resolve(failedCase);
                }

                if (!req.data.FCMtoken) {
                    responseHandler.invalidParametersError();
                    responseHandler.closeClient();
                    return resolve(failedCase);
                }

                let user = await User.findOne({ email: req.data.email }) as IUser;

                // if trying to login with password
                if (req.reqType === "AUTHENTICATE_WITH_PASSWORD") {
                    if (!user) {
                        responseHandler.closeClient(ErrorCodes.USER_NOT_FOUND);
                        return resolve(failedCase);
                    }

                    if (user.password) {
                        if (user.password !== req.data.password) {
                            responseHandler.closeClient(ErrorCodes.INVALID_CREDENTIALS);
                            return resolve(failedCase);
                        } else {
                            user.FCMtoken = req.data.FCMtoken;
                            user = await user.save();
                            if (!user) {
                                responseHandler.closeClient(ErrorCodes.INTERNAL_SERVER_ERROR);
                                return resolve(failedCase);
                            }
                        }
                    } else {
                        responseHandler.closeClient(ErrorCodes.USER_NOT_FOUND);
                        return resolve(failedCase);
                    }

                }

                // if trying to login with google
                else {

                    // new user
                    if (!user) {
                        const newUser = new User({
                            username: req.data.userName ?? req.data.email,
                            firstName: req.data.userName!.split(" ")[0],
                            lastName: req.data.userName!.split(" ").slice(1).join(" "),
                            email: req.data.email,
                            imageURL: req.data.profileImage ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                            contacts: [],
                            friendRequests: [],
                            FCMtoken: req.data.FCMtoken,
                            followers: "0",
                            following: "0"
                        });

                        user = await newUser.save();
                        if (!user) {
                            responseHandler.closeClient(ErrorCodes.INTERNAL_SERVER_ERROR);
                            return resolve(failedCase);
                        }
                    }

                    // existing user
                    else {
                        user.FCMtoken = req.data.FCMtoken;

                        user = await user.save();
                        if (!user) {
                            responseHandler.closeClient(ErrorCodes.INTERNAL_SERVER_ERROR);
                            return resolve(failedCase);
                        }
                    }
                }

                const uId = user._id.toString();

                const res: WSAuthentiacationResponse = {
                    type: "Authentication",
                    resType: "AUTH_TOKENS",
                    data: {
                        accessToken: generateAccessToken(uId, user.email),
                        refreshToken: generateRefreshToken(uId, user.email),
                        userId: uId,
                        profileImage: user.image
                    }
                };

                responseHandler.setUser(user);
                clientManager.addClient(uId, ws);
                responseHandler.sendData(res);
                return resolve({ success: true, responseHandler, uId });
            });
        });
    } else {

        const token = fullUrl.searchParams.get("token");

        console.log("token =", token);

        // handle authentication

        if (!token) {
            responseHandler.closeClient(ErrorCodes.TOKEN_NOT_PROVIDED);
            return failedCase;
        }

        const validationResult = authenticateJWT(token)

        if (!validationResult.valid) {
            console.log("validation error paa token invalid");

            responseHandler.closeClient(ErrorCodes.INVALID_TOKEN)
            return failedCase;
        }

        if (validationResult.expired) {
            console.log("validation error paa token expired");

            responseHandler.closeClient(ErrorCodes.EXPIRED_TOKEN);
            return failedCase;
        }

        // handle user

        if (!validationResult.decoded) {
            console.log("Mapla decode aala da");
            responseHandler.sendMessageFromCode(ErrorCodes.INTERNAL_SERVER_ERROR)
            return failedCase
        }

        const user = (await User.findById(validationResult.decoded._id)) as IUser;

        if (!user) {
            responseHandler.closeClient("Not an existing user please register");
            return failedCase;
        }

        const uId = user._id.toString();
        responseHandler.setUser(user)

        // handle clients

        clientManager.addClient(uId, ws)

        // handle connection

        responseHandler.sendMessageFromCode(SuccessCodes.CONNECTION_SUCCESSFUL)

        // end of connection handling...

        return { success: true, responseHandler, uId }
    }
}

export default authenticateUser