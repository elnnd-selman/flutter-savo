import 'package:flutter/material.dart';

class ProjectModel {
  final String? id;
  final String? userId;
  final String? title;
  final String? description;
  final double? price;
  final List? imageUrl;
  final String? category;
  final List? likes;
  final Map? comments;
  final List? saveList;
  final String? date;
  final List? tags;
  ProjectModel(
      {@required this.id,
      @required this.tags,
      @required this.date,
      this.userId,
      @required this.title,
      @required this.description,
      this.price,
      this.imageUrl,
      @required this.category,
      this.likes,
      @required this.comments,
      this.saveList});
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
        id: json['id'],
        date: json['date'],
        tags: json['tags'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        imageUrl: json['imageUrl'],
        category: json['category'],
        likes: json['likes'],
        comments: json['comments'],
        saveList: json['saveList'],
        userId: json['userId']);
  }
  Map<String, dynamic> toMap() {
    return {
      'tags': tags,
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'likes': likes,
      'comments': comments,
      'saveList': saveList,
      'date': date,
      'userId': userId
    };
  }
}
