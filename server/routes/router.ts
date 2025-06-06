import WebSocket from "ws";
import { WSChatRequest, WSClientRequest, ChatReqType, WSAccountRequest } from "../utils/types";
import WebSocketResponder from "../utils/WSResponder";
import chatOperations from "../controllers/ChatController";
import accountsOperations from '../controllers/AccountsController';
import { ErrorCodes } from "../utils/responseCodes";

export default function AppRouter(ws: WebSocket, rawData: string, responseHandler: WebSocketResponder) {
    let msg: WSClientRequest;

    try {
        msg = JSON.parse(rawData);
        console.log(msg);
    } catch {
        return responseHandler.invalidParametersError();
    }

    switch (msg.type) {
        case "Account":
            return accountRouter(responseHandler, msg as WSAccountRequest);
        case "Chat":
            return chatRouter(responseHandler, msg as WSChatRequest);
        default:
            return responseHandler.sendMessageFromCode(ErrorCodes.UNKNOWN_ACTION_TYPE);
    }

}

function chatRouter(responder: WebSocketResponder, message: WSChatRequest) {
    switch (message.reqType) {
        case "SEND_MSG":
            return chatOperations.sendMessage(message, responder)
        case "FETCH_HISTORY":
            return
        default:
            return responder.sendMessageFromCode(ErrorCodes.UNKNOWN_ACTION_TYPE)
    }
}

function accountRouter(responder: WebSocketResponder, message: WSAccountRequest) {
    switch (message.reqType) {
        case "GET_CONTACTS":
            return accountsOperations.getContacts(responder)
        case "PRIVATE_CHAT_HISTORY":
            return accountsOperations.getPrivateChatHistory(responder, message)
        case "LOGOUT":
            return
        default:
            return
    }
}
