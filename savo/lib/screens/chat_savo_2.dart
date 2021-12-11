import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/chat_model.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/provider/firestoreChat.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:main/widget/time_ago.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui' as ui;

class ChatSavoScrenn2 extends StatefulWidget {
  final String userId2;
  final String tokenSecound;
  final String nameSecound;
  ChatSavoScrenn2(
      {Key? key,
      required this.userId2,
      required this.tokenSecound,
      required this.nameSecound})
      : super(key: key);

  @override
  _ChatSavoScrennState createState() => _ChatSavoScrennState();
}

class _ChatSavoScrennState extends State<ChatSavoScrenn2> {
  TextEditingController _massController = TextEditingController();
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              Navigator.pop(context, 'delete');
            },
            icon: Icon(Icons.arrow_back, color: tarik, size: 30)),
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text(
          'Savchat'.tr(),
          style: TextStyle(
            color: blackColor,
            fontFamily: 'rudaw',
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FireStoreChat().getMyChatRoom(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } /////////////////////////////
            var data2 = snapshot.data as List<ChatModelM>;
            var dataa2 = data2.where((element) {
              return element.users!
                      .any((id) => id.toString().contains(userId)) &&
                  element.users!
                      .any((id) => id.toString().contains(widget.userId2));
            }).toList();

            if (dataa2.length < 1) {
              FireStoreChat().createChat(
                userId: userId,
                userId2: widget.userId2,
              );
              return Center(
                child: Text('Try agein please'.tr()),
              );
            }

            // ////////////////////////////////
            // ChatModelM data = snapshot.data as ChatModelM;
            // List chats = data.userChat as List;

            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 68),
                  child: ListView.builder(
                    controller: _ScrollController,
                    itemCount: dataa2[0].userChat!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment:
                                dataa2[0].userChat![index]['userId'] == userId
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: dataa2[0].userChat![index]['userId'] ==
                                          userId
                                      ? tarik
                                      : whiteColor,
                                  //ar na user aa
                                  borderRadius: (context.locale.toString() != 'ar' &&
                                              context.locale.toString() !=
                                                  'fa' &&
                                              context.locale.toString() !=
                                                  'ur') &&
                                          dataa2[0].userChat![index]['userId'] ==
                                              userId
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
                                              dataa2[0].userChat![index]['userId'] !=
                                                  userId
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(0),
                                              bottomRight: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            )

                                          //ar a user na
                                          : (context.locale.toString() == 'ar' ||
                                                      context.locale.toString() ==
                                                          'fa' ||
                                                      context.locale.toString() ==
                                                          'ur') &&
                                                  dataa2[0].userChat![index]['userId'] !=
                                                      userId
                                              ? BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  bottomLeft:
                                                      Radius.circular(30),
                                                  bottomRight:
                                                      Radius.circular(0),
                                                  topRight: Radius.circular(30),
                                                )
                                              //ar aa user aa
                                              : (context.locale.toString() == 'ar' || context.locale.toString() == 'fa' || context.locale.toString() == 'ur') &&
                                                      dataa2[0].userChat![index]['userId'] == userId
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
                                                  dataa2[0].userChat![index]
                                                      ['userId']),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container(
                                                width: 15,
                                                height: 15,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: whiteColor,
                                                    strokeWidth: 1,
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
                                                    color: dataa2[0].userChat![
                                                                    index]
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
                                          dataa2[0].userChat![index]['mass'],
                                          textDirection: RegExp(
                                                          r"^[\u0600-\u06FF\s]+$")
                                                      .hasMatch(dataa2[0]
                                                              .userChat![index]
                                                          ['mass']) ||
                                                  RegExp(r"^[\u0621-\u064A]+$")
                                                      .hasMatch(
                                                    dataa2[0].userChat![index]
                                                        ['mass'],
                                                  )
                                              ? ui.TextDirection.rtl
                                              : ui.TextDirection.ltr,
                                          style: TextStyle(
                                              color: dataa2[0].userChat![index]
                                                          ['userId'] ==
                                                      userId
                                                  ? whiteColor
                                                  : tarik,
                                              fontFamily: 'rudaw',
                                              fontSize: 14),
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
                                dataa2[0].userChat![index]['userId'] == userId
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Text(
                                dataa2[0].userChat![index]['date'],
                                textDirection: RegExp(r"^[\u0600-\u06FF\s]+$")
                                            .hasMatch(dataa2[0].userChat![index]
                                                ['mass']) ||
                                        RegExp(r"^[\u0621-\u064A]+$").hasMatch(
                                          dataa2[0].userChat![index]['mass'],
                                        )
                                    ? ui.TextDirection.rtl
                                    : ui.TextDirection.ltr,
                                style: TextStyle(
                                    color: tarik,
                                    fontFamily: 'rudaw',
                                    fontSize: 11),
                              ),
                            ],
                          ),
                        ]),
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
                                    chatId: dataa2[0].chatId,
                                    mass: _text,
                                    userId: userId)
                                .then((value) => _scrollDownFun())
                                .catchError((err) {
                              print(err);
                            });
                            _massController.text = '';
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
