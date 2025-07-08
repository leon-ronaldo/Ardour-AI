const WebSocket = require("ws");
const fs = require("fs");
const path = require("path");

// Profiles
const profiles = [
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

    // { email: "john.doe@example.com", profilePic: "https://images.unsplash.com/photo-1526116977494-90748acc0cad?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YWVzdGhldGljJTIwbWFufGVufDB8fDB8fHww" },
    // { email: "jane.smith@example.com", profilePic: "https://i.pinimg.com/236x/17/0f/6b/170f6bfe2a3b4ca88e33bb268a6a9e19.jpg" },
    // { email: "robert.lee@example.com", profilePic: "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/139269947/original/3b8fed3799c7fc30ec0b4f83d07238c342debe20/help-you-boost-your-instagram-and-tinder-profile.jpg" },
    // { email: "alice.wang@example.com", profilePic: "https://i.pinimg.com/736x/6b/e1/aa/6be1aa1902ce295f70e6a1d91587bd51.jpg" },
    // { email: "michael.kim@example.com", profilePic: "https://images.unsplash.com/photo-1474031317822-f51f48735ddd?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGFlc3RoZXRpYyUyMGJveXxlbnwwfHwwfHx8MA%3D%3D" },
    // { email: "lisa.chen@example.com", profilePic: "https://i.pinimg.com/474x/14/48/3c/14483c3898da857249b9e901345284b8.jpg" },
];

// Read image as base64
const getBase64Image = (fileName) => {
    const filePath = path.resolve(__dirname, "../tests/sampleData", fileName);
    const ext = path.extname(fileName).substring(1);
    const buffer = fs.readFileSync(filePath);
    return `data:image/${ext};base64,${buffer.toString("base64")}`;
};

// Send WS request
const sendWS = (ws, req) => ws.send(JSON.stringify(req));

// Main function
(async () => {
    for (const profile of profiles) {
        console.log(`🟡 Starting update for ${profile.email}`);

        const ws = new WebSocket("ws://localhost:8055/authenticate");

        await new Promise((resolve, reject) => {
            ws.on("open", () => {
                console.log(`🔑 Connected to /authenticate for ${profile.email}`);
            });

            ws.on("message", (msg) => {
                let response = JSON.parse(msg.toString());
                if (response.data?.data.resType !== "PROFILE_UPDATED")
                    console.log(`message bro: ${msg}`);

                if (response.code === 2001) {
                    const email = profile.email;
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
                        console.log(`✅ Access token received for ${profile.email}`);


                        const profileImage = getBase64Image(profile.profilePic);
                        // const profileImage = profile.profilePic;
                        // console.log(`🖼️  Loaded and encoded image: ${profile.profilePic}`);

                        const updateReq = {
                            type: "Account",
                            reqType: "UPDATE_PROFILE",
                            data: { profileImage },
                        };

                        console.log(`📤 Sending profile image update for ${profile.email}`);
                        sendWS(ws, updateReq);
                    }

                    if (response.resType === "PROFILE_UPDATED") {
                        console.log(`✅ Successfully updated profile image for ${profile.email}`);
                        ws.close();
                        resolve();
                    }
                }
            });

            ws.on("error", (e) => {
                console.error(`❌ Error on /authenticate WS for ${profile.email}:`, e);
                ws.close();
                reject();
            });
        });
    }

    console.log("🎉 All profile images updated!");
})();

