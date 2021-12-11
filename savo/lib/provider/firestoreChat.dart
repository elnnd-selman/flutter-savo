import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:main/models/chat_model.dart';
import 'package:uuid/uuid.dart';

class FireStoreChat {
  CollectionReference _chatColloection =
      FirebaseFirestore.instance.collection('chat');

  Stream? getChat(chatId) {
    return _chatColloection.doc(chatId).snapshots().map((event) {
      return ChatModelM.fromJson(event.data() as Map<String, dynamic>);
    });
  }

  Stream<List<ChatModelM>> getMyChatRoom() {
    print('object');
    var data = _chatColloection
        .orderBy('date', descending: true)
        .snapshots()
        .map((data) => data.docs.map((e) {
              return ChatModelM.fromJson(e.data() as Map<String, dynamic>);
            }).toList());

    return data;
  }

  Future<void> AddMassage(
      {String? chatId,
      String? mass,
      String? userId,
      String? tokenSecound,
      String? senderName}) async {
    print(mass);
    var newFshaChatId = Uuid().v4();
    await _chatColloection.doc(chatId).update({
      'userChat': FieldValue.arrayUnion([
        {
          'senderName': senderName,
          'tokenSecound': tokenSecound,
          'fsha': newFshaChatId,
          "date": DateFormat("dd-MM-yyyy h:mma", "en").format(DateTime.now()),
          'mass': mass,
          'userId': userId
        }
      ])
    });
  }

  Future<void> deletEmptyChat() async {
    var one = await _chatColloection.get();
    List two = await one.docs
        .map((e) => ChatModelM.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    void _deleteFun(chatId) async {
      await _chatColloection.doc(chatId).delete();
    }

    two.forEach((element) {
      var data = element as ChatModelM;
      if (data.userChat!.length < 1) {
        _deleteFun(data.chatId);
      }
      ;
    });
  }

  Future<void> setDateChatRoom({
    String? chatId,
  }) async {
    await _chatColloection.doc(chatId).update(
        {'date': DateFormat("dd-MM-yyyy h:mma").format(DateTime.now())});
  }

  Future<void> createChat({
    userId,
    userId2,
  }) async {
    var newChatId = Uuid().v1();
    var newFshaChatId = Uuid().v4();
    await _chatColloection.doc(newChatId).set({
      'fsha': newFshaChatId,
      'users': [userId2, userId],
      'chatId': newChatId,
      'date': DateFormat("dd-MM-yyyy h:mma").format(DateTime.now()),
      'userChat': []
    }, SetOptions(merge: true));
  }

  Future<void> deleteChat(String chatId) async {
    await _chatColloection.doc(chatId).delete().catchError((err) {
      print(err);
    });
  }
}
