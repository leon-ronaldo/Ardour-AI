import ChatPool, { IChatMessage, generateChatId } from "../models/ChatPool";
import GroupChatPool, { IGroupChatMessage } from "../models/GroupChatPool";
import UserModel, { IPassUser, IUser } from "../models/User";
import mongoose from "mongoose";
import WebSocketResponder from "../utils/WSResponder";
import { ErrorCodes } from "../utils/responseCodes";
import { WSAccountRequest, WSAccountResponse } from "../utils/types";
import { insertWithoutDuplicate, remove } from "../utils/tools";

async function getContacts(responseHandler: WebSocketResponder) {

    const contactIds = responseHandler.user!.contacts;

    const contacts: IPassUser[] = (
        await UserModel.find({ _id: { $in: contactIds } })
    ).map(user => ({
        userId: user._id.toString(), userName: user.username, profileImage: user.image
    }))

    const data: WSAccountResponse = {
        type: "Account",
        resType: "CONTACT_LIST",
        data: { contacts }
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

// Query accounts
async function queryAccounts(responseHandler: WebSocketResponder, message: WSAccountRequest) {
    const query = (message.data as { query: string }).query.toLowerCase()

    const queriedAccounts = (await UserModel.find({}) as IUser[]).filter((account) =>
        (account.username.toLowerCase().includes(query)
            || account.firstName?.toLowerCase().includes(query)
            || account.lastName?.toLowerCase().includes(query)
            || account.email.toLowerCase().includes(query)) && account.email !== responseHandler.user!.email
    );

    const response: WSAccountResponse = {
        type: "Account",
        resType: "QUERY_ACCOUNTS_LIST",
        data: {
            matchedQueries: queriedAccounts.map((user: IUser) => ({ userName: user.username, userId: user._id.toString(), profileImage: user.image }))
        }
    }

    responseHandler.sendData(response)
}

// Update Profile
async function updateAccount(responseHandler: WebSocketResponder, message: WSAccountRequest) {
    const data = message.data as { firstName?: string, lastName?: string, profileImage?: string, userName?: string }

    const user = await UserModel.findById(responseHandler.user?._id)

    if (!user) {
        responseHandler.sendMessageFromCode(ErrorCodes.USER_NOT_FOUND);
        return
    }

    if (data.firstName !== undefined) user.firstName = data.firstName;
    if (data.lastName !== undefined) user.lastName = data.lastName;
    if (data.userName !== undefined) user.username = data.userName;
    if (data.profileImage !== undefined) user.image = data.profileImage;

    try {
        await user.save();

        const response: WSAccountResponse = {
            type: "Account",
            resType: "PROFILE_UPDATED",
            data: {
                updatedProfile: {
                    firstName: user.firstName,
                    lastName: user.lastName,
                    userName: user.username,
                    // profileImage: user.image,
                }
            }
        }

        responseHandler.sendData(response);
    } catch (err) {
        console.error("Error updating user:", err);
        responseHandler.sendMessageFromCode(ErrorCodes.INTERNAL_SERVER_ERROR);
    }
}

// Add accounts recommendation
async function getAccountsRecommendation(responseHandler: WebSocketResponder, message: WSAccountRequest) {
    // const query = (message.data as { query: string }).query.toLowerCase()

    const currentUser = responseHandler.user!

    let allAccounts = (await UserModel.find({}) as IUser[]).filter((user: IUser) => user._id !== currentUser._id);
    const accountsThatAreFriendsToUser = allAccounts.filter((user: IUser) => user.contacts.includes(currentUser._id))
    let recommended: IUser[] = []

    if (accountsThatAreFriendsToUser.length === 0) {
        allAccounts = allAccounts.sort((u1, u2) => (u1.contacts.length > u2.contacts.length ? 1 : 0));
        recommended = allAccounts.slice(0, allAccounts.length < 10 ? allAccounts.length : 10)
    }
    else {
        let recommendedIds: mongoose.Types.ObjectId[] = [];

        for (var user of accountsThatAreFriendsToUser) {
            console.log(`for each item: ${user.contacts.filter((accountId) => accountId !== currentUser._id && !currentUser.contacts.includes(accountId) && recommendedIds.includes(accountId))}`);
            recommendedIds = [...recommendedIds, ...user.contacts.filter((accountId) => accountId !== currentUser._id && !currentUser.contacts.includes(accountId) && recommendedIds.includes(accountId))]
        }

        console.log("recommended ids:", recommendedIds);

        recommended = allAccounts.filter((user) => recommendedIds.includes(user._id));

        console.log("recommended users: ", recommended);
    }


    const response: WSAccountResponse = {
        type: "Account",
        resType: "RECOMMENDED_ACCOUNTS_LIST",
        data: {
            recommendedUsers: recommended.map((user: IUser) => ({ userName: user.username, userId: user._id.toString(), profileImage: user.image }))
        }
    }

    responseHandler.sendData(response)
}

// Make friend request
async function makeFriendRequest(responseHandler: WebSocketResponder, message: WSAccountRequest) {
    let data = message.data as { userId: string }

    let user = await UserModel.findById(data.userId);

    if (!user) {
        responseHandler.sendMessageFromCode(ErrorCodes.USER_NOT_FOUND)
        return;
    }

    try {
        if (!user.friendRequests.includes(responseHandler.user!._id)) {
            user.friendRequests.push(responseHandler.user!._id);
            user.notifications.accountReqNotifications.push({
                userId: responseHandler.user!._id.toString(),
                timeStamp: Date.now()
            })
            await user.save();
        }

        const response: WSAccountResponse = {
            type: "Account",
            resType: "ACCOUNT_REQUEST_MADE",
            data: {
                success: true
            }
        }

        responseHandler.sendData(response)
    } catch (error) {
        console.error("make request error", error);
        responseHandler.sendMessageFromCode(ErrorCodes.INTERNAL_SERVER_ERROR)
    }
}

// Accept friend request
async function acceptFriendRequest(responseHandler: WebSocketResponder, message: WSAccountRequest) {
    let data = message.data as { userId: string };
    let theOneWhoAccepts = responseHandler.user!; // current user

    let theOneWhoIsBeingAccepted = await UserModel.findById(data.userId);

    if (!theOneWhoIsBeingAccepted) {
        responseHandler.sendMessageFromCode(ErrorCodes.USER_NOT_FOUND)
        return;
    }

    if (!theOneWhoAccepts.friendRequests.includes(theOneWhoIsBeingAccepted._id)) {
        return;
    }

    try {
        // remove id from friendRequests list
        theOneWhoAccepts.
            friendRequests = theOneWhoAccepts.
                friendRequests.filter(accountId => !accountId.equals(theOneWhoIsBeingAccepted!._id));

        // remove notification
        theOneWhoAccepts.
            notifications.
            accountReqNotifications = theOneWhoAccepts.
                notifications.
                accountReqNotifications.
                filter((notification) => notification.userId !== theOneWhoIsBeingAccepted!._id.toString());

        // add account id as friends list
        insertWithoutDuplicate(theOneWhoAccepts.contacts, theOneWhoIsBeingAccepted._id);
        insertWithoutDuplicate(theOneWhoIsBeingAccepted.contacts, theOneWhoAccepts._id);

        await theOneWhoAccepts.save();
        await theOneWhoIsBeingAccepted.save();

        const response: WSAccountResponse = {
            type: "Account",
            resType: "ACCOUNT_REQUEST_ACCEPTED",
            data: {
                success: true,
                userName: theOneWhoIsBeingAccepted!.username
            }
        }

        responseHandler.sendData(response)
    } catch (error) {
        console.error("accept request error", error);
        responseHandler.sendMessageFromCode(ErrorCodes.INTERNAL_SERVER_ERROR)
    }
}

export default {
    getContacts,
    getGroups,
    getPrivateChatHistory,
    getGroupChatHistory,
    queryAccounts,
    getAccountsRecommendation,
    updateAccount,
    makeFriendRequest,
    acceptFriendRequest
}
