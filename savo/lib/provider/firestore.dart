import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:main/models/project_model.dart';
import 'package:main/models/user_model.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class FireStore {
  CollectionReference _postCollection =
      FirebaseFirestore.instance.collection('posts');
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  FirebaseStorage _storage = FirebaseStorage.instance;

///////////getPostFromFirestore
  Stream<List<ProjectModel>> getPostFromFirestore(
      String typePost, Map? filterItem) {
    List filterItemList = [];

    if (filterItem != null && filterItem.length > 0) {
      if (filterItem['technology']) {
        ['technology'].forEach((element) {
          filterItemList.add(element);
        });
      }
      if (filterItem['science']) {
        ['science'].forEach((element) {
          filterItemList.add(element);
        });
      }
      if (filterItem['health']) {
        ['health'].forEach((element) {
          filterItemList.add(element);
        });
      }
      if (filterItem['sport']) {
        ['sport'].forEach((element) {
          filterItemList.add(element);
        });
        print(filterItemList);
      }
      if (filterItem['art']) {
        ['art'].forEach((element) {
          filterItemList.add(element);
        });
      }
      if (filterItem['history']) {
        ['history'].forEach((element) {
          filterItemList.add(element);
        });
      }
      if (filterItem['society']) {
        ['society'].forEach((element) {
          filterItemList.add(element);
        });
      }
      if (filterItem['religion']) {
        ['religion'].forEach((element) {
          filterItemList.add(element);
        });
      }

      if (filterItem['employee']) {
        ['employee'].forEach((element) {
          filterItemList.add(element);
        });
      }
    }

    var data;
    //agar fliter nabu
    if (filterItemList.length < 1) {
      if (typePost == 'all') {
        var data = _postCollection
            .orderBy('date', descending: true)
            .snapshots()
            .map((data) => data.docs.map((e) {
                  return ProjectModel.fromJson(
                      e.data() as Map<String, dynamic>);
                }).toList());
        return data;
      } else {
        data = _postCollection
            .where('category', isEqualTo: typePost)
            .orderBy('date', descending: true)
            .snapshots()
            .map((data) => data.docs.map((e) {
                  return ProjectModel.fromJson(
                      e.data() as Map<String, dynamic>);
                }).toList());
        return data;
      }
      //agar fliter bu
    } else if (filterItemList.length > 0) {
      if (typePost == 'all') {
        print(filterItemList);
        var data = _postCollection
            .orderBy('date', descending: true)
            .where('tags', arrayContainsAny: filterItemList)
            .snapshots()
            .map((data) => data.docs.map((e) {
                  return ProjectModel.fromJson(
                      e.data() as Map<String, dynamic>);
                }).toList());
        return data;
      } else {
        data = _postCollection
            .where('category', isEqualTo: typePost)
            .where('tags', arrayContainsAny: filterItemList)
            .orderBy('date', descending: true)
            .snapshots()
            .map((data) => data.docs.map((e) {
                  return ProjectModel.fromJson(
                      e.data() as Map<String, dynamic>);
                }).toList());
        return data;
      }
    }
    return data;
  }

  Future<List<ProjectModel>>? getPostFromFirestoreForSeach() async {
    var data = await _postCollection.orderBy('date', descending: true).get();
    var datas = data.docs
        .map((e) => ProjectModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return datas;
  }

  Future<ProjectModel>? getPostFromFirestoreById(String id) async {
    DocumentSnapshot data =
        await _postCollection.doc(id).get().catchError((err) {
      print(err);
    });
    var datas = ProjectModel.fromJson(data.data() as Map<String, dynamic>);

    return datas;
  }

///////////////////getMyPostFromFirestore
  Future<List<ProjectModel>>? getMyPostFromFirestore() async {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot post =
        await _postCollection.where('userId', isEqualTo: userId).get();
    List<ProjectModel> listOfPost = await post.docs
        .map(
          (e) => ProjectModel.fromJson(e.data() as Map<String, dynamic>),
        )
        .toList();

    return listOfPost;
  }

////////////////////////////////////////
  Future<List<ProjectModel>>? getMySavoList() async {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot post =
        await _postCollection.where('saveList', arrayContains: userId).get();
    List<ProjectModel> listOfPost = await post.docs
        .map(
          (e) => ProjectModel.fromJson(e.data() as Map<String, dynamic>),
        )
        .toList();
    print(listOfPost);
    return listOfPost;
  }
  /////////////////////////////////////

  Future<void>? removeMySavoList(String postId) async {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    await _postCollection.doc(postId).update({
      'saveList': FieldValue.arrayRemove([userId])
    }).catchError((err) {
      print(err);
    });
  }

//////////////////////
  Future<List<ProjectModel>>? getUserPostByIdFromFirestore(
      String userId) async {
    QuerySnapshot post =
        await _postCollection.where('userId', isEqualTo: userId).get();
    List<ProjectModel> listOfPost = await post.docs
        .map(
          (e) => ProjectModel.fromJson(e.data() as Map<String, dynamic>),
        )
        .toList();

    return listOfPost;
  }

///////////////
  Future<UserModel>? getUserByIdFromFirestore(String userId) async {
    DocumentSnapshot user = await userCollection.doc(userId).get();
    var data = UserModel.fromJson(user.data() as Map<String, dynamic>);
    // print('data.nam/////////++++++++++++++/////////////e');
    // print(data.name);
    // print('data.nam///////-----------////////e');

    return data;
  }

///////////////////
  Future<List<UserModel>>? getAllUserFromFirestore() async {
    QuerySnapshot users = await userCollection.get();
    List<UserModel> listOfUser = await users.docs
        .map(
          (e) => UserModel.fromJson(e.data() as Map<String, dynamic>),
        )
        .toList();
    return listOfUser;
  }

/////////////////////////////////////
  Future<void> deleteCommentById(String postId, String commentId) async {
    _postCollection
        .doc(postId)
        .update(
          {'comments.$commentId': FieldValue.delete()},
        )
        .then((value) => print('delete added comment'))
        .catchError(
          (err) {
            print(err);
          },
        );
  }

////////////////////
  Future<void> updateLocation(String userId, bool type,
      {String? lat, String? long}) async {
    if (type == false) {
      print('agar false bet yakam');
      await userCollection.doc(userId).update(
          {'location.lat': lat, 'location.long': long}).catchError((err) {
        print(err);
      });
    }
    if (type == true) {
      print('agar true bet dwam');
      print('$lat, $long');
      await userCollection.doc(userId).update(
          {'location.lat': lat, 'location.long': long}).catchError((err) {
        print(err);
      });
    }
  }

////////////////////
  Stream getPostComment(String postId) {
    var datas = _postCollection.doc(postId).snapshots();
    return datas
        .map((e) => ProjectModel.fromJson(e.data() as Map<String, dynamic>));
  }

  Future<void> addedCommentById(
      String postId, String userId, String comment) async {
    var _newId = Uuid().v1();
    Map _newComment = {
      "comment": {userId: comment},
      'date': DateFormat("dd-MM-yyyy h:mma").format(DateTime.now()),
    };
    _postCollection
        .doc(postId)
        .update(
          {
            'comments.$_newId': FieldValue.arrayUnion([_newComment])
          },
        )
        .then((value) => print('You added comment'))
        .catchError(
          (err) {
            print(err);
          },
        );
  }

  //////////////////////
  Future<void> rateUser(
      String userId, String rateNum, String userRatedId) async {
    await userCollection
        .doc(userId)
        .update({
          'rating.$rateNum': FieldValue.arrayUnion([userRatedId])
        })
        .then((value) => print('rated'))
        .catchError((err) {
          print(err);
        });
  }

/////////////////uloadToFireStorage
  Future<void>? uloadToFireStorage(
    String? type,
    List<File> imageListFile,
    ProjectModel dataText,
    Function loadUpload,
    int listimageLen,
    Function goBack,
  ) async {
    String newId = Uuid().v1();
    List<String> urls = [];

    double currentIndex = 1;
    double value = .1;

    //add new project
    if (type == 'project' &&
        dataText.imageUrl!.length < 1 &&
        dataText.id == null &&
        imageListFile.length > 0) {
      for (var img in imageListFile) {
        loadUpload(true, value);
        Reference ref = await _storage.ref().child(newId).child(
              basename(img.path),
            );
        TaskSnapshot uploadFile = await ref.putFile(img);
        if (uploadFile.state == TaskState.success) {
          String url = await uploadFile.ref.getDownloadURL();
          urls.add(url);
          value = currentIndex / listimageLen;
          currentIndex++;
        } else {
          print(' TaskState not success ');
        }
      }
      await _postCollection
          .doc(newId)
          .set(ProjectModel(
                  userId: dataText.userId,
                  title: dataText.title,
                  description: dataText.description,
                  imageUrl: [...urls],
                  category: dataText.category,
                  comments: dataText.comments,
                  date: dataText.date,
                  price: dataText.price,
                  likes: dataText.likes,
                  tags: dataText.tags,
                  id: newId,
                  saveList: dataText.saveList)
              .toMap())
          .then((value) => print('add new project'))
          .catchError((err) => print(err))
          .whenComplete(
        () {
          loadUpload(false, value);
          goBack();
        },
      );
      return;
    } else if (type != 'project' && dataText.id == null) {
      await _postCollection
          .doc(newId)
          .set(ProjectModel(
                  userId: dataText.userId,
                  title: dataText.title,
                  description: dataText.description,
                  imageUrl: null,
                  category: dataText.category,
                  comments: dataText.comments,
                  date: dataText.date,
                  price: dataText.price,
                  likes: dataText.likes,
                  tags: dataText.tags,
                  id: newId,
                  saveList: dataText.saveList)
              .toMap())
          .then((value) => print('add new $type'))
          .catchError((err) => print(err))
          .whenComplete(
        () {
          loadUpload(false, value);
          goBack();
        },
      );
      return;
    } else if (dataText.id != null) {
      await _postCollection
          .doc(dataText.id)
          .set(ProjectModel(
                  userId: dataText.userId,
                  title: dataText.title,
                  description: dataText.description,
                  imageUrl: dataText.imageUrl,
                  category: dataText.category,
                  comments: dataText.comments,
                  date: dataText.date,
                  price: dataText.price,
                  likes: dataText.likes,
                  tags: dataText.tags,
                  id: dataText.id,
                  saveList: dataText.saveList)
              .toMap())
          .then((value) => print('updated post'))
          .catchError((err) => print(err))
          .whenComplete(
        () {
          loadUpload(false, value);
          goBack();
        },
      );
    }

    loadUpload(false, value);
  }

  //getUserFormFirestore
  Future<UserModel>? getMyInfoFormFirestore() async {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await userCollection.doc(userId).get();

    return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  /////////////////////
  Future<bool>? getMyInfoAndCheckIfHaveLocation() async {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await userCollection.doc(userId).get();

    UserModel data =
        await UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    bool check;
    if (data.location!['lat'].length < 3 && data.location!['long'].length < 3) {
      check = false;
    } else {
      check = true;
    }
    return check;
  }

//delete post
  Future<void>? deletePostById(
    id,
    List? images,
  ) async {
    int index = 0;
    if (images != null) {
      for (var image in images) {
        await _storage.refFromURL(image).delete().then((value) {
          if (index == images.length - 1) {
            _postCollection.doc(id).delete().then((value) {
              print('deleted doc');
            }).catchError((err) {
              print(err);
            });
          }
          index++;
        }).catchError((err) {
          print(err);
        });
      }
    } else {
      _postCollection.doc(id).delete().then((value) {
        print('deleted doc');
      }).catchError((err) {
        print(err);
      });
    }
  }

////like and comment and save list

  ///like
  Future<void>? likeByUserLogin(String postId) async {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    var data = await _postCollection.doc(postId).get();
    var dataDoc = await data.data() as Map;
    var datalist = dataDoc['likes'] as List;
    if (datalist.contains(userId)) {
      print(datalist.contains(userId));
      await _postCollection
          .doc(postId)
          .update({
            'likes': FieldValue.arrayRemove([userId])
          })
          .then((value) => print('unlike'))
          .catchError((err) => print(err));
    } else {
      await _postCollection
          .doc(postId)
          .update({
            'likes': FieldValue.arrayUnion([userId])
          })
          .then((value) => print('like'))
          .catchError((err) => print(err));
      ;
    }
  }

  //saveList
  Future<void>? SaveintoSaveList(String postId) async {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    var data = await _postCollection.doc(postId).get();
    var dataDoc = await data.data() as Map;
    var datalist = dataDoc['saveList'] as List;
    if (datalist.contains(userId)) {
      print(datalist.contains(userId));
      await _postCollection
          .doc(postId)
          .update({
            'saveList': FieldValue.arrayRemove([userId])
          })
          .then((value) => print('remove saveToList'))
          .catchError((err) => print(err));
    } else {
      await _postCollection
          .doc(postId)
          .update({
            'saveList': FieldValue.arrayUnion([userId])
          })
          .then((value) => print(' saveToList'))
          .catchError((err) => print(err));
      ;
    }
  }
}
