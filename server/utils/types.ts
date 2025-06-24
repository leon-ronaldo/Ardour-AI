import { IChatMessage } from "../models/ChatPool";
import { IGroupChatMessage } from "../models/GroupChatPool";
import { AccountReqNotification, IPassAccountReqNotification, IPassUser } from "../models/User";

export type WSModuleType = "Account" | "Chat" | "Notification" | "Presence" | "Authentication";

export type NotificationReqType = "GET_ACCOUNT_REQUESTS_NOTIFICATIONS"
  | "CHECK_NOTIFICATIONS"
export type NotificationResType = "ACCOUNT_REQUESTS_NOTIFICATIONS"
  | 'DID_HAVE_NOTIFICATIONS'

// Account module types
export type AccountReqType = "UPDATE_PROFILE"
  | "GET_CONTACTS"
  | "GET_GROUPS"
  | "RECOMMENDED_ACCOUNTS"
  | "PRIVATE_CHAT_HISTORY"
  | "GROUP_CHAT_HISTORY"
  | "QUERY_ACCOUNTS"
  | "MAKE_REQUEST"
  | "ACCEPT_REQUEST";
export type AccountResType = "PROFILE_UPDATED"
  | "CONTACT_LIST"
  | "GROUPS_LIST"
  | "QUERY_ACCOUNTS_LIST"
  | "ACCOUNT_REQUEST_MADE"
  | "ACCOUNT_REQUEST_ACCEPTED"
  | "RECOMMENDED_ACCOUNTS_LIST"
  | "PRIVATE_CHAT_HISTORY"
  | "GROUP_CHAT_HISTORY";


// Chat module types
export type ChatReqType = "START_CHAT"
  | "SEND_MSG"
  | "SEND_GROUP_MSG"
  | "SET_IS_ONLINE"
  | "IS_USER_ONLINE"
  | "SET_IS_TYPING";
export type ChatResType = "PRIVATE_CHAT_MESSAGE"
  | "USER_ONLINE_STATUS"
  | "USER_TYPING_STATUS"
  | "GROUP_CHAT_MESSAGE";


// Authenticate module types
export type AuthenticationReqType = "AUTHENTICATE"
  | "AUTHENTICATE_WITH_PASSWORD"
export type AuthenticationResType = "ACCESS_TOKEN"
  | "REFRESH_TOKEN"
  | "AUTH_TOKENS"

export interface WSBaseRequest<T extends WSModuleType, R extends ChatReqType
  | AccountReqType
  | AuthenticationReqType
  | NotificationReqType, D = any> {
  type: T;        // Domain/module
  reqType: R;     // Specific action/intent
  data: D;        // Payload for this request
  meta?: {
    requestId?: string; // Useful for tracking
    timestamp?: number; // Optional timestamp
  };
}

export interface WSBaseResponse<T extends WSModuleType, R extends ChatResType
  | AccountResType
  | AuthenticationResType
  | NotificationResType, D = any> {
  type: T;        // Domain/module
  resType: R;     // Specific response/intent
  data: D;        // Payload for this request
  meta?: {
    requestId?: string; // Useful for tracking
    timestamp?: number; // Optional timestamp
  };
}

// ACCOUNT MODULE
export type WSAccountRequest =
  WSBaseRequest<"Account", "UPDATE_PROFILE", { firstName?: string, lastName?: string, profileImage?: string, userName?: string }>
  | WSBaseRequest<"Account", "MAKE_REQUEST", { userId: string }>
  | WSBaseRequest<"Account", "ACCEPT_REQUEST", { userId: string }>
  | WSBaseRequest<"Account", "QUERY_ACCOUNTS", { query: string }>
  | WSBaseRequest<"Account", "RECOMMENDED_ACCOUNTS">
  | WSBaseRequest<"Account", "PRIVATE_CHAT_HISTORY", { userId: string }>
  | WSBaseRequest<"Account", "GROUP_CHAT_HISTORY", { groupId: string }>
  | WSBaseRequest<"Account", "GET_CONTACTS">
  | WSBaseRequest<"Account", "GET_GROUPS">;

// NOTIFICATION MODULE
export type WSNotificationRequest =
  WSBaseRequest<"Notification", "GET_ACCOUNT_REQUESTS_NOTIFICATIONS">
  | WSBaseRequest<"Notification", "CHECK_NOTIFICATIONS">

// CHAT MODULE
export type WSChatRequest =
  WSBaseRequest<"Chat", "START_CHAT", { to: string }>
  | WSBaseRequest<"Chat", "SEND_MSG", IChatMessage>
  | WSBaseRequest<"Chat", "SET_IS_ONLINE", { recieverId: string, isOnline: boolean }>
  | WSBaseRequest<"Chat", "IS_USER_ONLINE", { userId: string }>
  | WSBaseRequest<"Chat", "SET_IS_TYPING", { isTyping: boolean, recieverId: string }>
  | WSBaseRequest<"Chat", "SEND_GROUP_MSG", IGroupChatMessage>;

// AUTHENTICATION MODULE
export type WSAuthenticationRequest =
  WSBaseRequest<"Authentication", "AUTHENTICATE", { email: string, profileImage?: string, userName?: string }>
  | WSBaseRequest<"Authentication", "AUTHENTICATE_WITH_PASSWORD", { email: string, password: string }>

// UNION TYPE FOR ALL REQUESTS
export type WSClientRequest = WSAccountRequest | WSChatRequest | WSAuthenticationRequest | WSNotificationRequest;

// ACCOUNT MODULE
export type WSAccountResponse =
  WSBaseResponse<"Account", "PROFILE_UPDATED", { updatedProfile: { firstName?: string, lastName?: string, profileImage?: string, userName?: string } }>
  | WSBaseResponse<"Account", "CONTACT_LIST", { contacts: IPassUser[] }>
  | WSBaseResponse<"Account", "ACCOUNT_REQUEST_MADE", { success: boolean }>
  | WSBaseResponse<"Account", "ACCOUNT_REQUEST_ACCEPTED", { success: boolean, userName: string }>
  | WSBaseResponse<"Account", "GROUPS_LIST", { groups: any[] }>
  | WSBaseResponse<"Account", "QUERY_ACCOUNTS_LIST", { matchedQueries: IPassUser[] }>
  | WSBaseResponse<"Account", "RECOMMENDED_ACCOUNTS_LIST", { recommendedUsers: IPassUser[] }>
  | WSBaseResponse<"Account", "PRIVATE_CHAT_HISTORY", { userId: string, messages: IChatMessage[] }>
  | WSBaseResponse<"Account", "GROUP_CHAT_HISTORY", { groupId: string; messages: IGroupChatMessage[] }>;


// NOTIFICATION MODULE
export type WSNotificationResponse =
  WSBaseResponse<"Notification", "ACCOUNT_REQUESTS_NOTIFICATIONS", { accountRequestNotifications: IPassAccountReqNotification[] }>
  | WSBaseResponse<"Notification", "DID_HAVE_NOTIFICATIONS", { didHaveNotification: boolean }>


// CHAT MODULE
export type WSChatResponse =
  WSBaseResponse<"Chat", "PRIVATE_CHAT_MESSAGE", IChatMessage>
  | WSBaseResponse<"Chat", "GROUP_CHAT_MESSAGE", IGroupChatMessage>
  | WSBaseResponse<"Chat", "USER_ONLINE_STATUS", { userId: string, isOnline: boolean }>
  | WSBaseResponse<"Chat", "USER_TYPING_STATUS", { userId: string, isTyping: boolean }>;


// AUTHENTICATION MODULE
export type WSAuthentiacationResponse =
  WSBaseResponse<"Authentication", "AUTH_TOKENS", { accessToken: string, refreshToken: string, userId: string, profileImage?: string }>
  | WSBaseResponse<"Authentication", "ACCESS_TOKEN", { accessToken: string, userId: string, profileImage?: string }>
  | WSBaseResponse<"Authentication", "REFRESH_TOKEN", { refreshToken: string, userId: string, profileImage?: string }>

// UNION TYPE FOR ALL RESPONSES
export type WSClientResponse = WSAccountResponse | WSChatResponse | WSAuthentiacationResponse | WSNotificationResponse;
