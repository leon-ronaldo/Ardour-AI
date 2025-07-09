// Enums for module and request/response types
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class WSModuleType {
  static const String Account = "Account";
  static const String Chat = "Chat";
  static const String Notification = "Notification";
  static const String Authentication = "Authentication";
}

class AccountReqType {
  static const String CONN_REQ = "CONN_REQ";
  static const String GET_CONTACTS = "GET_CONTACTS";
  static const String GET_GROUPS = "GET_GROUPS";
  static const String PRIVATE_CHAT_HISTORY = "PRIVATE_CHAT_HISTORY";
  static const String GROUP_CHAT_HISTORY = "GROUP_CHAT_HISTORY";
  static const String QUERY_ACCOUNTS = "QUERY_ACCOUNTS";
  static const String RECOMMENDED_ACCOUNTS = "RECOMMENDED_ACCOUNTS";
  static const String MAKE_REQUEST = "MAKE_REQUEST";
  static const String ACCEPT_REQUEST = "ACCEPT_REQUEST";
  static const String GET_RECENT_CHATS_LIST = "GET_RECENT_CHATS_LIST";
}

class AccountResType {
  static const String CONTACT_LIST = "CONTACT_LIST";
  static const String GROUPS_LIST = "GROUPS_LIST";
  static const String PRIVATE_CHAT_HISTORY = "PRIVATE_CHAT_HISTORY";
  static const String GROUP_CHAT_HISTORY = "GROUP_CHAT_HISTORY";
  static const String QUERY_ACCOUNTS_LIST = "QUERY_ACCOUNTS_LIST";
  static const String RECOMMENDED_ACCOUNTS_LIST = "RECOMMENDED_ACCOUNTS_LIST";
  static const String ACCOUNT_REQUEST_MADE = "ACCOUNT_REQUEST_MADE";
  static const String ACCOUNT_REQUEST_ACCEPTED = "ACCOUNT_REQUEST_ACCEPTED";
  static const String RECENT_CHATS_LIST = "RECENT_CHATS_LIST";
}

class ChatReqType {
  static const String START_CHAT = "START_CHAT";
  static const String SEND_MSG = "SEND_MSG";
  static const String FETCH_HISTORY = "FETCH_HISTORY";
  static const String SEND_GROUP_MSG = "SEND_GROUP_MSG";
  static const String IS_USER_ONLINE = "IS_USER_ONLINE";
  static const String SET_IS_ONLINE = "SET_IS_ONLINE";
  static const String SET_IS_TYPING = "SET_IS_TYPING";
}

class ChatResType {
  static const String PRIVATE_CHAT_MESSAGE = "PRIVATE_CHAT_MESSAGE";
  static const String GROUP_CHAT_MESSAGE = "GROUP_CHAT_MESSAGE";
  static const String USER_ONLINE_STATUS = "USER_ONLINE_STATUS";
  static const String USER_TYPING_STATUS = "USER_TYPING_STATUS";
}

class NotificationReqType {
  static const String GET_ACCOUNT_REQUESTS_NOTIFICATIONS =
      "GET_ACCOUNT_REQUESTS_NOTIFICATIONS";
  static const String CHECK_NOTIFICATIONS = "CHECK_NOTIFICATIONS";
}

class NotificationResType {
  static const String ACCOUNT_REQUESTS_NOTIFICATIONS =
      "ACCOUNT_REQUESTS_NOTIFICATIONS";
  static const String DID_HAVE_NOTIFICATIONS = 'DID_HAVE_NOTIFICATIONS';
}

// Base Request Class
class WSBaseRequest<T, R, D> {
  final T type;
  final R reqType;
  final D data;
  final Map<String, dynamic>? meta;

  WSBaseRequest({
    required this.type,
    required this.reqType,
    required this.data,
    this.meta,
  });

  Map<String, dynamic> toJson() => {
    'type': type.toString().split('.').last,
    'reqType': reqType.toString().split('.').last,
    'data': data,
    'meta': meta,
  };
}

// Base Response Class
class WSBaseResponse<T, R, D> {
  final T type;
  final R resType;
  final D data;
  final Map<String, dynamic>? meta;

  WSBaseResponse({
    required this.type,
    required this.resType,
    required this.data,
    this.meta,
  });

  Map<String, dynamic> toJson() => {
    'type': type.toString().split('.').last,
    'resType': resType.toString().split('.').last,
    'data': data,
    'meta': meta,
  };
}
