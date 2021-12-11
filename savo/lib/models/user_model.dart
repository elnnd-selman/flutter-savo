import 'package:flutter/material.dart';

class UserModel {
  final String? id;
  final Map? rating;
  final String? name;
  final String? date;
  final String? gender;
  final String? email;
  final Map? location;
  final String? avatar;
  final String? experience;
  final String? language;
  final Map? listOfExperiences;
  final Map? ListOfLanguages;
  final List? tags;
  final String token;
  UserModel({
    required this.token,
    required this.rating,
    this.language,
    required this.id,
    this.location,
    this.tags,
    this.gender,
    this.avatar,
    @required this.email,
    @required this.name,
    this.date,
    this.experience,
    this.listOfExperiences,
    this.ListOfLanguages,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      location: json['location'],
      tags: json['tags'],
      gender: json['gender'],
      avatar: json['avatar'],
      email: json['email'],
      name: json['name'],
      date: json['date'],
      language: json['language'],
      experience: json['experience'],
      listOfExperiences: json['listOfExperiences'],
      ListOfLanguages: json['ListOfLanguages'],
      rating: json['rating'], token:json['token'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'token':token,
      'id': id,
      'rating': rating,
      'language': language,
      'location': location,
      'tags': tags,
      'gender': gender,
      'avatar': avatar,
      'email': email,
      'name': name,
      'date': date,
      'experience': experience,
      'listOfExperiences': listOfExperiences,
      'ListOfLanguages': ListOfLanguages,
    };
  }
}
