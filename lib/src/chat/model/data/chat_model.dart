
class ChatModel {
  ChatModel({required this.prompt, required this.isMe, this.index});

  String prompt;
  bool isMe;
  int? index;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        prompt: json["prompt"],
        isMe: json["isMe"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "prompt": prompt,
        "isMe": isMe,
        "index": index,
      };
}