const WebSocket = require("ws");
const fs = require("fs");
const path = require("path");

// Profiles
const profiles = [
    "manish.prasad@example.com",
    "soorya@example.com",
    "john.wick@example.com",
    // "ben.affleck@example.com",
    // "lucia.caminos@example.com",
    // "ashlyn.mary@example.com",
    // "michael.desanta@example.com",
    "samantha.gallen@example.com",
    // "vaas.m@example.com",
    // "edward.kenway@example.com",
    // "faith.seed@example.com",
    // "ezio.auditore@example.com",

    "john.doe@example.com",
    "jane.smith@example.com",
    "robert.lee@example.com",
    "alice.wang@example.com",
    "michael.kim@example.com",
    "lisa.chen@example.com",
];

// Send WS request
const sendWS = (ws, req) => ws.send(JSON.stringify(req));

const ronaldoID = "684b0ab50e2c9ca1d99925c0";

// Main function
(async () => {
    for (const profile of profiles) {
        console.log(`🟡 Starting update for ${profile}`);

        const ws = new WebSocket("ws://localhost:8055/authenticate");

        await new Promise((resolve, reject) => {
            ws.on("open", () => {
                console.log(`🔑 Connected to /authenticate for ${profile}`);
            });

            ws.on("message", (msg) => {
                let response = JSON.parse(msg.toString());
                // if (response.data?.data.resType !== "PROFILE_UPDATED")
                //     console.log(`message bro: ${msg}`);

                if (response.code === 2001) {
                    const email = profile;
                    const authReq = {
                        type: "Authentication",
                        reqType: "AUTHENTICATE",
                        data: { email },
                    };

                    console.log(`📨 Sending authentication request for ${email}`);
                    sendWS(ws, authReq);
                }

                if (response.data) {
                    response = response.data
                    if (response.resType === "AUTH_TOKENS") {
                        const accessToken = response.data.accessToken;
                        console.log(`✅ Access token received for ${profile}`);

                        const updateReq = {
                            type: "Account",
                            reqType: "MAKE_REQUEST",
                            data: { userId: ronaldoID },
                        };

                        console.log(`📤 Sending friend request from ${profile}`);
                        sendWS(ws, updateReq);
                    }

                    if (response.resType === "ACCOUNT_REQUEST_MADE") {
                        console.log(`✅ Successfully updated profile image for ${profile.email}`);
                        ws.close();
                        resolve();
                    }
                }
            });

            ws.on("error", (e) => {
                console.error(`❌ Error on /authenticate WS for ${profile}:`, e);
                ws.close();
                reject();
            });
        });
    }

    console.log("🎉 All requests were made!");
})();

