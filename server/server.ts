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
import authenticateUser from "./controllers/AuthenticationController";

const PORT = 8055

const app = express();
dotenv.config()
// const server = http.createServer(app);
const wss = new WebSocket.Server({ port: 8055 });

connectDb()

const handleConnection = async (ws: WebSocket, req: http.IncomingMessage) => {

  const { success, responseHandler, uId } = await authenticateUser(ws, req)

  if (!success) {
    return
  }

  ws.on("message", (message: string) => AppRouter(ws, message, responseHandler!))
  ws.on("close", (code, reason) => {
    clientManager.removeClient(uId!);
    console.log(`User ${uId} left the pool\ncode: ${code}\nreason: ${reason}`)
  })
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
