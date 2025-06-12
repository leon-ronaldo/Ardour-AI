import WebSocket from "ws";
import fs from "fs";
import path from "path";

// Type definitions
type SampleProfile = { profilePic: string; email: string };

type WSBaseRequest<M extends string, A extends string, D> = {
    module: M;
    reqType: A;
    data: D;
};

type WSBaseResponse<M extends string, A extends string, D> = {
    module: M;
    resType: A;
    data: D;
};

// Profiles
const profiles: SampleProfile[] = [
    { profilePic: "manish.png", email: "manish.prasad@example.com" },
    { profilePic: "soorya.png", email: "soorya@example.com" },
    { profilePic: "john.jpg", email: "john.wick@example.com" },
    { profilePic: "affleck.jpg", email: "ben.affleck@example.com" },
    { profilePic: "lucia.png", email: "lucia.caminos@example.com" },
    { profilePic: "ashlyn.png", email: "ashlyn.mary@example.com" },
    { profilePic: "gta-v-michael.jpg", email: "michael.desanta@example.com" },
    { profilePic: "sam.jpg", email: "samantha.gallen@example.com" },
    { profilePic: "vaas.jpg", email: "vaas.m@example.com" },
    { profilePic: "edward-kenway.jpg", email: "edward.kenway@example.com" },
    { profilePic: "faithSeed.jpg", email: "faith.seed@example.com" },
    { profilePic: "ac2-ezio.jpg", email: "ezio.auditore@example.com" },
];

// Derive email from handle name
const emailFromHandle = (handle: string) =>
    handle.replace("@", "").replace(/\./g, "_") + "@example.com";

// Read image as base64
const getBase64Image = (fileName: string) => {
    const filePath = path.resolve(__dirname, "../tests/sampleData", fileName);
    const ext = path.extname(fileName).substring(1);
    const buffer = fs.readFileSync(filePath);
    return `data:image/${ext};base64,${buffer.toString("base64")}`;
};

// Send WS request
const sendWS = (ws: WebSocket, req: object) => ws.send(JSON.stringify(req));

// Main function
(async () => {
    for (const profile of profiles) {
        const ws = new WebSocket("ws://localhost:8055/authenticate");

        await new Promise<void>((resolve, reject) => {
            ws.on("open", () => {
                const email = profile.email;
                const authReq: WSBaseRequest<"Authentication", "AUTHENTICATE", { email: string }> = {
                    module: "Authentication",
                    reqType: "AUTHENTICATE",
                    data: { email },
                };

                sendWS(ws, authReq);
            });

            ws.on("message", (msg) => {
                const response = JSON.parse(msg.toString());

                if (response.action === "AUTH_TOKENS") {
                    const accessToken = response.data.accessToken;

                    // Connect to main server with token
                    const authWS = new WebSocket(`ws://localhost:8055/?token=${accessToken}`);

                    authWS.on("open", () => {
                        const profileImage = getBase64Image(profile.profilePic);

                        const updateReq: WSBaseRequest<
                            "Account",
                            "UPDATE_PROFILE",
                            { profileImage: string }
                        > = {
                            module: "Account",
                            reqType: "UPDATE_PROFILE",
                            data: { profileImage },
                        };

                        sendWS(authWS, updateReq);
                    });

                    authWS.on("message", (msg) => {
                        const res = JSON.parse(msg.toString());
                        if (res.action === "PROFILE_UPDATED") {
                            console.log(`✅ Updated profile image for ${profile.email}`);
                            authWS.close();
                            ws.close();
                            resolve();
                        }
                    });

                    authWS.on("error", (e) => {
                        console.error(`❌ Auth WS error for ${profile.email}:`, e);
                        authWS.close();
                        ws.close();
                        reject();
                    });
                }
            });

            ws.on("error", (e) => {
                console.error(`❌ Initial WS error for ${profile.email}:`, e);
                ws.close();
                reject();
            });
        });
    }

    console.log("🎉 All profile images updated!");
})();
