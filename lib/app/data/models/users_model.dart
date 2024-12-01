class UsersModel {
  String? uid;
  String? displayName;
  String? keyName;
  String? email;
  String? createdAt;
  String? lastLogin;
  String? photoUrl;
  String? status;
  String? updateAt;
  List<Chat>? chats;

  UsersModel({
    this.uid,
    this.displayName,
    this.keyName,
    this.email,
    this.createdAt,
    this.lastLogin,
    this.photoUrl,
    this.status,
    this.updateAt,
    this.chats,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    // var chatList = json['chats'] as List;
    // List<Chat> chatItems = chatList.map((chat) => Chat.fromJson(chat)).toList();

    return UsersModel(
      uid: json['uid'],
      displayName: json['displayName'],
      keyName: json['keyName'],
      email: json['email'],
      createdAt: json['createdAt'],
      lastLogin: json['lastLogin'],
      photoUrl: json['photoUrl'],
      status: json['status'],
      updateAt: json['updateAt'],
      // chats: chatItems,
    );
  }
}

class Chat {
  String? connection;
  String? chatId;
  String? lastTime;
  int? totalUnread;

  Chat({
    this.connection,
    this.chatId,
    this.lastTime,
    this.totalUnread,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      connection: json['connection'] ?? '',
      chatId: json['chat_id'] ?? '',
      lastTime: json['lastTime'],
      totalUnread: json['totalUnread'],
    );
  }
}
