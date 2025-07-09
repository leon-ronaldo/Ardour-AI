const WebSocket = require("ws");
const readline = require('readline');

const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODQxMzMwMmVkOTQxMmVjNWMwYWYzNjUiLCJlbWFpbCI6ImpvaG4uZG9lQGV4YW1wbGUuY29tIiwiaWF0IjoxNzQ5MTI5MDI1LCJleHAiOjE3NDkyMTU0MjV9.gyk0-n2ZITtSslfuWmX4kuPZMAiTFBOf5eTShkni1dI"; // Replace with actual userID
const token2 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODQxMzMwMmVkOTQxMmVjNWMwYWYzNjYiLCJlbWFpbCI6ImphbmUuc21pdGhAZXhhbXBsZS5jb20iLCJpYXQiOjE3NDkxODI4ODIsImV4cCI6MTc0OTI2OTI4Mn0.wnMdw-mOYwzHNh_c1KCHMYyuex2o1PpF8e4EmvVBpRA"
const ws = new WebSocket(`wss://ardour-ai.onrender.com/?token=${token}`);
const clientUserId = "68413302ed9412ec5c0af365"

const SuccessCodes = {
  CONNECTION_SUCCESSFUL: 2000,
};

// State flag to track successful connection
let connectionEstablished = false;

let contacts = []

ws.on("open", () => {
  console.log("🔌 Connected to server, waiting for success message...");
});

ws.on("message", (data) => {
  try {
    let response = JSON.parse(data);

    // Handle success message
    if (response.message && response.code === SuccessCodes.CONNECTION_SUCCESSFUL) {
      console.log("✅ Connection successful:", response.message);
      connectionEstablished = true;
      startYourClientAppLogic();
      return;
    }

    if (response.data) {
      response = response.data

      // Handle Account message
      if (response.type === "Account") {
        if (response.resType === "CONTACT_LIST") {
          contacts = response.data.contacts;
          console.log("📦 Updated Contacts:", contacts);
        }
      }

      // Handle Chat message
      if (response.type === "Chat") {
        if (response.resType === "PRIVATE_CHAT_MESSAGE") {
          console.log(`📦 Message from ${response.data.from}:`, response.data.message);
        }
      }
    }

    // Handle error
    if (response.error) {
      console.error("❌ Error from server:", response.error);
      ws.close();
      terminateApp();
      return;
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

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  function showMenu() {
    console.log("\nChoose an option:");
    console.log("1. Accounts");
    console.log("2. Chat");
    console.log("0. Exit");
    rl.question("Enter choice: ", handleInput);
  }

  async function handleInput(choice) {
    switch (choice.trim()) {
      case '1':
        await handleAccounts();
        break;
      case '2':
        await handleChat();
        break;
      case '0':
        console.log("👋 Exiting...");
        rl.close();
        terminateApp();
        return;
      default:
        console.log("❌ Invalid option.");
    }
    showMenu();
  }


  async function handleAccounts() {
    console.log("📂 Accounts logic here...");
    console.log("1. Fetch Contacts");
    console.log("2. Logout");
    console.log("0. Back");

    return new Promise((resolve) => {
      rl.question("Select option: ", (choice) => {
        switch (choice.trim()) {
          case '1':
            const getContactsRequest = JSON.stringify({
              type: "Account",
              reqType: "GET_CONTACTS",
              data: {}
            }, null, 2)

            console.log("📡 Sending request:", getContactsRequest);
            ws.send(getContactsRequest)
            return resolve();

          case '2':
            console.log("👋 Logging out... (dummy logout)");
            return resolve();

          case '0':
            console.log("🔙 Returning to main menu...");
            return resolve();

          default:
            console.log("❌ Invalid option.");
            return resolve();
        }
      });
    });
  }

  async function handleChat() {
    if (contacts.length === 0) {
      console.log("⚠️ No contacts available. Please fetch contacts first.");
      return;
    }

    console.log("\n📇 Your Contacts:");
    contacts.forEach((contact, index) => {
      console.log(`${index + 1}. (${contact})`);
    });

    rl.question("\nSelect a contact to chat with (0 to go back): ", (indexStr) => {
      const index = parseInt(indexStr.trim(), 10);

      if (isNaN(index) || index < 0 || index > contacts.length) {
        console.log("❌ Invalid selection.");
        return handleChat();
      }

      if (index === 0) {
        console.log("🔙 Returning to main menu...");
        return;
      }

      const selectedContact = contacts[index - 1];
      console.log(`💬 Chatting with ${selectedContact}`);

      // 🔁 Fetch chat history
      const fetchHistoryRequest = {
        type: "Account",
        reqType: "PRIVATE_CHAT_HISTORY",
        data: {
          userId: selectedContact
        }
      };

      // Handle response temporarily inside message handler
      const historyListener = (data) => {
        try {
          let response = JSON.parse(data);
          console.log("deii paraamaa", response);
          response = response.data

          if (
            response.type === "Account" &&
            response.resType === "PRIVATE_CHAT_HISTORY" &&
            response.data?.messages
          ) {
            // 🧾 Unsubscribe this handler after use
            ws.off("message", historyListener);

            const messages = response.data.messages;
            messages.sort((a, b) => a.timestamp - b.timestamp); // sort by time

            console.log("🗂️ Chat history:");
            messages.forEach(msg => {
              const label = msg.from === clientUserId ? "you" : msg.from;
              console.log(`${label}: ${msg.message}`);
            });

            // ✉️ Proceed to send message
            rl.question("✉️ Enter your message: ", (message) => {
              const chatMessage = {
                type: "Chat",
                reqType: "SEND_MSG",
                data: {
                  to: selectedContact,
                  message
                }
              };

              console.log("📡 Sending message:", JSON.stringify(chatMessage, null, 2));
              ws.send(JSON.stringify(chatMessage));

              rl.question("📨 Send another message? (y/n): ", (ans) => {
                if (ans.toLowerCase() === 'y') {
                  handleChat();
                } else {
                  console.log("🔙 Returning to main menu...");
                }
              });
            });
          }
        } catch (err) {
          console.error("❌ Failed to parse chat history:", err.message);
        }
      };

      ws.on("message", historyListener);
      ws.send(JSON.stringify(fetchHistoryRequest));
    });
  }


  // Start menu
  showMenu();
}

function terminateApp() {
  console.log("💥 Terminating client app...");
  process.exit(1); // You could also clean up instead
}
