import 'package:achievement_view/achievement_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/add_post.dart';
import 'package:main/widget/Text.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:main/widget/home_project_item.dart';

class SavoList extends StatefulWidget {
  static const routeName = "/savo-list";
  const SavoList({Key? key}) : super(key: key);

  @override
  State<SavoList> createState() => _SavoListState();
}

class _SavoListState extends State<SavoList> {
  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Savo list'.tr(),
          style:
              TextStyle(color: blackColor, fontFamily: 'rudaw', fontSize: 20),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Container(
          child: FutureBuilder(
              future: FireStore().getMySavoList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data as List;
                if (data.length < 1) {
                  return Center(
                    child: TextWd(
                        title: 'You have not any Savo list'.tr(),
                        color: blackColor,
                        fSize: 12),
                  );
                }
                print(data);
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    void remove() {
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
                          await FireStore()
                              .removeMySavoList(data[index].id)!
                              .then((value) {
                            setState(() {});
                          });
                        }
                      });
                    }

                    return Stack(
                      children: [
                        Stack(
                          children: [
                            HomeItemProject(
                              myAccount: true,
                              id: data[index].id,
                              date: data[index].date,
                              title: data[index].title,
                              image: data[index].imageUrl,
                              description: data[index].description,
                              price: data[index].price,
                              likes: data[index].likes,
                              comments: data[index].comments,
                              saveList: data[index].saveList,
                              category: data[index].category,
                              userId: data[index].userId,
                            ),
                            // Positioned.fill(
                            //   bottom: 80,
                            //   child: Align(
                            //     alignment: Alignment.center,
                            //     child: Container(
                            //       width: 70,
                            //       height: 70,
                            //       decoration: BoxDecoration(
                            //         color: Colors.black38,
                            //         borderRadius: BorderRadius.circular(10),
                            //       ),
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(15.0),
                            //         child: CircularProgressIndicator(
                            //           strokeWidth: 4,
                            //           color: shiri,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                        Positioned(
                          top: 10,
                          right: 2,
                          child: PopupMenuButton(
                            elevation: 0,
                            onCanceled: () {
                              print('cencel');
                            },
                            onSelected: (value) {
                              if (value == 'Remove') {
                                remove();
                              }
                            },
                            color: tarik,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 10),
                            icon: Icon(Icons.more_vert, size: 30, color: tarik),
                            tooltip: 'Remove in savo list'.tr(),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: ListTile(
                                  horizontalTitleGap: -10,
                                  leading: Icon(
                                    Icons.bookmark_remove,
                                    color: shiri,
                                  ),
                                  title: TextWd(
                                      title: 'Remove in savo list'.tr(),
                                      color: shiri,
                                      fSize: 12),
                                ),
                                value: 'Remove',
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              })),
    );
  }
}
