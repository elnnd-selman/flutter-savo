import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class NoteScreen extends StatelessWidget {
  static const routeName = "/note-post-profile";
  const NoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: tarik,
              )),
        ),
        backgroundColor: backgroundColor,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: tarik, borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Profile'.tr(),
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: 'rudaw',
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Insert tags into your profile, so that they can easily find you. Be careful, name and put your email in tags,'
                                .tr()
                                .tr(),
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: 'rudaw',
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/images/taginfoprofile.jpg',
                            width: 150,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 1,
                            color: blackColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Post'.tr(),
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: 'rudaw',
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'To set up mail, please be aware of the tags, which are very important for filtering and searching, Each post you post belongs to these sections, add this tag to your post,(technology, art, history, employee, science, sports, religious health, building),You can also add any tag to your post to search,'
                                .tr(),
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: 'rudaw',
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/images/taginfo.jpg',
                            width: 150,
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'For any suggestions, please contact us.'.tr(),
                  style: TextStyle(
                      color: tarik, fontFamily: 'rudaw', fontSize: 14),
                ),
                Text(
                  'example@email.com',
                  style: TextStyle(
                      color: tarik, fontFamily: 'rudaw', fontSize: 14),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
