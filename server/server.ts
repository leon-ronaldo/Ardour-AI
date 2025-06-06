import express from "express";
import http from "http";
import WebSocket from "ws";
import WebSocketResponder from "./utils/WSResponder";
import { ErrorCodes, SuccessCodes } from "./utils/responseCodes";
import User, { IUser } from "./models/User";
import path from "path";
import AppRouter from "./routes/router";
import clientManager from "./utils/clientManager";
import dotenv from 'dotenv'
import { authenticateJWT } from "./middleware/authMiddleware";
import connectDb from "./config/dbConnection";

const PORT = 8055

const app = express();
dotenv.config()
// const server = http.createServer(app);
const wss = new WebSocket.Server({ port: 8055 });

connectDb()

const handleConnection = async (ws: WebSocket, req: http.IncomingMessage) => {
  const responseHandler = new WebSocketResponder(ws);

  const fullUrl = new URL(req.url!, `http://${req.headers.host}`);
  const token = fullUrl.searchParams.get("token");

  console.log("token =", token);

  // handle authentication

  if (!token) {
    responseHandler.invalidParametersError();
    return;
  }

  const validationResult = authenticateJWT(token)

  if (!validationResult.valid) {
    responseHandler.closeClient(ErrorCodes.INVALID_TOKEN)
    return;
  }

  if (validationResult.expired) {
    responseHandler.closeClient(ErrorCodes.EXPIRED_TOKEN);
    return;
  }

  // handle user

  if (!validationResult.decoded) {
    console.log("Mapla decode aala da");
    responseHandler.sendMessageFromCode(ErrorCodes.INTERNAL_SERVER_ERROR)
    return
  }

  const user = (await User.findById(validationResult.decoded._id)) as IUser;
  const uId = user._id.toString();
  responseHandler.setUser(user)

  if (!user) {
    responseHandler.closeClient("Not an existing user please register");
    return;
  }

  // handle clients

  clientManager.addClient(uId, ws)

  // handle connection

  responseHandler.sendMessageFromCode(SuccessCodes.CONNECTION_SUCCESSFUL)

  ws.on("message", (message: string) => AppRouter(ws, message, responseHandler))
  ws.on("close", (code, reason) => {
    clientManager.removeClient(uId);
    console.log(`User ${uId} left the pool\ncode: ${code}\nreason: ${reason}`)
  })

  // end of connection handling...
};

wss.on("connection", handleConnection);

export default wss

console.log(`server running on ws://localhost:${PORT}`)

// app.get("/", (req, res) => {
//     res.sendFile(path.join(process.cwd(), 'index.html'));
// })

// app.listen(PORT, () => {
//     console.log(`Server listening on http://localhost:${PORT}`);
// })
