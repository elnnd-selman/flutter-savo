import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/chat_model.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/provider/firestoreChat.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:main/screens/user_account.dart';
import 'package:main/widget/time_ago.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui' as ui;

class ChatSavoScrenn extends StatefulWidget {
  final String chatId;
  final String userSecound;
  final String tokenSecound;
  final String nameSecound;
  ChatSavoScrenn(
      {Key? key,
      required this.chatId,
      required this.userSecound,
      required this.tokenSecound,
      required this.nameSecound})
      : super(key: key);

  @override
  _ChatSavoScrennState createState() => _ChatSavoScrennState();
}

class _ChatSavoScrennState extends State<ChatSavoScrenn> {
  TextEditingController _massController = TextEditingController();
  String titleAppBarNameUser = '';
  final _ScrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    _ScrollController.dispose();
    _massController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser!.uid;
    void _scrollDownFun() {
      _ScrollController.jumpTo(_ScrollController.position.maxScrollExtent);
    }

    var c = 'en';
    print((context.locale.toString() != 'ar' ||
        context.locale.toString() != 'ur' ||
        context.locale.toString() != 'fa'));
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Savchat'.tr(),
            style: TextStyle(
              color: blackColor,
              fontFamily: 'rudaw',
              fontSize: 20,
            ),
          ),
          backgroundColor: backgroundColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.person_search, color: tarik, size: 30),
                onPressed: () {
                  Navigator.pushNamed(context, UserAccount.routeName,
                      arguments: widget.userSecound);
                },
              ),
            )
          ]),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FireStoreChat().getChat(widget.chatId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            ChatModelM data = snapshot.data as ChatModelM;
            List chats = data.userChat as List;

            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 68),
                  child: ListView.builder(
                    controller: _ScrollController,
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  chats[index]['userId'] == userId
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: chats[index]['userId'] == userId
                                        ? tarik
                                        : whiteColor,
                                    //ar na user aa
                                    borderRadius: (context.locale.toString() != 'ar' &&
                                                context.locale.toString() !=
                                                    'fa' &&
                                                context.locale.toString() !=
                                                    'ur') &&
                                            chats[index]['userId'] == userId
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(0),
                                            topRight: Radius.circular(30),
                                          )

                                        //ar na user na
                                        : (context.locale.toString() != 'ar' &&
                                                    context.locale.toString() !=
                                                        'fa' &&
                                                    context.locale.toString() !=
                                                        'ur') &&
                                                chats[index]['userId'] != userId
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              )

                                            //ar a user na
                                            : (context.locale.toString() == 'ar' ||
                                                        context.locale.toString() ==
                                                            'fa' ||
                                                        context.locale.toString() ==
                                                            'ur') &&
                                                    chats[index]['userId'] !=
                                                        userId
                                                ? BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    bottomLeft:
                                                        Radius.circular(30),
                                                    bottomRight:
                                                        Radius.circular(0),
                                                    topRight:
                                                        Radius.circular(30),
                                                  )
                                                //ar aa user aa
                                                : (context.locale.toString() ==
                                                                'ar' ||
                                                            context.locale.toString() ==
                                                                'fa' ||
                                                            context.locale.toString() ==
                                                                'ur') &&
                                                        chats[index]
                                                                ['userId'] ==
                                                            userId
                                                    ? BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(30),
                                                        bottomLeft:
                                                            Radius.circular(0),
                                                        bottomRight:
                                                            Radius.circular(30),
                                                        topRight:
                                                            Radius.circular(30),
                                                      )
                                                    : null,
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        FutureBuilder(
                                            future: FireStore()
                                                .getUserByIdFromFirestore(
                                                    chats[index]['userId']),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container(
                                                  width: 15,
                                                  height: 15,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: whiteColor,
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                );
                                              }
                                              UserModel data =
                                                  snapshot.data as UserModel;
                                              return Row(
                                                children: [
                                                  Text(
                                                    data.name!,
                                                    style: TextStyle(
                                                      color: chats[index]
                                                                  ['userId'] ==
                                                              userId
                                                          ? whiteColor
                                                          : tarik,
                                                      fontFamily: 'rudaw',
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                        Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 250),
                                          child: Text(
                                            chats[index]['mass'],
                                            textDirection:
                                                RegExp(r"^[\u0600-\u06FF\s]+$")
                                                            .hasMatch(
                                                                chats[index]
                                                                    ['mass']) ||
                                                        RegExp(r"^[\u0621-\u064A]+$")
                                                            .hasMatch(
                                                                chats[index]
                                                                    ['mass'])
                                                    ? ui.TextDirection.rtl
                                                    : ui.TextDirection.ltr,
                                            style: TextStyle(
                                                color: chats[index]['userId'] ==
                                                        userId
                                                    ? whiteColor
                                                    : tarik,
                                                fontFamily: 'rudaw'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                                  chats[index]['userId'] == userId
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                Text(
                                  chats[index]['date'],
                                  textDirection: RegExp(r"^[\u0600-\u06FF\s]+$")
                                              .hasMatch(chats[index]['mass']) ||
                                          RegExp(r"^[\u0621-\u064A]+$")
                                              .hasMatch(chats[index]['mass'])
                                      ? ui.TextDirection.rtl
                                      : ui.TextDirection.ltr,
                                  style: TextStyle(
                                      color: chats[index]['userId'] == userId
                                          ? tarik
                                          : tarik,
                                      fontFamily: 'rudaw',
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                        color: blackColor,
                        fontFamily: 'rudaw',
                        fontSize: 14,
                      ),
                      controller: _massController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: whiteColor,
                        hintText: 'Message..'.tr(),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'rudaw',
                            fontSize: 16),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (_massController.text.length < 1) {
                              return null;
                            }
                            String _text = _massController.text;
                            _massController.text = '';
                            var myInfo =
                                await FireStore().getMyInfoFormFirestore();
                            var myName = myInfo!.name;
                            await FireStoreChat()
                                .AddMassage(
                                    senderName: myName,
                                    tokenSecound: widget.tokenSecound,
                                    chatId: data.chatId,
                                    mass: _text,
                                    userId: userId)
                                .then((value) => _scrollDownFun())
                                .catchError((err) {
                              print(err);
                            });

                            _massController.text = '';
                            await FireStoreChat().setDateChatRoom(
                              chatId: data.chatId,
                            );

                            // }
                          },
                          icon: Icon(
                            Icons.send,
                            color: blackColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: greyShadeColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: greyShadeColor, width: .5),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
