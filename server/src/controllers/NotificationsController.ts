import UserModel, { IPassAccountReqNotification } from "../models/User";
import WebSocketResponder from "../utils/WSResponder";
import { ErrorCodes } from "../utils/responseCodes";
import { WSNotificationResponse } from "../utils/types";

async function checkNotifications(responseHandler: WebSocketResponder) {
    const user = await UserModel.findById(responseHandler.user!._id);
    if (!user) {
        responseHandler.sendMessageFromCode(ErrorCodes.USER_NOT_FOUND);
        return;
    }

    const response: WSNotificationResponse = {
        type: "Notification",
        resType: "DID_HAVE_NOTIFICATIONS",
        data: {
            didHaveNotification:
                responseHandler.user!.notifications.postNotifications.length !== 0
                ||
                responseHandler.user!.notifications.accountReqNotifications.length !== 0
        }
    }

    responseHandler.sendData(response)
}

async function getAccountRequestNotifications(responseHandler: WebSocketResponder) {
    const user = await UserModel.findById(responseHandler.user!._id);
    if (!user) {
        responseHandler.sendMessageFromCode(ErrorCodes.USER_NOT_FOUND);
        return;
    }

    const users = await UserModel.find({
        _id: {
            $in: user.notifications.accountReqNotifications.map((notification) => notification.userId)
        }
    });

    const notificationUsers: IPassAccountReqNotification[] = user.notifications.accountReqNotifications.map(notification => {
        const matchedUser = users.find(u => u._id.toString() === notification.userId.toString());

        return {
            userId: matchedUser?._id.toString() ?? "Unknown Id",
            userName: matchedUser?.username ?? "Unknown User",
            profileImage: matchedUser?.image,
            timeStamp: notification.timeStamp
        };
    });

    const response: WSNotificationResponse = {
        type: "Notification",
        resType: "ACCOUNT_REQUESTS_NOTIFICATIONS",
        data: {
            accountRequestNotifications: notificationUsers
        }
    }

    responseHandler.sendData(response)
}

export default {
    checkNotifications,
    getAccountRequestNotifications
}