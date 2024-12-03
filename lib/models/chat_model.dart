class ChatModel {
  final String? msg;
  final int chatIndex;

  ChatModel({required this.msg, required this.chatIndex});
   factory ChatModel.fromJson(Map<String?, dynamic> json) {
    return ChatModel(
      msg: json['msg'].toString(), // Allow null without default value
      chatIndex: json['chatIndex'] as int, // Allow null
    );
  }
}