const WebSocket = require("ws");

const userID = "u001"; // Replace with actual userID
const ws = new WebSocket(`ws://localhost:8055/?userID=${userID}`);

const SuccessCodes = {
  CONNECTION_SUCCESSFUL: 2000,
};

// State flag to track successful connection
let connectionEstablished = false;

ws.on("open", () => {
  console.log("🔌 Connected to server, waiting for success message...");
});

ws.on("message", (data) => {
  try {
    const response = JSON.parse(data);

    // Handle success message
    if (response.message && response.code === SuccessCodes.CONNECTION_SUCCESSFUL) {
      console.log("✅ Connection successful:", response.message);
      connectionEstablished = true;
      startYourClientAppLogic();
      return;
    }

    // Handle general message
    if (response.message) {
      console.log("📩 Message from server:", response.message);
    }

    // Handle error
    if (response.error) {
      console.error("❌ Error from server:", response.error);
      ws.close();
      terminateApp();
      return;
    }

    // Handle data
    if (response.data) {
      console.log("📦 Data received from server:", response.data);
    }

  } catch (err) {
    console.error("❌ Failed to parse server response:", err.message);
    ws.close();
    terminateApp();
  }
});

ws.on("close", (code, reason) => {
  console.log(`🔒 Disconnected (code: ${code}, reason: ${reason})`);
  if (!connectionEstablished) terminateApp();
});

ws.on("error", (err) => {
  console.error("❌ WebSocket error:", err.message);
  terminateApp();
});

// Simulated app logic after connection success
function startYourClientAppLogic() {
  console.log("🚀 Starting main app...");
  // You can now send chat messages, etc.
  // ws.send(JSON.stringify({ type: "Chat", reqType: "CONN_REQ", data: { to: "u002" }}));
}

function terminateApp() {
  console.log("💥 Terminating client app...");
  process.exit(1); // You could also clean up instead
}
