const User = require("../models/UserModel");
const Chat = require("../models/ChatModel")

// Helper function to handle user connection
const handleUserConnection = async (ws, req) => {
    const urlParams = new URL(req.url, `http://${req.headers.host}`).searchParams;
    const currentUserId = urlParams.get('userId');
    console.log(`User ${currentUserId} connected`);

    // Update user online status
    await User.findByIdAndUpdate(currentUserId, { isOnline: true });

    ws.currentUserId = currentUserId;  // Attach userId to WebSocket instance
};

// Helper function to update user status when they disconnect
const updateUserStatus = async (userId, status) => {
    await User.findByIdAndUpdate(userId, { isOnline: status });
};

// Helper function to handle incoming messages
const handleMessage = async (ws, message) => {
    const { senderId, receiverId, content } = JSON.parse(message);
    console.log(`Message from ${senderId} to ${receiverId}: ${content}`);

    // Create or update chat between sender and receiver
    const chat = await createOrUpdateChat(senderId, receiverId, content);

    // Send message to receiver if they are online, else log a notification
    await sendMessageToReceiver(receiverId, ws, senderId, content);
};

// Helper function to create or update a chat
const createOrUpdateChat = async (senderId, receiverId, content) => {
    let chat = await Chat.findOne({
        $or: [
            { user1: senderId, user2: receiverId },
            { user1: receiverId, user2: senderId },
        ],
    });

    if (!chat) {
        // If no chat exists, create one
        chat = new Chat({
            user1: senderId,
            user2: receiverId,
            messages: [{ senderId, message: content }],
        });
        await chat.save();

        // Add chat to both users' chats list
        await User.findByIdAndUpdate(senderId, { $push: { chats: chat._id } });
        await User.findByIdAndUpdate(receiverId, { $push: { chats: chat._id } });
    } else {
        // If chat exists, add the new message
        chat.messages.push({ senderId, message: content });
        await chat.save();
    }

    return chat;
};

// Helper function to send message to receiver if online
const sendMessageToReceiver = async (receiverId, ws, senderId, content) => {
    const receiver = await User.findById(receiverId);

    if (receiver && receiver.isOnline) {
        // If receiver is online, send the message
        ws.send(JSON.stringify({ senderId, message: content }));
    } else {
        // If receiver is offline, log a notification
        logOfflineNotification(receiverId, senderId, content);
    }
};

// Helper function to log a notification for offline users
const logOfflineNotification = (receiverId, senderId, content) => {
    console.log(`Notification: User ${receiverId} is offline. Message from ${senderId} stored in DB: ${content}`);
};

module.exports = {
    handleUserConnection,
    updateUserStatus,
    handleMessage,
    createOrUpdateChat,
    sendMessageToReceiver,
    logOfflineNotification,
}