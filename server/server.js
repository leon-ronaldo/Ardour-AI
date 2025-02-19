const express = require('express');
const http = require('http');
const path = require("path");
const WebSocket = require('ws');
const connectDb = require("./config/dbConnection");
const { handleUserConnection, handleMessage, updateUserStatus } = require('./controllers/chatController');

const app = express();

connectDb();

// Middleware
app.use(express.json());
app.use('/auth', require('./routes/UserRoutes'));

app.get('/', (req, res) => {
    res.sendFile(path.join(process.cwd(), 'index.html')); 
});

// Create an HTTP server to integrate with WebSocket
const server = http.createServer(app);

// WebSocket setup
const wss = new WebSocket.Server({ server });

wss.on('connection', async (ws, req) => {
    // Handle user connection
    await handleUserConnection(ws, req);

    // On message from user
    ws.on('message', async (message) => {
        await handleMessage(ws, message);
    });

    // On user disconnect
    ws.on('close', async () => {
        console.log(`User ${ws.currentUserId} disconnected`);
        await updateUserStatus(ws.currentUserId, false);
    });
});

// Start the server on port 8055
const PORT = 8055;
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
