import { WSChatRequest, WSChatResponse } from "../utils/types"
import clientManager from "../utils/clientManager";
import WebSocketResponder from "../utils/WSResponder";
import { ErrorCodes } from "../utils/responseCodes";
// import USERS from "../data/Users";
import ChatPool, { IChatMessage, generateChatId } from "../models/ChatPool";
import UserModel from "../models/User";

async function sendMessage(message: WSChatRequest, responseHandler: WebSocketResponder) {
    const data = message.data as { to: string; message: string };

    const recipientId = data.to;

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

    // Step 3: Create message
    const newMessage: IChatMessage = {
        from: responseHandler.user!._id.toString(),
        to: recipientId,
        message: data.message,
        timestamp: Date.now()
    };

    // Step 4: Check if recipient is online
    const liveClient = clientManager.getClient(recipientId);
    if (liveClient) {
        const incomingMessage: WSChatResponse = {
            type: "Chat",
            resType: "PRIVATE_CHAT_MESSAGE",
            data: {
                from: responseHandler.user!._id.toString(),
                message: data.message,
                to: recipientId,
                timestamp: Date.now()
            }
        };

        console.log("brooo", liveClient);

        liveClient.send(JSON.stringify({ data: incomingMessage }));
    }

    // Step 5. store in chatpool
    let chatPool = await ChatPool.findOne({ chatId });

    console.log(chatPool);

    if (!chatPool) {
        // Create new chat pool
        chatPool = new ChatPool({
            chatId,
            participants: [responseHandler.user!._id.toString(), recipientId].sort(),
            messages: [newMessage]
        });

        console.log("gotha", chatPool);

        await chatPool.save();
    } else {
        chatPool.messages.push(newMessage);
        await chatPool.save();

        console.log("ada dei", chatPool)
    }
}


export default {
    sendMessage
}