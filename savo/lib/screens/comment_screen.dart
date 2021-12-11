import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/project_model.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:main/screens/my_account.dart';
import 'package:main/screens/user_account.dart';
import 'dart:ui' as ui;

import 'package:main/widget/time_ago.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comments';

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  AppBar appBar(navigator) {
    return AppBar(
      backgroundColor: whiteColor,
      leading: IconButton(
        onPressed: navigator,
        icon: Icon(
          Icons.arrow_back,
          color: blackColor,
        ),
      ),
    );
  }

  TextEditingController _commetnController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commetnController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? _postId = ModalRoute.of(context)!.settings.arguments as String;
    String? userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(() {
        Navigator.pop(context);
      }),
      body: Container(
        height: MediaQuery.of(context).size.height -
            appBar(() {}).preferredSize.height,
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FireStore().getPostComment(_postId),
                      builder: (context, snapshot) {
                        //has not data
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                            color: whiteColor,
                          );
                        }

                        String? userId = FirebaseAuth.instance.currentUser!.uid;
                        ProjectModel datas = snapshot.data as ProjectModel;
                        List dataa = datas.comments!.values.toList();
                        // print(dataa[0][0]['comment'].values.toList()[0]);
                        //list views
                        // print(dataa.length);

                        // print(dataa[0][0]['date']);
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dataa.length,
                          itemBuilder: (context, index) {
                            //future
                            return FutureBuilder(
                              future: FireStore().getUserByIdFromFirestore(
                                dataa[index][0]['comment'].keys.toList()[0],
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: whiteColor,
                                      ),
                                    ),
                                  );
                                }

                                UserModel user = snapshot.data as UserModel;

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                          width: 1, color: greyShadeColor),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      children: [
                                        //listTile
                                        ListTile(
                                          onTap: () {
                                            if (userId == user.id) {
                                              Navigator.pushNamed(
                                                  context, MyAccount.routeName);
                                            } else {
                                              Navigator.pushNamed(context,
                                                  UserAccount.routeName,
                                                  arguments: user.id);
                                            }
                                          },
                                          dense: true,
                                          horizontalTitleGap: 10,
                                          leading: CircleAvatar(
                                            radius: 22,
                                            backgroundColor: backgroundColor,
                                            backgroundImage:
                                                user.avatar != null &&
                                                        user.avatar!.length > 1
                                                    ? NetworkImage(user.avatar!)
                                                    : null,
                                            child: user.avatar != null &&
                                                    user.avatar!.length > 1
                                                ? null
                                                : Icon(
                                                    Icons.person,
                                                    color: tarik,
                                                  ),
                                          ),
                                          title: Text(
                                            user.name!,
                                            style: TextStyle(
                                                color: blackColor,
                                                fontFamily: 'rudaw',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          trailing: userId ==
                                                  dataa[index][0]['comment']
                                                      .keys
                                                      .toList()[0]
                                              ? IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        content: Text(
                                                          'Are you sure?'.tr(),
                                                          style: TextStyle(
                                                            color: blackColor,
                                                            fontFamily: 'rudaw',
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  'yes');
                                                            },
                                                            child: Text(
                                                              'Yes'.tr(),
                                                              style: TextStyle(
                                                                color:
                                                                    blackColor,
                                                                fontFamily:
                                                                    'rudaw',
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  'no');
                                                            },
                                                            child: Text(
                                                              'No'.tr(),
                                                              style: TextStyle(
                                                                color:
                                                                    blackColor,
                                                                fontFamily:
                                                                    'rudaw',
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ).then((value) {
                                                      print(value);
                                                      if (value == 'yes') {
                                                        if (userId ==
                                                            dataa[index][0]
                                                                    ['comment']
                                                                .keys
                                                                .toList()[0]) {
                                                          var data = datas
                                                              .comments!.keys
                                                              .toList()[index];
                                                          FireStore()
                                                              .deleteCommentById(
                                                                  _postId,
                                                                  data);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(Icons.clear),
                                                )
                                              : null,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: 300,
                                              child: ExpandableText(
                                                dataa[index][0]['comment']
                                                    .values
                                                    .toList()[0],
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontFamily: 'rudaw',
                                                  fontSize: 14,
                                                ),
                                                textDirection: RegExp(
                                                                r"^[\u0600-\u06FF\s]+$")
                                                            .hasMatch(dataa[
                                                                        index][0]
                                                                    ['comment']
                                                                .values
                                                                .toList()[0]) ||
                                                        RegExp(r"^[\u0621-\u064A]+$")
                                                            .hasMatch(dataa[
                                                                        index][0]
                                                                    ['comment']
                                                                .values
                                                                .toList()[0])
                                                    ? ui.TextDirection.rtl
                                                    : ui.TextDirection.ltr,
                                                expandText: 'more'.tr(),
                                                collapseText: 'less ...'.tr(),
                                                linkStyle:
                                                    TextStyle(fontSize: 12),
                                                maxLines: 4,
                                                linkColor: Colors.grey,
                                                animation: true,
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: Text(
                                                // TimeAgo.timeAgoSinceDate(

                                                dataa[index][0]['date'],
                                                // ),
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                style: TextStyle(
                                                    color: greyShadeColor,
                                                    fontFamily: "rudaw",
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: TextField(
                  textInputAction: TextInputAction.newline,
                  // minLines: 1,
                  maxLines: 2,
                  maxLength: 500,
                  style: TextStyle(
                    color: blackColor,
                    fontFamily: 'rudaw',
                    fontSize: 14,
                  ),
                  controller: _commetnController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'Add comment'.tr(),
                    hintStyle: TextStyle(
                        color: blackColor, fontFamily: 'rudaw', fontSize: 16),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        User? _user = await FirebaseAuth.instance.currentUser;
                        if (_commetnController.text.length > 0) {
                          FireStore()
                              .addedCommentById(
                                  _postId, _user!.uid, _commetnController.text)
                              .then((value) => _commetnController.text = '');
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: blackColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: greyShadeColor, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: greyShadeColor, width: .5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
