import ChatPool, { IChatMessage, generateChatId } from "../models/ChatPool";
import GroupChatPool, { IGroupChatMessage } from "../models/GroupChatPool";
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
            userId: recipientId,
            messages
        }
    }

    responseHandler.sendData(data)
}

async function getGroups(responseHandler: WebSocketResponder) {
    const userId = responseHandler.user!._id.toString();

    const groups = await GroupChatPool.find({ participants: userId }).select("groupId name participants");

    const data: WSAccountResponse = {
        type: "Account",
        resType: "GROUPS_LIST",
        data: { groups }
    };

    responseHandler.sendData(data);
}

// Return group chat history
async function getGroupChatHistory(responseHandler: WebSocketResponder, message: WSAccountRequest) {
    const groupId = (message.data as { groupId: string }).groupId;

    const groupChat = await GroupChatPool.findOne({ groupId });

    if (!groupChat) {
        responseHandler.sendMessageFromCode(ErrorCodes.GROUP_NOT_FOUND);
        return;
    }

    const messages: IGroupChatMessage[] = groupChat.messages;

    const data: WSAccountResponse = {
        type: "Account",
        resType: "GROUP_CHAT_HISTORY",
        data: {
            groupId,
            messages
        }
    };

    responseHandler.sendData(data);
}

export default {
    getContacts,
    getGroups,
    getPrivateChatHistory,
    getGroupChatHistory
}
