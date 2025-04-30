import WebSocket from "ws";

import {
    ChatOrigin, chatConnect
} from "../controllers/ChatController"

const chatRouter = (ws: WebSocket, req: unknown) => {
    chatConnect(ws)
}

export { chatRouter }
