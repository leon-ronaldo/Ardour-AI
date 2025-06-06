import { IChatMessage } from "../models/ChatPool";
import { IGroupChatMessage } from "../models/GroupChatPool";

export type WSModuleType = "Account" | "Chat" | "Notification" | "Presence";
export type AccountReqType = "CONN_REQ" | "GET_CONTACTS" | "GET_GROUPS" | "PRIVATE_CHAT_HISTORY" | "GROUP_CHAT_HISTORY";
export type AccountResType = "CONTACT_LIST" | "GROUPS_LIST" | "PRIVATE_CHAT_HISTORY" | "GROUP_CHAT_HISTORY";
export type ChatReqType = "START_CHAT" | "SEND_MSG" | "FETCH_HISTORY" | "SEND_GROUP_MSG";
export type ChatResType = "PRIVATE_CHAT_MESSAGE" | "GROUP_CHAT_MESSAGE";

export interface WSBaseRequest<T extends WSModuleType, R extends ChatReqType | AccountReqType, D = any> {
  type: T;        // Domain/module
  reqType: R;     // Specific action/intent
  data: D;        // Payload for this request
  meta?: {
    requestId?: string; // Useful for tracking
    timestamp?: number; // Optional timestamp
  };
}

export interface WSBaseResponse<T extends WSModuleType, R extends ChatResType | AccountResType, D = any> {
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
  | WSBaseRequest<"Account", "CONN_REQ", { userID: string }>
  | WSBaseRequest<"Account", "PRIVATE_CHAT_HISTORY", { userId: string }>
  | WSBaseRequest<"Account", "GROUP_CHAT_HISTORY", { groupId: string }>
  | WSBaseRequest<"Account", "GET_CONTACTS", {}>
  | WSBaseRequest<"Account", "GET_GROUPS", {}>;

// CHAT MODULE
export type WSChatRequest =
  | WSBaseRequest<"Chat", "START_CHAT", { to: string }>
  | WSBaseRequest<"Chat", "SEND_MSG", IChatMessage>
  | WSBaseRequest<"Chat", "SEND_GROUP_MSG", IGroupChatMessage>
  | WSBaseRequest<"Chat", "FETCH_HISTORY", { withUser: string; limit?: number }>;

// UNION TYPE FOR ALL REQUESTS
export type WSClientRequest = WSAccountRequest | WSChatRequest;

// ACCOUNT MODULE
export type WSAccountResponse =
  | WSBaseResponse<"Account", "CONTACT_LIST", { contacts: any[] }>
  | WSBaseResponse<"Account", "GROUPS_LIST", { groups: any[] }>
  | WSBaseResponse<"Account", "PRIVATE_CHAT_HISTORY", { userId: string, messages: IChatMessage[] }>
  | WSBaseResponse<"Account", "GROUP_CHAT_HISTORY", { groupId: string; messages: IGroupChatMessage[] }>;

// CHAT MODULE
export type WSChatResponse =
  | WSBaseResponse<"Chat", "PRIVATE_CHAT_MESSAGE", IChatMessage>
  | WSBaseResponse<"Chat", "GROUP_CHAT_MESSAGE", IGroupChatMessage>;


// UNION TYPE FOR ALL RESPONSES
export type WSClientResponse = WSAccountResponse | WSChatResponse;
