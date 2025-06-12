import { IChatMessage } from "../models/ChatPool";
import { IGroupChatMessage } from "../models/GroupChatPool";

export type WSModuleType = "Account" | "Chat" | "Notification" | "Presence" | "Authentication";
export type AccountReqType = "UPDATE_PROFILE"
  | "GET_CONTACTS"
  | "GET_GROUPS"
  | "PRIVATE_CHAT_HISTORY"
  | "GROUP_CHAT_HISTORY"
  | "QUERY_ACCOUNTS"
  | "MAKE_REQUEST"
  | "ACCEPT_REQUEST";
export type AccountResType = "PROFILE_UPDATED"
  | "CONTACT_LIST"
  | "GROUPS_LIST"
  | "QUERY_ACCOUNTS_LIST"
  | "PRIVATE_CHAT_HISTORY"
  | "GROUP_CHAT_HISTORY";
export type ChatReqType = "START_CHAT" | "SEND_MSG" | "FETCH_HISTORY" | "SEND_GROUP_MSG";
export type ChatResType = "PRIVATE_CHAT_MESSAGE" | "GROUP_CHAT_MESSAGE";
export type AuthenticationReqType = "AUTHENTICATE"
export type AuthenticationResType = "ACCESS_TOKEN" | "REFRESH_TOKEN" | "AUTH_TOKENS"

export interface WSBaseRequest<T extends WSModuleType, R extends ChatReqType | AccountReqType | AuthenticationReqType, D = any> {
  type: T;        // Domain/module
  reqType: R;     // Specific action/intent
  data: D;        // Payload for this request
  meta?: {
    requestId?: string; // Useful for tracking
    timestamp?: number; // Optional timestamp
  };
}

export interface WSBaseResponse<T extends WSModuleType, R extends ChatResType | AccountResType | AuthenticationResType, D = any> {
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
  | WSBaseRequest<"Account", "MAKE_REQUEST", { userID: string }>
  | WSBaseRequest<"Account", "ACCEPT_REQUEST", { userID: string }>
  | WSBaseRequest<"Account", "QUERY_ACCOUNTS", { query: string }>
  | WSBaseRequest<"Account", "PRIVATE_CHAT_HISTORY", { userId: string }>
  | WSBaseRequest<"Account", "GROUP_CHAT_HISTORY", { groupId: string }>
  | WSBaseRequest<"Account", "GET_CONTACTS", {}>
  | WSBaseRequest<"Account", "GET_GROUPS", {}>;

// CHAT MODULE
export type WSChatRequest =
  WSBaseRequest<"Chat", "START_CHAT", { to: string }>
  | WSBaseRequest<"Chat", "SEND_MSG", IChatMessage>
  | WSBaseRequest<"Chat", "SEND_GROUP_MSG", IGroupChatMessage>
  | WSBaseRequest<"Chat", "FETCH_HISTORY", { withUser: string; limit?: number }>;

// AUTHENTICATION MODULE
export type WSAuthenticationRequest =
  WSBaseRequest<"Authentication", "AUTHENTICATE", { email: string, profileImage?: string, userName?: string }>

// UNION TYPE FOR ALL REQUESTS
export type WSClientRequest = WSAccountRequest | WSChatRequest | WSAuthentiacationResponse;

// ACCOUNT MODULE
export type WSAccountResponse =
  WSBaseResponse<"Account", "PROFILE_UPDATED", { updatedProfile: { firstName?: string, lastName?: string, profileImage?: string, userName?: string } }>
  | WSBaseResponse<"Account", "CONTACT_LIST", { contacts: any[] }>
  | WSBaseResponse<"Account", "GROUPS_LIST", { groups: any[] }>
  | WSBaseResponse<"Account", "QUERY_ACCOUNTS_LIST", { matchedQueries: { userName: string, userId: string }[] }>
  | WSBaseResponse<"Account", "PRIVATE_CHAT_HISTORY", { userId: string, messages: IChatMessage[] }>
  | WSBaseResponse<"Account", "GROUP_CHAT_HISTORY", { groupId: string; messages: IGroupChatMessage[] }>;

// CHAT MODULE
export type WSChatResponse =
  WSBaseResponse<"Chat", "PRIVATE_CHAT_MESSAGE", IChatMessage>
  | WSBaseResponse<"Chat", "GROUP_CHAT_MESSAGE", IGroupChatMessage>;


// AUTHENTICATION MODULE
export type WSAuthentiacationResponse =
  WSBaseResponse<"Authentication", "AUTH_TOKENS", { accessToken: string, refreshToken: string }>
  | WSBaseResponse<"Authentication", "ACCESS_TOKEN", { accessToken: string }>
  | WSBaseResponse<"Authentication", "REFRESH_TOKEN", { refreshToken: string }>

// UNION TYPE FOR ALL RESPONSES
export type WSClientResponse = WSAccountResponse | WSChatResponse | WSAuthentiacationResponse;
