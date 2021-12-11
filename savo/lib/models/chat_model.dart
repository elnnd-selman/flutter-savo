import 'package:flutter/material.dart';

class ChatModelM {
  final List? userChat;
  final List? users;
  final String? date;
  final String? chatId;
  final String tokenSecound;

  ChatModelM({
    required this.tokenSecound,
    this.chatId,
    this.date,
    this.users,
    this.userChat,
  });

  factory ChatModelM.fromJson(Map<String, dynamic> json) {
    return ChatModelM(
        userChat: json['userChat'],
        date: json['date'],
        users: json['users'],
        chatId: json['chatId'],
        tokenSecound: json['tokenSecound']);
  }
  Map<String, dynamic> toMap() {
    return {
      'tokenSecound': tokenSecound,
      'userChat': userChat,
      'date': date,
      'users': users,
      'chatId': chatId
    };
  }
}

////////////////////
class ChatModel {
  final String? userId;
  final String? mass;
  final String? date;

  ChatModel({
    this.userId,
    this.date,
    this.mass,
  });

  // factory ChatModel.fromJson(Map<String, dynamic> json) {
  //   return ChatModel(
  //     id: json['id'],
  //     mass: json['mass'],
  //   );
  // }
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'mass': mass,
  //   };
  // }
}
