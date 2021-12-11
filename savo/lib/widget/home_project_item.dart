import 'package:achievement_view/achievement_widget.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/comment_screen.dart';
import 'package:main/screens/my_account.dart';
import 'package:main/screens/user_account.dart';
import 'package:main/widget/Text.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:main/widget/languages.dart';
import 'package:main/widget/time_ago.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class HomeItemProject extends StatefulWidget {
  final bool myAccount;
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
  const HomeItemProject({
    Key? key,
    @required this.id,
    @required this.userId,
    @required this.title,
    @required this.image,
    @required this.description,
    @required this.price,
    @required this.likes,
    @required this.comments,
    @required this.saveList,
    @required this.category,
    @required this.date,
    required this.myAccount,
  }) : super(key: key);

  @override
  _HomeItemProjectState createState() => _HomeItemProjectState();
}

class _HomeItemProjectState extends State<HomeItemProject> {
  @override
  bool isLike = false;
  bool isSavetoList = false;
  bool isCircle = false;
  bool _onesSend = true;
  bool loadLikeButton = false;
  bool loadBookmarkButton = false;
  final formatter = NumberFormat('#,##,000');

  //Widget
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (widget.likes!.contains(user.uid)) {
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
    }

    return Padding(
      //padding all container
      padding: const EdgeInsets.all(5.0),
      child: Container(
        //padding big container
        padding: EdgeInsets.all(10.0), margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(25)),
        //main column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //future
            FutureBuilder<UserModel>(
              future: FireStore().getUserByIdFromFirestore(widget.userId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                    baseColor: tarik,
                    highlightColor: Colors.grey,
                    enabled: true,
                    period: Duration(milliseconds: 500),
                    //listTile
                    child: ListTile(
                      horizontalTitleGap: 2,
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: tarik),
                        ),
                        //avatar
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

                //has data
                var data = snapshot.data as UserModel;

                //listTile has data
                return ListTile(
                  onTap: () async {
                    if (user!.uid == data.id) {
                      Navigator.pushNamed(
                        context,
                        MyAccount.routeName,
                      );
                    } else {
                      Navigator.pushNamed(context, UserAccount.routeName,
                          arguments: data.id!);
                    }
                  },
                  dense: true,
                  horizontalTitleGap: 5,
                  leading: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: tarik)),
                    //avatar
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: greyShadeColor,
                      child: data.avatar == null || data.avatar!.length < 1
                          ? Icon(
                              Icons.person,
                              color: whiteColor,
                            )
                          : null,
                      backgroundImage:
                          data.avatar != null && data.avatar!.length > 1
                              ? NetworkImage(data.avatar!)
                              : null,
                    ),
                  ),
                  //title
                  title: Text(
                    data.name!,
                    style: TextStyle(
                        fontSize: 14, color: blackColor, fontFamily: 'rudaw'),
                  ),
                  subtitle: Text(
                    widget.category == 'question'
                        ? 'typePostQ'.tr()
                        : widget.category == 'work'
                            ? 'typePostW'.tr()
                            : widget.category == 'project'
                                ? 'typePostP'.tr()
                                : widget.category!,
                    style: TextStyle(
                      fontSize: 12,
                      color: blackColor,
                    ),
                  ),
                  //trailling
                  //price if doese have
                  trailing: widget.price != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 60),

                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: blackColor),
                              borderRadius: BorderRadius.circular(50),
                            ),

                            // margin: EdgeInsets.only(left: 2),
                            child: Center(
                              child: Text(
                                'Pay'.tr(),
                                style:
                                    TextStyle(color: blackColor, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                );
              },
            ),

            widget.category == 'question' || widget.category == 'work'
                ? Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: RegExp(r"^[\u0600-\u06FF\s]+$")
                                  .hasMatch(widget.title!) ||
                              RegExp(r"^[\u0621-\u064A]+$")
                                  .hasMatch(widget.title!)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        widget.title!,
                        textAlign: RegExp(r"^[\u0600-\u06FF\s]+$")
                                    .hasMatch(widget.title!) ||
                                RegExp(r"^[\u0621-\u064A]+$")
                                    .hasMatch(widget.title!)
                            ? TextAlign.right
                            : TextAlign.left,
                        style: TextStyle(
                            fontSize: 14,
                            color: blackColor,
                            fontFamily: 'rudaw',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                : SizedBox(),
            //if type is project, image
            widget.category == 'project'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: shiri,
                      height: 320,
                      width: 320,
                      child: Carousel(
                        images: widget.image!
                            .map(
                              (e) => FadeInImage(
                                fit: BoxFit.cover,
                                placeholder: AssetImage('assets/images/2.gif'),
                                image: NetworkImage(
                                  e,
                                ),
                              ),
                            )
                            .toList(),
                        autoplay: false,
                        dotSize: widget.image!.length < 2 ? 0.0 : 5.0,
                        dotSpacing: 15.0,
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
                  )
                : SizedBox(),

            //if is my account ,then like (Text)  appear like column
            widget.myAccount &&
                    widget.likes != null &&
                    widget.likes!.length > 0 &&
                    widget.category == 'project'
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${widget.likes!.length} ' + 'likes'.tr(),
                      style: TextStyle(
                          color: greyShadeColor,
                          fontSize: 12,
                          fontFamily: "rudaw"),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(),

            ///action, like, comment, bookmark // if project
            !widget.myAccount && widget.category == 'project'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.likes != null && widget.likes!.length > 0
                          ? Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                '${widget.likes!.length} ' + 'likes'.tr(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: blackColor,
                                    fontFamily: 'rudaw'),
                              ),
                            )
                          : SizedBox(),
                      Container(
                        child: Row(
                          children: [
                            loadBookmarkButton
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: blackColor,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    //bookmark
                                    icon: Icon(
                                      isSavetoList
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      size: 30,
                                      color: blackShadeColor,
                                    ),
                                    onPressed: () async {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      await user!.reload();
                                      print(user.emailVerified);
                                      if (user.emailVerified) {
                                        setState(() {
                                          loadBookmarkButton = true;
                                        });
                                        await FireStore()
                                            .SaveintoSaveList(widget.id!)!
                                            .then((value) {
                                          setState(() {
                                            loadBookmarkButton = false;
                                          });
                                        });
                                      } else if (!user.emailVerified) {
                                        await user
                                            .sendEmailVerification()
                                            .catchError((err) {
                                          AchievementView(
                                            context,
                                            alignment: Alignment.topCenter,
                                            elevation: 0,
                                            color: Colors.red,
                                            borderRadius: 50,
                                            icon: Icon(
                                              Icons.error_outline,
                                              color: spi,
                                              size: 25,
                                            ),
                                            title: 'Error'.tr(),
                                            subTitle:
                                                'You sent many requests. You cannot send other requests. Please visit your email.'.tr(),
                                            textStyleSubTitle: TextStyle(
                                              color: spi,
                                              fontSize: 14,
                                              fontFamily: 'rudaw',
                                            ),
                                            textStyleTitle: TextStyle(
                                              color: spi,
                                              fontSize: 14,
                                              fontFamily: 'rudaw',
                                            ),
                                          )..show();
                                          throw err;
                                        });
                                        
                                        AchievementView(
                                          context,
                                          alignment: Alignment.topCenter,
                                          elevation: 0,
                                          color: Colors.red,
                                          borderRadius: 50,
                                          icon: Icon(
                                            Icons.error_outline,
                                            color: spi,
                                            size: 25,
                                          ),
                                          subTitle:
                                              'Please verify your email.'.tr(),
                                          title: 'Email'.tr(),
                                          textStyleSubTitle: TextStyle(
                                            color: spi,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                          textStyleTitle: TextStyle(
                                            color: spi,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                        )..show();
                                      }
                                      if (isSavetoList)
                                        AchievementView(context,
                                            alignment: Alignment.topCenter,
                                            typeAnimationContent:
                                                AnimationTypeAchievement.fade,
                                            duration: Duration(seconds: 1),
                                            borderRadius: 30,
                                            color: tarik,
                                            isCircle: true,
                                            elevation: 0,
                                            subTitle: 'Save to the SAVO'.tr(),
                                            icon: Icon(
                                              Icons.task_alt,
                                              color: shiri,
                                            ),
                                            title: 'Savo'.tr(),
                                            listener: (status) {
                                          print(status);
                                        })
                                          ..show();
                                    },
                                  ),
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
                            //favorite
                            loadLikeButton
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: blackColor,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(
                                      isLike
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30,
                                      color: isLike
                                          ? redShadeColor
                                          : blackShadeColor,
                                    ),
                                    onPressed: () async {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      await user!.reload();
                                      setState(() {});
                                      print(user.emailVerified);
                                      if (user.emailVerified) {
                                        setState(() {
                                          loadLikeButton = true;
                                        });
                                        await FireStore()
                                            .likeByUserLogin(widget.id!)!
                                            .then((value) {
                                          setState(() {
                                            loadLikeButton = false;
                                          });
                                        });
                                      } else if (!user.emailVerified) {
                                        if (_onesSend) {
                                          setState(() {
                                            _onesSend = false;
                                          });
                                          await user
                                              .sendEmailVerification()
                                              .catchError((err) {
                                            AchievementView(
                                              context,
                                              alignment: Alignment.topCenter,
                                              elevation: 0,
                                              color: Colors.red,
                                              borderRadius: 50,
                                              icon: Icon(
                                                Icons.error_outline,
                                                color: spi,
                                                size: 25,
                                              ),
                                              title: 'Error'.tr(),
                                              subTitle:
                                                  'You sent many requests. You cannot send other requests. Please visit your email.'.tr(),
                                              textStyleSubTitle: TextStyle(
                                                color: spi,
                                                fontSize: 14,
                                                fontFamily: 'rudaw',
                                              ),
                                              textStyleTitle: TextStyle(
                                                color: spi,
                                                fontSize: 14,
                                                fontFamily: 'rudaw',
                                              ),
                                            )..show();
                                            throw err;
                                          });
                                          ;
                                          AchievementView(
                                            context,
                                            alignment: Alignment.topCenter,
                                            elevation: 0,
                                            color: Colors.red,
                                            borderRadius: 50,
                                            icon: Icon(
                                              Icons.error_outline,
                                              color: spi,
                                              size: 25,
                                            ),
                                            title: 'Email'.tr(),
                                            subTitle:
                                                'Please verify your email.'
                                                    .tr(),
                                            textStyleSubTitle: TextStyle(
                                              color: spi,
                                              fontSize: 14,
                                              fontFamily: 'rudaw',
                                            ),
                                            textStyleTitle: TextStyle(
                                              color: spi,
                                              fontSize: 14,
                                              fontFamily: 'rudaw',
                                            ),
                                          )..show();
                                          Future.delayed(Duration(minutes: 5),
                                              () {
                                            setState(() {
                                              _onesSend = true;
                                            });
                                          });
                                        } else {
                                          AchievementView(
                                            context,
                                            alignment: Alignment.topCenter,
                                            elevation: 0,
                                            color: Colors.green,
                                            borderRadius: 25,
                                            icon: Icon(
                                              Icons.error,
                                              color: spi,
                                              size: 30,
                                            ),
                                            title: 'Check email'.tr(),
                                            subTitle:
                                                'We sent you email verify. You cant send any request until 5 minute'
                                                    .tr(),
                                            textStyleSubTitle: TextStyle(
                                              color: spi,
                                              fontSize: 14,
                                              fontFamily: 'rudaw',
                                            ),
                                            textStyleTitle: TextStyle(
                                              color: spi,
                                              fontSize: 14,
                                              fontFamily: 'rudaw',
                                            ),
                                          )..show();
                                        }
                                      }
                                    },
                                  ),
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

                            //like animation example

                            // LikeButton(
                            //       isLiked: isLike,
                            //       onTap: (isLiked) async {
                            //         User? user = FirebaseAuth.instance.currentUser;
                            //         await user!.reload();
                            //         print(user.emailVerified);
                            //         if (user.emailVerified) {
                            //           await FireStore().likeByUserLogin(widget.id!);
                            //         } else if (!user.emailVerified) {
                            //           AchievementView(
                            //             context,
                            //             alignment: Alignment.topCenter,
                            //             elevation: 0,
                            //             color: Colors.red,
                            //             borderRadius: 50,
                            //             icon: Icon(
                            //               Icons.error_outline,
                            //               color: spi,
                            //               size: 25,
                            //             ),
                            //             title: 'Email',
                            //             subTitle: 'Please Verify Your Email.',
                            //             textStyleSubTitle: TextStyle(
                            //               color: spi,
                            //               fontSize: 14,
                            //               fontFamily: 'Ar',
                            //             ),
                            //             textStyleTitle: TextStyle(
                            //               color: spi,
                            //               fontSize: 14,
                            //               fontFamily: 'Ar',
                            //             ),
                            //           )..show();
                            //         }
                            //         return !isLiked;
                            //       },
                            //       bubblesSize: 80,
                            //       size: 30,
                            //       circleColor: CircleColor(start: shiri, end: tarik),
                            //       bubblesColor: BubblesColor(
                            //         dotPrimaryColor: shiri,
                            //         dotSecondaryColor: tarik,
                            //       ),
                            //       likeBuilder: (bool isLiked) {
                            //         return Icon(
                            //           isLiked ? Icons.favorite : Icons.favorite_outline,
                            //           color: shiri,
                            //           size: 30,
                            //         );
                            //       },
                            //     ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 10,
                  ),
            // in main column description
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //description
                  Container(
                    width: double.infinity,
                    child: ExpandableText(
                      '${widget.description}',
                      style: TextStyle(
                          color: blackColor, fontSize: 14, fontFamily: 'rudaw'),
                      textDirection: RegExp(r"^[\u0600-\u06FF\s]+$")
                                  .hasMatch(widget.description!) ||
                              RegExp(r"^[\u0621-\u064A]+$")
                                  .hasMatch(widget.description!)
                          ? ui.TextDirection.rtl
                          : ui.TextDirection.ltr,
                      expandText: 'more'.tr(),
                      collapseText: 'less ...'.tr(),
                      linkStyle: TextStyle(fontSize: 12),
                      maxLines: widget.category != 'project' ? 10 : 2,
                      linkColor: Colors.grey,
                      animation: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.myAccount &&
                          widget.likes != null &&
                          widget.likes!.length > 0 &&
                          widget.category != 'project'
                      ? Text(
                          '${widget.likes!.length} ' + 'likes'.tr(),
                          style: TextStyle(
                              fontSize: 12,
                              color: blackColor,
                              fontFamily: 'rudaw'),
                        )
                      : SizedBox(),
                  widget.price != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 150),

                                  height: 30,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(width: 1, color: blackColor),
                                    borderRadius: BorderRadius.circular(50),
                                  ),

                                  // margin: EdgeInsets.only(left: 2),
                                  child: Center(
                                    child: Text(
                                      '${formatter.format(widget.price!)} IQD',
                                      style: TextStyle(
                                          color: blackColor, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ]),
                        )
                      : SizedBox.shrink(),

                  /// if not project like and comment,bookmark appear like this
                  widget.category != 'project' && !widget.myAccount
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.likes != null && widget.likes!.length > 0
                                ? Text(
                                    '${widget.likes!.length} ' + 'likes'.tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: blackColor,
                                        fontFamily: 'rudaw'),
                                  )
                                : SizedBox(),
                            Container(
                              child: Row(
                                children: [
                                  loadBookmarkButton
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: Center(
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: blackColor,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        )
                                      : IconButton(
                                          //bookmark
                                          icon: Icon(
                                            isSavetoList
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            size: 30,
                                            color: blackShadeColor,
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              isCircle = true;
                                            });
                                            User? user = FirebaseAuth
                                                .instance.currentUser;
                                            await user!.reload();
                                            if (user.emailVerified) {
                                              setState(() {
                                                loadBookmarkButton = true;
                                              });
                                              await FireStore()
                                                  .SaveintoSaveList(widget.id!)!
                                                  .then((value) {
                                                setState(() {
                                                  loadBookmarkButton = false;
                                                });
                                              });
                                            } else if (!user.emailVerified) {
                                              await user
                                                  .sendEmailVerification()
                                                  .catchError((err) {
                                                AchievementView(
                                                  context,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  elevation: 0,
                                                  color: Colors.red,
                                                  borderRadius: 50,
                                                  icon: Icon(
                                                    Icons.error_outline,
                                                    color: spi,
                                                    size: 25,
                                                  ),
                                                  title: 'Error'.tr(),
                                                  subTitle:
                                                      'You sent many requests. You cannot send other requests. Please visit your email.'.tr(),
                                                  textStyleSubTitle: TextStyle(
                                                    color: spi,
                                                    fontSize: 14,
                                                    fontFamily: 'rudaw',
                                                  ),
                                                  textStyleTitle: TextStyle(
                                                    color: spi,
                                                    fontSize: 14,
                                                    fontFamily: 'rudaw',
                                                  ),
                                                )..show();
                                                throw err;
                                              });
                                              ;
                                              AchievementView(
                                                context,
                                                alignment: Alignment.topCenter,
                                                elevation: 0,
                                                color: Colors.red,
                                                borderRadius: 50,
                                                icon: Icon(
                                                  Icons.error_outline,
                                                  color: spi,
                                                  size: 25,
                                                ),
                                                title: 'Check your email'.tr(),
                                                subTitle:
                                                    'Please verify your email.'
                                                        .tr(),
                                                textStyleSubTitle: TextStyle(
                                                  color: spi,
                                                  fontSize: 14,
                                                  fontFamily: 'rudaw',
                                                ),
                                                textStyleTitle: TextStyle(
                                                  color: spi,
                                                  fontSize: 14,
                                                  fontFamily: 'rudaw',
                                                ),
                                              )..show();
                                            }
                                            if (isSavetoList)
                                              AchievementView(context,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  typeAnimationContent:
                                                      AnimationTypeAchievement
                                                          .fade,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  borderRadius: 30,
                                                  color: tarik,
                                                  isCircle: true,
                                                  elevation: 0,
                                                  subTitle:
                                                      'Save to the SAVO'.tr(),
                                                  icon: Icon(
                                                    Icons.task_alt,
                                                    color: shiri,
                                                  ),
                                                  title: 'Savo'.tr(),
                                                  listener: (status) {
                                                print(status);
                                              })
                                                ..show();
                                          },
                                        ),
                                  //comment
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, CommentScreen.routeName,
                                          arguments: widget.id as String);
                                    },
                                    icon: Icon(
                                      widget.category == 'question'
                                          ? Icons.question_answer_outlined
                                          : Icons.maps_ugc_outlined,
                                      size: 30,
                                      color: blackShadeColor,
                                    ),
                                  ),
                                  //favorite
                                  loadLikeButton
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: Center(
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: blackColor,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            isLike
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 30,
                                            color: isLike
                                                ? redShadeColor
                                                : blackShadeColor,
                                          ),
                                          onPressed: () async {
                                            User? user = FirebaseAuth
                                                .instance.currentUser;
                                            await user!.reload();
                                            print(user.emailVerified);
                                            if (user.emailVerified) {
                                              setState(() {
                                                isLike = !isLike;
                                                loadLikeButton = true;
                                              });
                                              await FireStore()
                                                  .likeByUserLogin(widget.id!)!
                                                  .then((value) {
                                                setState(() {
                                                  loadLikeButton = false;
                                                });
                                              });
                                            } else if (!user.emailVerified) {
                                              if (_onesSend) {
                                                setState(() {
                                                  _onesSend = false;
                                                });
                                                await user
                                                    .sendEmailVerification()
                                                    .catchError((err) {
                                                  AchievementView(
                                                    context,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    elevation: 0,
                                                    color: Colors.red,
                                                    borderRadius: 50,
                                                    icon: Icon(
                                                      Icons.error_outline,
                                                      color: spi,
                                                      size: 25,
                                                    ),
                                                    title: 'Error'.tr(),
                                                    subTitle:
                                                        'You sent many requests. You cannot send other requests. Please visit your email.'.tr(),
                                                    textStyleSubTitle:
                                                        TextStyle(
                                                      color: spi,
                                                      fontSize: 14,
                                                      fontFamily: 'rudaw',
                                                    ),
                                                    textStyleTitle: TextStyle(
                                                      color: spi,
                                                      fontSize: 14,
                                                      fontFamily: 'rudaw',
                                                    ),
                                                  )..show();
                                                  throw err;
                                                });
                                                ;
                                                AchievementView(
                                                  context,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  elevation: 0,
                                                  color: Colors.red,
                                                  borderRadius: 50,
                                                  icon: Icon(
                                                    Icons.error_outline,
                                                    color: spi,
                                                    size: 25,
                                                  ),
                                                  title: 'Email'.tr(),
                                                  subTitle:
                                                      'Please verify your email.'
                                                          .tr(),
                                                  textStyleSubTitle: TextStyle(
                                                    color: spi,
                                                    fontSize: 14,
                                                    fontFamily: 'rudaw',
                                                  ),
                                                  textStyleTitle: TextStyle(
                                                    color: spi,
                                                    fontSize: 14,
                                                    fontFamily: 'rudaw',
                                                  ),
                                                )..show();
                                                Future.delayed(
                                                    Duration(minutes: 5), () {
                                                  setState(() {
                                                    _onesSend = true;
                                                  });
                                                });
                                              } else {
                                                AchievementView(
                                                  context,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  elevation: 0,
                                                  color: Colors.green,
                                                  borderRadius: 25,
                                                  icon: Icon(
                                                    Icons.error,
                                                    color: spi,
                                                    size: 30,
                                                  ),
                                                  title: 'Check email'.tr(),
                                                  subTitle:
                                                      'We sent you email verify. You cant send any request until 5 minute'
                                                          .tr(),
                                                  textStyleSubTitle: TextStyle(
                                                    color: spi,
                                                    fontSize: 14,
                                                    fontFamily: 'rudaw',
                                                  ),
                                                  textStyleTitle: TextStyle(
                                                    color: spi,
                                                    fontSize: 14,
                                                    fontFamily: 'rudaw',
                                                  ),
                                                )..show();
                                              }
                                            }
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  //////////////////////////if^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                  //comment
                  widget.comments != null && widget.comments!.length > 0
                      ? TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, CommentScreen.routeName,
                                arguments: widget.id as String);
                          },
                          child: Text(
                            widget.comments!.length == 1
                                ? 'View the comment'.tr() +
                                    '(${widget.comments!.length}) '
                                : 'View all comments'.tr() +
                                    '(${widget.comments!.length})',
                            style: TextStyle(
                              color: greyShadeColor,
                              fontSize: 12,
                            ),
                          ))
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.date!,
                    style: TextStyle(
                      color: greyShadeColor,
                      fontFamily: "rudaw",
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
