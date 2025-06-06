import ChatPool, { IChatMessage, generateChatId } from "../models/ChatPool";
import UserModel from "../models/User";
import WebSocketResponder from "../utils/WSResponder";
import { ErrorCodes } from "../utils/responseCodes";
import { WSAccountRequest, WSAccountResponse } from "../utils/types";

function getContacts(responseHandler: WebSocketResponder) {
    const data: WSAccountResponse = {
        type: "Account",
        resType: "CONTACT_LIST",
        data: { contacts: responseHandler.user!.contacts }
    }
    responseHandler.sendData(data)
}

async function getPrivateChatHistory(responseHandler: WebSocketResponder, message: WSAccountRequest) {

    const recipientId = (message.data as { userId: string }).userId;
    let messages: IChatMessage[] = [];

    // Step 1: Fetch recipient user
    const recipient = await UserModel.findById(recipientId);

    if (!recipient) {
        responseHandler.sendMessageFromCode(ErrorCodes.USER_NOT_FOUND);
        return;
    }

    // Step 2: Generate consistent chatId
    const chatId = generateChatId(
        responseHandler.user!._id.toString(),
        recipientId,
        responseHandler.user!.createdOn.toISOString(),
        recipient.createdOn.toISOString()
    );

    let chatPool = await ChatPool.findOne({ chatId });

    console.log(chatPool);

    if (chatPool) {
        messages = chatPool.messages;
    }

    const data: WSAccountResponse = {
        type: "Account",
        resType: "PRIVATE_CHAT_HISTORY",
        data: {
            messages
        }
    }

    responseHandler.sendData(data)
}

export default {
    getContacts,
    getPrivateChatHistory
}
