import express from "express";
import http from "http";
import WebSocket from "ws";

import dotenv from "dotenv";
dotenv.config();

import AppRouter from "./routes/router";
import connectDb from "./config/dbConnection";
import authenticateUser from "./controllers/AuthenticationController";
import clientManager from "./utils/clientManager";

const app = express();
connectDb();

// ---------- KEY CHANGE: use Render's assigned port ----------
const PORT = Number(process.env.PORT || 8055);      // Render sets PORT env var

// Create ONE HTTP server that Express & WS share
const server = http.createServer(app);

// Attach ws to that server (no hard‑coded port)
const wss = new WebSocket.Server({ server });

// ---------- WebSocket connection ----------
wss.on("connection", async (ws, req) => {
  const { success, responseHandler, uId } = await authenticateUser(ws, req);
  if (!success || !responseHandler) return;

  ws.on("message", (msg: string) => AppRouter(msg, responseHandler));

  ws.on("close", (code, reason) => {
    clientManager.removeClient(uId!);
    console.log(`User ${uId} disconnected – code ${code} reason ${reason}`);
  });
});

// ---------- optional: simple health check for Render ----------
// app.get("/", (_req, res) => res.status(200).send("Ardour‑AI WS server OK"));

// ---------- start listening ----------
server.listen(PORT, () => {
  console.log(`🟢  WebSocket server running on port ${PORT}`);
  console.log(`    ➜  wss://ardour-ai.onrender.com`);
});

export default wss;
