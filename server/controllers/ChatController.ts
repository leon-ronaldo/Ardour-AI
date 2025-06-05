import WebSocket from "ws"
import { WSChatMessage } from "../utils/types"
import clientManager from "../utils/clientManager";
import WebSocketResponder from "../utils/WSResponder";
import { ErrorCodes } from "../utils/responseCodes";
import USERS from "../data/Users";
import ChatPool from "../models/ChatPool";
import crypto from "crypto";

function generateChatId(u1: string, u2: string, time1: string, time2: string): string {
    const [a, b] = [u1, u2].sort();
    const hash = crypto.createHash("md5").update(a + b).digest("hex").slice(0, 8);
    const ts1 = time1.slice(-4);
    const ts2 = time2.slice(-4);
    return hash + ts1 + ts2;
}

async function sendMessage(message: WSChatMessage, responseHandler: WebSocketResponder) {
    // search for user
    const data = message.data as { to: string, message: string };
    const liveClient = clientManager.getClient(data.to)
    const client = USERS.get(data.to)

    if (!client) {
        responseHandler.sendMessageFromCode(ErrorCodes.USER_NOT_FOUND);
        return
    }

    const chatId = generateChatId(responseHandler.id!, data.to, USERS.get(responseHandler.id!)?.createdOn!, USERS.get(data.to)?.createdOn!)
    const chatPool = await ChatPool.findOne({ chatId: chatId })

    if (!liveClient) {
        // save in chatpool
        return
    }

    const sendMessage: WSChatMessage = {
        type: "Chat",
        reqType: "RECEIVE_MSG",
        data: {
            from: responseHandler.id!,
            message: data.message,
            timestamp: new Date().toISOString()
        }
    }

    liveClient.send(JSON.stringify(sendMessage))
}

export {
    sendMessage
}