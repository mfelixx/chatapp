class ChatSummary {
  List<String>? connection;
  int? totalChats;
  int? totalRead;
  int? totalUnread;
  List<ChatMessage>? chat;
  String? lastTime;

  ChatSummary({
    this.connection,
    this.chat,
  });

  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    var chatList = json['chat'] as List;
    List<ChatMessage> chatItems =
        chatList.map((chat) => ChatMessage.fromJson(chat)).toList();

    return ChatSummary(
      connection: List<String>.from(json['connection']),
      chat: chatItems,
    );
  }
}

class ChatMessage {
  String? pengirim;
  String? penerima;
  String? pesan;
  String? time;
  bool? isRead;

  ChatMessage({
    this.pengirim,
    this.penerima,
    this.pesan,
    this.time,
    this.isRead,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      pesan: json['pesan'],
      time: json['time'],
      isRead: json['isRead'],
    );
  }
}
