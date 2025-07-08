import { WSChatRequest, WSChatResponse } from "../utils/types"
import clientManager from "../utils/clientManager";
import WebSocketResponder from "../utils/WSResponder";
import { ErrorCodes } from "../utils/responseCodes";
// import USERS from "../data/Users";
import ChatPool, { IChatMessage, generateChatId } from "../models/ChatPool";
import UserModel from "../models/User";
import GroupChatPool, { IGroupChatMessage } from "../models/GroupChatPool";
import { sendNotification } from "./sendNotification";

async function sendMessage(message: WSChatRequest, responseHandler: WebSocketResponder) {
    const data = message.data as IChatMessage;

    const recipientId = data.to;

    const recipient = await UserModel.findById(recipientId);
    if (!recipient) {
        responseHandler.sendMessageFromCode(ErrorCodes.USER_NOT_FOUND);
        return;
    }

    const chatId = generateChatId(
        responseHandler.user!._id.toString(),
        recipientId,
        responseHandler.user!.createdOn.toISOString(),
        recipient.createdOn.toISOString()
    );

    let chatPool = await ChatPool.findOne({ chatId });

    // console.log(chatPool);

    if (!chatPool) {
        // Create new chat pool
        chatPool = new ChatPool({
            chatId,
            participants: [responseHandler.user!._id.toString(), recipientId].sort(),
            messages: [data]
        });

        await chatPool.save();
    } else {
        chatPool.messages.push(data);
        await chatPool.save();
    }

    console.log("chatPool after saving", chatPool);

    const liveClient = clientManager.getClient(recipientId);
    if (liveClient) {
        const incomingMessage: WSChatResponse = {
            type: "Chat",
            resType: "PRIVATE_CHAT_MESSAGE",
            data: data
        };

        liveClient.send(JSON.stringify({ data: incomingMessage }));
    } else {
        console.log("bro client illa");
        await sendNotification(
            recipientId,
            "New Message",
            responseHandler.user!.username,
            data.message,
            { notificationType: "PERSONAL_CHAT", "senderId": recipientId }
        );
    }
}

async function sendGroupMessage(message: WSChatRequest, responseHandler: WebSocketResponder) {
    const data = message.data as IGroupChatMessage;

    const { groupId, message: msgContent } = data;
    const senderId = responseHandler.user!._id.toString();

    // Step 1: Find GroupChatPool
    const groupPool = await GroupChatPool.findOne({ groupId });

    if (!groupPool) {
        responseHandler.sendMessageFromCode(ErrorCodes.GROUP_NOT_FOUND);
        return;
    }

    // Step 2: Create new group message
    const newMessage: IGroupChatMessage = {
        from: senderId,
        groupId,
        message: msgContent,
        timestamp: Date.now(),
    };

    // Step 3: Broadcast message to all participants (except sender)
    for (const member of groupPool.participants) {
        if (member.userId === senderId) continue;

        const client = clientManager.getClient(member.userId);
        if (client) {
            const response: WSChatResponse = {
                type: "Chat",
                resType: "GROUP_CHAT_MESSAGE",
                data: newMessage,
            };

            client.send(JSON.stringify({ data: response }));
        }
    }

    // Step 4: Store in DB
    groupPool.messages.push(newMessage);
    await groupPool.save();
}

async function getUserIsOnline(message: WSChatRequest, responseHandler: WebSocketResponder) {
    const parsedData = message.data as { userId: string };
    const liveClient = clientManager.getClient(parsedData.userId);

    let response: WSChatResponse;

    if (liveClient) {
        response = {
            type: "Chat",
            resType: "USER_ONLINE_STATUS",
            data: {
                userId: parsedData.userId,
                isOnline: true
            }
        };
    } else {
        response = {
            type: "Chat",
            resType: "USER_ONLINE_STATUS",
            data: {
                userId: parsedData.userId,
                isOnline: false
            }
        };
    }

    console.log(responseHandler.user!._id.toString(), "asked for whether", parsedData.userId, "alive and", response);


    responseHandler.sendData(response)
}

async function setIsOnline(message: WSChatRequest, responseHandler: WebSocketResponder) {
    const { recieverId,
        isOnline } = message.data as { recieverId: string, isOnline: boolean };
    const liveClient = clientManager.getClient(recieverId);

    let response: WSChatResponse = {
        type: "Chat",
        resType: "USER_ONLINE_STATUS",
        data: {
            userId: responseHandler.user!._id.toString(),
            isOnline
        }
    };

    if (liveClient) {
        (new WebSocketResponder(liveClient)).sendData(response)
    }
}

async function setIsTyping(message: WSChatRequest, responseHandler: WebSocketResponder) {
    const { recieverId,
        isTyping } = message.data as { recieverId: string, isTyping: boolean };
    const liveClient = clientManager.getClient(recieverId);

    let response: WSChatResponse = {
        type: "Chat",
        resType: "USER_TYPING_STATUS",
        data: {
            userId: responseHandler.user!._id.toString(),
            isTyping
        }
    };

    if (liveClient) {
        (new WebSocketResponder(liveClient)).sendData(response)
    }
}



export default {
    sendMessage,
    sendGroupMessage,
    getUserIsOnline,
    setIsTyping,
    setIsOnline
}