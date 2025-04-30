import WebSocket, { WebSocketServer } from 'ws';
import connectDb from './config/dbConnection';
import AppRoutes from './types/router';

const wss = new WebSocket.Server({ port: 8055 });

// DB config
// connectDb(); // Uncomment this after adding connection to DB

wss.on('connection', (ws: WebSocket, req) => {
    console.log('New client connected');

    const route = AppRoutes[(req.url ?? "").split("/")[1]];
    
    if (!route) {
        ws.send("invalid url")
        ws.close()
    } else {
        route(ws, req)
    }
    
    ws.on('close', () => {
        console.log('Client disconnected');
    });
});

export default wss