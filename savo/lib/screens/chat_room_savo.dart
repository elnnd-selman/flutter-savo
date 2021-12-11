import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/chat_model.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/provider/firestoreChat.dart';
import 'package:main/screens/chat_savo.dart';
import 'package:main/widget/time_ago.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class SavoChat extends StatefulWidget {
  static const routeName = '/chat-screen';

  @override
  _SavoChatState createState() => _SavoChatState();
}

class _SavoChatState extends State<SavoChat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Savchat room'.tr(),
          style: TextStyle(
            color: blackColor,
            fontFamily: 'rudaw',
            fontSize: 20,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Stack(
          children: [
            StreamBuilder(
                stream: FireStoreChat().getMyChatRoom(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data = snapshot.data as List<ChatModelM>;
                  var dataa = data
                      .where(
                          (element) => element.users!.any((id) => id == userId))
                      .toList();
                  print(dataa.length);
                  if (dataa.length < 1) {
                    return Center(child: Text('You have not any savchat'.tr()));
                  }
                  return ListView.builder(
                    itemCount: dataa.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: FireStore().getUserByIdFromFirestore(
                              dataa[index].users![0] == userId
                                  ? dataa[index].users![1]
                                  : dataa[index].users![0]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Shimmer.fromColors(
                                  child: ListTile(
                                    leading: CircleAvatar(),
                                    title: Container(
                                      width: 10,
                                      height: 5,
                                    ),
                                  ),
                                  baseColor: tarik,
                                  highlightColor: greyShadeColor);
                            }
                            //has data
                            UserModel data = snapshot.data as UserModel;
                            /////
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatSavoScrenn(
                                      nameSecound: data.name!,
                                      tokenSecound: data.token,
                                      userSecound:
                                          dataa[index].users![0] == userId
                                              ? dataa[index].users![1]
                                              : dataa[index].users![0],
                                      chatId: dataa[index].chatId!,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 7),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: tarik,
                                    backgroundImage: data.avatar != null &&
                                            data.avatar!.length > 5
                                        ? NetworkImage(data.avatar!)
                                        : null,
                                    child: data.avatar != null &&
                                            data.avatar!.length > 5
                                        ? null
                                        : Icon(
                                            Icons.person,
                                            color: whiteColor,
                                          ),
                                  ),
                                  title: Text(
                                    data.name!,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontFamily: 'rudaw',
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                   
                                        dataa[index].date!,
                                    style: TextStyle(
                                      color: greyShadeColor,
                                      fontFamily: 'rudaw',
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
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
                                                Navigator.pop(context, 'yes');
                                              },
                                              child: Text(
                                                'Yes'.tr(),
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontFamily: 'rudaw',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'no');
                                              },
                                              child: Text(
                                                'No'.tr(),
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontFamily: 'rudaw',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ).then((value) async {
                                        print(value);
                                        if (value == 'yes') {
                                          await FireStoreChat()
                                              .deleteChat(dataa[index].chatId!);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
