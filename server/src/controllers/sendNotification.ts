import admin from 'firebase-admin';
import serviceAccount from '/etc/secrets/serviceAccountCert.json';
import UserModel, { IUser } from '../models/User';

// Initialize Firebase Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
});

export type AppNotificationType = "PERSONAL_CHAT"
export type AppNotificationMetaDataType = "senderId"

/**
 * Sends a push notification to a user's device via FCM.
 */
/**
 * Sends a push notification to a user's device via FCM.
 */
export type NotificationMetaData = {
    [key in AppNotificationMetaDataType]?: string | undefined;
} & {
    notificationType?: AppNotificationType;
};

/**
 * Sends an FCM push‑notification containing:
 *  ‑ name          (custom string, e.g. contact or topic)
 *  ‑ headings      (title shown in notification tray)
 *  ‑ content       (body of the notification)
 *  ‑ timestamp     (defaults to Date.now() if not supplied)
 */
export async function sendNotification(
    userId: string,
    name: string,
    headings: string,
    content: string,
    metaData: NotificationMetaData = {},
    timestamp: string = Date.now().toString() // <- add timestamp param
): Promise<void> {
    try {
        const user = (await UserModel.findById(userId).lean()) as IUser;
        const token = user?.FCMtoken;

        if (!token) {
            console.error(`❌ FCM token not found for userId: ${userId}`);
            return;
        }

        const message: admin.messaging.Message = {
            token,
            notification: {
                title: headings,
                body: content,
            },
            android: {
                notification: {
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    priority: 'high',
                    channelId: 'high_importance_channel',
                },
            },
            apns: {
                payload: {
                    aps: {
                        alert: { title: headings, body: content },
                        sound: 'default',
                    },
                },
            },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                notificationType: metaData.notificationType ?? '',
                notificationName: name,
                notificationContent: content,
                timestamp,                 // << added
                ...metaData,               // keep any extra custom fields
            },
        };

        const response = await admin.messaging().send(message);
        console.log(`✅ Notification sent to ${userId}: ${response}`);
    } catch (error) {
        console.error('❌ Error sending notification:', error);
    }
}

