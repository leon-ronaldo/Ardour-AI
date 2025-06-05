import WebSocket from "ws";
import { WSChatMessage, WSClientMessage, ChatReqType } from "../utils/types";
import WebSocketResponder from "../utils/WSResponder";
import { sendMessage } from "../controllers/ChatController";
import { ErrorCodes } from "../utils/responseCodes";

export default function AppRouter(ws: WebSocket, rawData: string, responseHandler: WebSocketResponder) {
    let msg: WSClientMessage;

    try {
        msg = JSON.parse(rawData);
    } catch {
        return responseHandler.invalidParametersError();
    }

    switch (msg.type) {
        case "Account":
            return accountRouter(ws, msg);
        case "Chat":
            return chatRouter(responseHandler, msg as WSChatMessage);
        default:
            return responseHandler.sendMessageFromCode(ErrorCodes.UNKNOWN_ACTION_TYPE);
    }

}

function chatRouter(responder: WebSocketResponder, message: WSChatMessage) {
    switch (message.reqType) {
        case "SEND_MSG":
            return sendMessage(message, responder)
        case "FETCH_HISTORY":
            return
        default:
            return
    }
}

function accountRouter(ws: WebSocket, message: WSClientMessage) {

}
