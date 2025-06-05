import express from "express";
import http from "http";
import WebSocket from "ws";
import WebSocketResponder from "./utils/WSResponder";
import USERS from "./data/Users";
import { ErrorCodes, SuccessCodes } from "./utils/responseCodes";
import User from "./models/User";
import path from "path";
import AppRouter from "./routes/router";
import clientManager from "./utils/clientManager";

const PORT = 8055

const app = express();
// const server = http.createServer(app);
const wss = new WebSocket.Server({ port: 8055 });

const handleConnection = (ws: WebSocket, req: http.IncomingMessage) => {
  const responseHandler = new WebSocketResponder(ws);

  const fullUrl = new URL(req.url!, `http://${req.headers.host}`);
  const userID = fullUrl.searchParams.get("userID");

  console.log("userID =", userID);

  if (!userID) {
    responseHandler.invalidParametersError();
    return;
  }

  const user = USERS.get(userID) as User;
  responseHandler.setId(userID)

  if (!user) {
    responseHandler.closeClient("Not an existing user please register");
    return;
  }

  if (!user.isAuthorized()) {
    responseHandler.closeClient(ErrorCodes.EXPIRED_TOKEN);
    return;
  }

  clientManager.addClient(user.userId, ws)

  responseHandler.sendMessageFromCode(SuccessCodes.CONNECTION_SUCCESSFUL)
  responseHandler.sendData({ contacts: user.contacts, message: "Total Contacts" })

  ws.on("message", (message: string) => AppRouter(ws, message, responseHandler))
  ws.on("close", (code, reason) => {
    clientManager.removeClient(user.userId);
    console.log(`User ${user.userId} left the pool\ncode: ${code}\nreason: ${reason}`)
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
