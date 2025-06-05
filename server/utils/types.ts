export type WSModuleType = "Account" | "Chat" | "Notification" | "Presence";
export type AccountReqType = "CONN_REQ" | "LOGIN" | "LOGOUT";
export type ChatReqType = "START_CHAT" | "SEND_MSG" | "FETCH_HISTORY";

export interface WSBaseMessage<T extends WSModuleType, R extends string, D = any> {
  type: T;        // Domain/module
  reqType: R;     // Specific action/intent
  data: D;        // Payload for this request
  meta?: {
    requestId?: string; // Useful for tracking
    timestamp?: number; // Optional timestamp
  };
}

// ACCOUNT MODULE
export type WSAccountMessage = 
  | WSBaseMessage<"Account", "CONN_REQ", { userID: string }>
  | WSBaseMessage<"Account", "LOGIN", { username: string; password: string }>
  | WSBaseMessage<"Account", "LOGOUT", { userID: string }>;

// CHAT MODULE
export type WSChatMessage =
  | WSBaseMessage<"Chat", "START_CHAT", { to: string }>
  | WSBaseMessage<"Chat", "SEND_MSG", { to: string; message: string }>
  | WSBaseMessage<"Chat", "FETCH_HISTORY", { withUser: string; limit?: number }>
  | WSBaseMessage<"Chat", "RECEIVE_MSG", { from: string; message: string; timestamp: string }>;

// UNION TYPE FOR ALL MESSAGES
export type WSClientMessage = WSAccountMessage | WSChatMessage;
