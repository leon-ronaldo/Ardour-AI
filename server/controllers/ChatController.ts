import asyncHandler from "express-async-handler";
import { Request, Response } from "express";
import WebSocket from "ws";
import { SuccessResponses } from "../types/wsMessages";
import generateUniqueId from "../utils/generateUniqueId";
import wss from "../server";
import { WSUser } from "../types/requestTypes";

let clients: { [key: string]: WSUser } = {}

const ChatOrigin = asyncHandler(async (req: Request, res: Response) => {
    console.log("created Chat successfully");
    res.status(200).json({ route: "Chat" });
});

const chatConnect = (ws: WebSocket) => {
    const newID = generateUniqueId(Object.keys(clients));
    const user = (ws as WSUser)
    user.id = newID;
    user.userName = ""
    clients[newID] = user;
    ws.send(SuccessResponses.SUCCESSFULL_CONNECTION.message);
    console.log(clients);
}

export { ChatOrigin, chatConnect };
