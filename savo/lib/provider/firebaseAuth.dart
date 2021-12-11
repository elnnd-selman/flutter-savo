import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/testing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:main/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:main/provider/firestore.dart';

class FireAuth with ChangeNotifier {
  FirebaseAuth _fireAuth = FirebaseAuth.instance;
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  FirebaseStorage _avatarStorage = FirebaseStorage.instance;
  FirebaseMessaging _fbm = FirebaseMessaging.instance;
  Future<void>? signIn({name, email, password}) async {
    await _fireAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    String userId = _fireAuth.currentUser!.uid;
    var date = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    String? token = await _fbm.getToken();
    await _userCollection
        .doc(userId)
        .set(
          UserModel(
            rating: {},
            token: token!,
            id: userId,
            gender: 'Other',
            language: '',
            location: {'lat': '', 'long': ''},
            tags: [],
            email: email,
            avatar: '',
            name: name,
            date: date,
            ListOfLanguages: {},
            experience: '',
            listOfExperiences: {},
          ).toMap(),
        )
        .then((value) => print('user added'))
        .catchError(
          (err) => print(err),
        );
  }

////////////////////////
  ///
  Future<void>? changeEmail({email}) async {
    await FirebaseAuth.instance.currentUser!.updateEmail(email);
  }

///////////////
  Future<void> deletAvatarImage(String url) async {
    String myId = await _fireAuth.currentUser!.uid;
    UserModel? userData = await FireStore().getMyInfoFormFirestore();

    UserModel newUserModel = UserModel(
        id: userData!.id,
        rating: userData.rating,
        email: userData.email,
        avatar: null,
        name: userData.name,
        date: userData.date,
        ListOfLanguages: userData.ListOfLanguages,
        experience: userData.experience,
        listOfExperiences: userData.listOfExperiences,
        gender: userData.gender,
        language: userData.language,
        location: userData.location,
        tags: userData.tags,
        token: userData.token);

    updateMyProfile(myId, newUserModel, null);

    _avatarStorage
        .refFromURL(url)
        .delete()
        .then((value) => print('deleted'))
        .catchError((err) {
      print(err);
    });
  }

///////////////////////
  Future<void>? updateMyProfile(userId, UserModel userData, file) async {
    if (file != null) {
      print('userData.avatar');
      print(userData.avatar);
      print('userData.avatar');
      Reference ref = await _avatarStorage.ref('avatar/$userId');
      TaskSnapshot uploadAvatar = await ref.putFile(file);
      if (uploadAvatar.state == TaskState.success) {
        ref.getDownloadURL().then((value) {
          _userCollection
              .doc(userId)
              .set(
                UserModel(
                  id: userId,
                  rating: userData.rating,
                  email: userData.email,
                  avatar: value,
                  name: userData.name,
                  date: userData.date,
                  ListOfLanguages: userData.ListOfLanguages,
                  experience: userData.experience,
                  listOfExperiences: userData.listOfExperiences,
                  gender: userData.gender,
                  language: userData.language,
                  location: userData.location,
                  tags: userData.tags,
                  token: userData.token,
                ).toMap(),
              )
              .then((value) => print('user added'))
              .catchError(
                (err) => print(err),
              );
        });
      }
    } else if (file == null) {
      _userCollection
          .doc(userId)
          .set(
            UserModel(
                    id: userData.id,
                    rating: userData.rating,
                    email: userData.email,
                    avatar: userData.avatar,
                    name: userData.name,
                    date: userData.date,
                    ListOfLanguages: userData.ListOfLanguages,
                    experience: userData.experience,
                    listOfExperiences: userData.listOfExperiences,
                    gender: userData.gender,
                    language: userData.language,
                    location: userData.location,
                    tags: userData.tags,
                    token: userData.token)
                .toMap(),
          )
          .then((value) => print('user added'))
          .catchError(
            (err) => print(err),
          );
    }
  }

  Future<void>? logIn({email, password}) async {
    print(password);
    await _fireAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      UserModel? userData = await FireStore().getMyInfoFormFirestore();
      String? token = await _fbm.getToken();

      UserModel newUserModel = await UserModel(
          id: userData!.id,
          rating: userData.rating,
          email: userData.email,
          avatar: userData.avatar,
          name: userData.name,
          date: userData.date,
          ListOfLanguages: userData.ListOfLanguages,
          experience: userData.experience,
          listOfExperiences: userData.listOfExperiences,
          gender: userData.gender,
          language: userData.language,
          location: userData.location,
          tags: userData.tags,
          token: token!);

      updateMyProfile(value.user!.uid, newUserModel, null);
    });
  }

  Stream<User?> get user => _fireAuth.authStateChanges().map((user) => user);
}
