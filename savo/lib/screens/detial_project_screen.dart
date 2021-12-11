import 'package:achievement_view/achievement_widget.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/comment_screen.dart';
import 'package:main/screens/user_account.dart';
import 'package:main/widget/Text.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:main/widget/time_ago.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class ProjectDetialsScreen extends StatefulWidget {
  static const routeName = '/detial-screen';
  final String? id;
  final String? userId;
  final String? title;
  final String? description;
  final double? price;
  final List? image;
  final List? likes;
  final Map? comments;
  final List? saveList;
  final String? category;
  final String? date;

  const ProjectDetialsScreen(
      {Key? key,
      @required this.id,
      @required this.userId,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.likes,
      @required this.comments,
      @required this.saveList,
      @required this.category,
      @required this.date})
      : super(key: key);

  @override
  _HomeItemProjectState createState() => _HomeItemProjectState();
}

class _HomeItemProjectState extends State<ProjectDetialsScreen> {
  bool isLike = false;
  bool isSavetoList = false;
  bool _onesSend = true;
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (widget.likes!.contains(user!.uid)) {
      setState(() {
        isLike = !false;
      });
    } else if (!widget.likes!.contains(user.uid)) {
      setState(() {
        isLike = false;
      });
    }
    if (widget.saveList!.contains(user.uid)) {
      setState(() {
        isSavetoList = !false;
      });
    } else if (!widget.saveList!.contains(user.uid)) {
      setState(() {
        isSavetoList = false;
      });
    }

    AppBar appbar = AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appbar,
      body: Container(
        height:
            MediaQuery.of(context).size.height - appbar.preferredSize.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 40),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<UserModel>(
                    future:
                        FireStore().getUserByIdFromFirestore(widget.userId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Shimmer.fromColors(
                          baseColor: tarik,
                          highlightColor: Colors.grey,
                          enabled: true,
                          period: Duration(milliseconds: 500),
                          child: ListTile(
                            horizontalTitleGap: 2,
                            leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(width: 2, color: tarik)),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: tarik,
                              ),
                            ),
                            title: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: tarik,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        );
                      }
                      //has data//////////////////////
                      var data = snapshot.data as UserModel;
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, UserAccount.routeName,
                              arguments: widget.userId!);
                        },
                        trailing: widget.price != null
                            ? Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: blackShadeColor),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '\$',
                                      style: TextStyle(
                                          color: blackShadeColor, fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        horizontalTitleGap: 2,
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border:
                                Border.all(width: 2, color: blackShadeColor),
                          ),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: tarik,
                            child: data.avatar == null
                                ? Icon(
                                    Icons.person,
                                    color: shiri,
                                  )
                                : null,
                            backgroundImage: data.avatar != null
                                ? NetworkImage(data.avatar!)
                                : null,
                          ),
                        ),
                        title: Text(
                          data.name!,
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: 'rudaw',
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          widget.category!,
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'rudaw',
                              fontSize: 12),
                        ),
                      );
                    },
                  ),
                  widget.image != null && widget.image!.length > 0
                      ? Container(
                          height: 350,
                          width: 350,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: shiri,
                              height: 350,
                              width: 350,
                              child: Carousel(
                                images: widget.image!
                                    .map(
                                      (e) => FadeInImage(
                                        fit: BoxFit.cover,
                                        placeholder:
                                            AssetImage('assets/images/2.gif'),
                                        image: NetworkImage(
                                          e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                autoplay: false,
                                dotSize: widget.image!.length < 2 ? 0.0 : 5.0,
                                dotSpacing: 15.0,
                                // dotHorizontalPadding: 1,
                                // dotVerticalPadding: 1,
                                dotColor: shiri,
                                dotBgColor: widget.image!.length > 1
                                    ? Colors.black12
                                    : Colors.transparent,
                                dotIncreaseSize: 2.5,
                                dotIncreasedColor: shiri,
                                borderRadius: true,
                                moveIndicatorFromBottom: 10,
                                indicatorBgPadding: 5,
                                dotPosition: DotPosition.topRight,
                                showIndicator: true,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //description
                        ExpandableText(
                          '${widget.description}',
                          textDirection: RegExp(r"^[\u0600-\u06FF\s]+$")
                                      .hasMatch(widget.description!) ||
                                  RegExp(r"^[\u0621-\u064A]+$")
                                      .hasMatch(widget.description!)
                              ? ui.TextDirection.rtl
                              : ui.TextDirection.ltr,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 14,
                              fontFamily: 'rudaw'),
                          expandText: 'more'.tr(),
                          collapseText: 'less ...'.tr(),
                          maxLines:
                              widget.image != null && widget.image!.length > 0
                                  ? 2
                                  : 10,
                          linkColor: greyShadeColor,
                          animation: true,
                          linkStyle: TextStyle(
                              color: blackColor,
                              fontSize: 12,
                              fontFamily: 'rudaw'),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //comment
                              IconButton(
                                onPressed: () async {
                                  Navigator.pushNamed(
                                      context, CommentScreen.routeName,
                                      arguments: widget.id as String);
                                },
                                icon: Icon(
                                  Icons.maps_ugc_outlined,
                                  size: 30,
                                  color: blackShadeColor,
                                ),
                              ),
                              widget.likes != null && widget.likes!.length > 0
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        '${widget.likes!.length} ' +
                                            'likes'.tr(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: blackColor,
                                            fontFamily: 'rudaw'),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),

                        //comment
                        widget.comments != null && widget.comments!.length > 0
                            ? TextButton(
                                onPressed: () async {
                                  Navigator.pushNamed(
                                      context, CommentScreen.routeName,
                                      arguments: widget.id as String);
                                },
                                child: TextWd(
                                    title: 'View all comments'.tr() +
                                        ' (${widget.comments!.length})',
                                    color: greyShadeColor,
                                    fSize: 12),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(widget.date!,
                            style: TextStyle(
                                color: greyShadeColor,
                                fontFamily: 'rudaw',
                                fontSize: 12))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
