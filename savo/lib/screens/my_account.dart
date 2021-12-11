import 'package:achievement_view/achievement_view.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/add_post.dart';
import 'package:main/screens/edite_my_profile.dart';
import 'package:main/screens/home.dart';
import 'package:main/widget/Text.dart';
import 'package:main/widget/home_project_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class MyAccount extends StatefulWidget {
  static const routeName = '/my-acoount';

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool loadDelete = false;
  bool? _oneClickMyAccount = true;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    user!.reload();
    user.reload();
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: tarik,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, Home.routeName, (route) => false);
          },
        ),
        backgroundColor: Colors.transparent,

        //actions
        actions: [
          IconButton(
            onPressed: () async {
              User? user = await FirebaseAuth.instance.currentUser;
              Navigator.pushNamed(context, EditeMyProfile.routeName,
                  arguments: user!.uid);
            },
            hoverColor: tarik,
            splashColor: tarik,
            icon: Icon(
              Icons.mode,
              size: 25,
              color: tarik,
            ),
          ),
          IconButton(
            hoverColor: tarik,
            splashColor: tarik,
            icon: Icon(
              Icons.add,
              size: 30,
              color: tarik,
            ),
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              await user!.reload();
              await user.reload();

              if (user.emailVerified) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                width: 1,
                                color: shiri,
                              )),
                          backgroundColor: tarik,
                          content: TextWd(
                            title: 'what do you want to post?'.tr(),
                            color: shiri,
                            fSize: 18,
                          ),
                          actions: [
                            Row(children: [
                              //project button
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'project');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: thered,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 7),
                                    child: Text(
                                      'Project'.tr(),
                                      style: TextStyle(
                                        color: tarik,
                                        fontFamily: 'rudaw',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //work post
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'work');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: thegreen,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 7),
                                    child: Text(
                                      'Work'.tr(),
                                      style: TextStyle(
                                        color: tarik,
                                        fontFamily: 'rudaw',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //J-Vance post
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'question');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theyellow,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 7),
                                    child: Text(
                                      'Question'.tr(),
                                      style: TextStyle(
                                        color: tarik,
                                        fontFamily: 'rudaw',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        )).then(
                  (value) {
                    if (value == 'project') {
                      Navigator.pushNamed(context, AddPostInput.routeName,
                          arguments: 'project');
                    }
                    if (value == 'work') {
                      Navigator.pushNamed(context, AddPostInput.routeName,
                          arguments: 'work');
                    }
                    if (value == 'question') {
                      Navigator.pushNamed(context, AddPostInput.routeName,
                          arguments: 'question');
                    }
                  },
                ); //Show dialog
              } else if (!user.emailVerified) {
                if (_oneClickMyAccount!) {
                  setState(() {
                    _oneClickMyAccount = false;
                  });
                  await user.sendEmailVerification().catchError((err) {
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
                          'You sent many requests. You cannot send other requests. Please visit your email.'
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
                    title: 'Err',
                    subTitle: 'Please Verifye Your Email.',
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
                  Future.delayed(Duration(minutes: 5), () {
                    setState(() {
                      _oneClickMyAccount = true;
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
        ],
      ),

      // body
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /////////  FutureBuilder first
              FutureBuilder(
                future: FireStore().getMyInfoFormFirestore(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: whiteColor,
                      ),
                    );
                  }

                  //Has data
                  var data = snapshot.data as UserModel;
                  int _1 = 0;
                  int _2 = 0;
                  int _3 = 0;
                  int _4 = 0;
                  int _5 = 0;
                  var _reviews = 0.0;
                  data.rating!.forEach(
                    (key, value) {
                      if (key == '1') {
                        _1 = value.length * 1;
                        _reviews = _reviews + value.length;
                      }
                      if (key == '2') {
                        _2 = value.length * 2;
                        _reviews = _reviews + value.length;
                      }
                      if (key == '3') {
                        _3 = value.length * 3;
                        _reviews = _reviews + value.length;
                      }
                      if (key == '4') {
                        _4 = value.length * 4;
                        _reviews = _reviews + value.length;
                      }
                      if (key == '5') {
                        _5 = value.length * 5;
                        _reviews = _reviews + value.length;
                      }
                    },
                  );

                  double rate = (5 * _5 + 4 * _4 + 3 * _3 + 2 * _2 + 1 * _1) /
                      (_5 + _4 + _3 + _2 + _1);
                  if (rate.isNaN) {
                    rate = 0;
                  }
                  print(rate);
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: tarik,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //profile
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  // avatar
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        width: 3,
                                        color: tarik,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: data.avatar == null ||
                                              data.avatar!.length < 1
                                          ? Icon(
                                              Icons.person,
                                              color: tarik,
                                            )
                                          : Image.network(
                                              data.avatar!,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //ratting
                                    SmoothStarRating(
                                      defaultIconData: Icons.star_border,
                                      halfFilledIconData: Icons.star_half,
                                      filledIconData: Icons.star,
                                      allowHalfRating: true,
                                      onRated: (v) {},
                                      starCount: 5,
                                      rating: rate,
                                      size: 30.0,
                                      isReadOnly: true,
                                      color: tarik,
                                      borderColor: tarik,
                                      spacing: 5.5,
                                    ),
                                    //views
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: tarik,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(children: [
                                        Icon(
                                          Icons.reviews,
                                          color: shiri,
                                        ),
                                        Text(
                                          '${_reviews.toStringAsFixed(0)} ' +
                                              'Voter'.tr(),
                                          style: TextStyle(
                                            color: shiri,
                                            fontSize: 12,
                                            fontFamily: 'rudaw',
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                //name
                                Container(
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: tarik,
                                  ),
                                  child: ListTile(
                                    horizontalTitleGap: 0,
                                    dense: true,
                                    leading:
                                        Icon(Icons.person, color: whiteColor),
                                    title: Text(
                                      data.name!,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 14,
                                        fontFamily: 'rudaw',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //email
                                Container(
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: tarik,
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    horizontalTitleGap: 0,
                                    leading: Icon(
                                      Icons.email,
                                      color: whiteColor,
                                    ),
                                    title: Text(
                                      data.email!,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 14,
                                        fontFamily: 'rudaw',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //gender
                                data.gender != 'Other' && data.gender != null
                                    ? Container(
                                        padding: EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: tarik,
                                        ),
                                        child: ListTile(
                                          dense: true,
                                          horizontalTitleGap: 0,
                                          leading: Icon(
                                            data.gender == 'Male'
                                                ? Icons.male
                                                : data.gender == 'Female'
                                                    ? Icons.female
                                                    : null,
                                            color: whiteColor,
                                          ),
                                          title: Text(
                                            data.gender!,
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 14,
                                              fontFamily: 'rudaw',
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                data.gender != 'Other' && data.gender != null
                                    ? SizedBox(
                                        height: 10,
                                      )
                                    : SizedBox(),

                                //location
                                // data.location != null &&
                                //         data.location!.length > 2
                                //     ? Container(
                                //         padding: EdgeInsets.all(0),
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(18),
                                //           color: tarik,
                                //         ),
                                //         child: ListTile(
                                //           dense: true,
                                //           horizontalTitleGap: 0,
                                //           leading: Icon(
                                //             Icons.fmd_good,
                                //             color: whiteColor,
                                //           ),
                                //           title: Text(
                                //             data.location!,
                                //             style: TextStyle(
                                //               color: whiteColor,
                                //               fontSize: 14,
                                //               fontFamily: 'Ar',
                                //             ),
                                //           ),
                                //         ),
                                //       )
                                //     : SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          //Experience main
                          data.experience!.length > 20 ||
                                  data.listOfExperiences!.length > 0
                              ? Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //text Experience
                                      data.experience!.length > 20 ||
                                              data.listOfExperiences!.length > 0
                                          ? Text(
                                              'Experience'.tr(),
                                              style: TextStyle(
                                                  color: tarik,
                                                  fontSize: 16,
                                                  fontFamily: 'rudaw'),
                                            )
                                          : SizedBox(),

                                      data.experience!.length > 20
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: ExpandableText(
                                                data.experience!,
                                                textDirection: RegExp(
                                                                r"^[\u0600-\u06FF\s]+$")
                                                            .hasMatch(data
                                                                .experience!) ||
                                                        RegExp(r"^[\u0621-\u064A]+$")
                                                            .hasMatch(data
                                                                .experience!)
                                                    ? ui.TextDirection.rtl
                                                    : ui.TextDirection.ltr,
                                                style: TextStyle(
                                                  fontFamily: 'rudaw',
                                                  color: tarik,
                                                  fontSize: 14,
                                                ),
                                                expandText: 'more'.tr(),
                                                collapseText: 'less ...'.tr(),
                                                maxLines: 5,
                                                linkColor: Colors.grey,
                                                animation: true,
                                                linkStyle: TextStyle(
                                                  fontFamily: 'rudaw',
                                                  color: greyShadeColor,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),

                                      //grid of experience circle
                                      SizedBox(
                                        height: 20,
                                      ),
                                      data.listOfExperiences!.length > 0
                                          ? GridView.builder(
                                              itemCount: data
                                                  .listOfExperiences!.length,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 4,
                                                mainAxisSpacing: 4,
                                                childAspectRatio:
                                                    (itemWidth / itemHeight) +
                                                        .09,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                //
                                                //return
                                                return Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: tarik,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //text of ex circle
                                                      Text(
                                                        data.listOfExperiences!
                                                            .keys
                                                            .toList()[index],
                                                        style: TextStyle(
                                                            color: whiteColor,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'rudaw'),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Container(
                                                        height: 60,
                                                        child: SfRadialGauge(
                                                          axes: [
                                                            RadialAxis(
                                                              showLabels: false,
                                                              showTicks: false,
                                                              startAngle: 90,
                                                              endAngle: 90,
                                                              minimum: 0,
                                                              maximum: 100,
                                                              radiusFactor: 1.2,
                                                              axisLineStyle:
                                                                  AxisLineStyle(
                                                                      color: Colors
                                                                          .black12),
                                                              annotations: [
                                                                GaugeAnnotation(
                                                                  positionFactor:
                                                                      .2,
                                                                  axisValue: 0,
                                                                  widget: Text(
                                                                    '${data.listOfExperiences!.values.toList()[index]}%',
                                                                    style: TextStyle(
                                                                        color:
                                                                            whiteColor,
                                                                        fontFamily:
                                                                            'rudaw',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                )
                                                              ],
                                                              pointers: [
                                                                RangePointer(
                                                                  color:
                                                                      whiteColor,
                                                                  value: double.parse(data
                                                                      .listOfExperiences!
                                                                      .values
                                                                      .toList()[index]),
                                                                  width: 5,
                                                                  cornerStyle:
                                                                      CornerStyle
                                                                          .bothCurve,
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 10,
                          ),

                          //Languages main
                          data.language!.length > 20 ||
                                  data.ListOfLanguages!.length > 0
                              ? Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //text languages
                                      data.language!.length > 20 ||
                                              data.ListOfLanguages!.length > 0
                                          ? Text(
                                              'Languages'.tr(),
                                              style: TextStyle(
                                                  color: tarik,
                                                  fontSize: 16,
                                                  fontFamily: 'rudaw'),
                                            )
                                          : SizedBox(),

                                      data.language!.length > 20
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: ExpandableText(
                                                data.language!,
                                                textDirection: RegExp(
                                                                r"^[\u0600-\u06FF\s]+$")
                                                            .hasMatch(data
                                                                .language!) ||
                                                        RegExp(r"^[\u0621-\u064A]+$")
                                                            .hasMatch(
                                                                data.language!)
                                                    ? ui.TextDirection.rtl
                                                    : ui.TextDirection.ltr,
                                                style: TextStyle(
                                                  fontFamily: 'rudaw',
                                                  color: tarik,
                                                  fontSize: 14,
                                                ),
                                                expandText: 'more'.tr(),
                                                collapseText: 'less ...'.tr(),
                                                maxLines: 5,
                                                linkColor: Colors.grey,
                                                animation: true,
                                                linkStyle: TextStyle(
                                                  fontFamily: 'rudaw',
                                                  color: greyShadeColor,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //grid of languages circle
                                      data.ListOfLanguages!.length > 0
                                          ? GridView.builder(
                                              itemCount:
                                                  data.ListOfLanguages!.length,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 4,
                                                mainAxisSpacing: 4,
                                                childAspectRatio:
                                                    (itemWidth / itemHeight) +
                                                        .09,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: tarik,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //text of lang circle
                                                      Text(
                                                        data.ListOfLanguages!
                                                            .keys
                                                            .toList()[index],
                                                        style: TextStyle(
                                                            color: whiteColor,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'rudaw'),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Container(
                                                        height: 60,
                                                        child: SfRadialGauge(
                                                          axes: [
                                                            RadialAxis(
                                                              showLabels: false,
                                                              showTicks: false,
                                                              startAngle: 90,
                                                              endAngle: 90,
                                                              minimum: 0,
                                                              maximum: 100,
                                                              radiusFactor: 1.2,
                                                              axisLineStyle:
                                                                  AxisLineStyle(
                                                                      color: Colors
                                                                          .black12),
                                                              annotations: [
                                                                GaugeAnnotation(
                                                                  positionFactor:
                                                                      .2,
                                                                  axisValue: 0,
                                                                  widget: Text(
                                                                    '${data.ListOfLanguages!.values.toList()[index]}%',
                                                                    style: TextStyle(
                                                                        color:
                                                                            whiteColor,
                                                                        fontFamily:
                                                                            'rudaw',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                )
                                                              ],
                                                              pointers: [
                                                                RangePointer(
                                                                  color:
                                                                      whiteColor,
                                                                  value: double.parse(data
                                                                      .ListOfLanguages!
                                                                      .values
                                                                      .toList()[index]),
                                                                  width: 5,
                                                                  cornerStyle:
                                                                      CornerStyle
                                                                          .bothCurve,
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                decoration: BoxDecoration(
                    color: tarik, borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.business_center_outlined,
                          color: shiri,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.rule_folder_outlined,
                          color: shiri,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.engineering_outlined,
                          color: shiri,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //FutureBuilder
              Flexible(
                child: FutureBuilder(
                  future: FireStore().getMyPostFromFirestore(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: whiteColor,
                      ));
                    }
                    var data = snapshot.data as List;
                    if (data.length < 1) {
                      return Container(
                        height: 200,
                        child: Stack(children: [
                          SvgPicture.asset('assets/images/svgloadingmyacc.svg'),
                          Positioned(
                              right: 100,
                              bottom: 40,
                              child: TextWd(
                                color: shiri,
                                fSize: 30,
                                title: 'No Post'.tr(),
                              ))
                        ]),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        void edite() {
                          Navigator.pushNamed(
                            context,
                            AddPostInput.routeName,
                            arguments: data[index].id,
                          );
                        }

                        void delete() {
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
                          ).then((value) {
                            print(value);
                            if (value == 'yes') {
                              setState(() {
                                loadDelete = true;
                              });
                              FireStore()
                                  .deletePostById(
                                      data[index].id, data[index].imageUrl)!
                                  .then(
                                (value) {
                                  setState(() {
                                    loadDelete = false;
                                  });

                                  AchievementView(
                                    context,
                                    elevation: 0,
                                    alignment: Alignment.bottomCenter,
                                    duration: Duration(seconds: 1),
                                    title: 'POST',
                                    subTitle: 'Post have been deleted',
                                    color: theyellow,
                                    borderRadius: 30,
                                    icon: Icon(Icons.delete, color: tarik),
                                    textStyleTitle: TextStyle(
                                      color: tarik,
                                    ),
                                    textStyleSubTitle: TextStyle(
                                      color: tarik,
                                    ),
                                  )..show();
                                },
                              );
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
                                loadDelete
                                    ? Positioned.fill(
                                        bottom: 80,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.black38,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 4,
                                                color: shiri,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            !loadDelete
                                ? Positioned(
                                    top: 10,
                                    right: 2,
                                    child: PopupMenuButton(
                                      elevation: 0,
                                      onCanceled: () {
                                        print('cencel');
                                      },
                                      onSelected: (value) {
                                        if (value == 'delete') {
                                          delete();
                                        }
                                        if (value == 'edite') {
                                          edite();
                                        }
                                      },
                                      color: tarik,
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gapPadding: 10),
                                      icon: Icon(Icons.more_vert,
                                          size: 30, color: tarik),
                                      tooltip: 'delete or edite the post',
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: ListTile(
                                            horizontalTitleGap: -10,
                                            leading: Icon(
                                              Icons.edit,
                                              color: shiri,
                                            ),
                                            title: TextWd(
                                                title: 'Edite'.tr(),
                                                color: shiri,
                                                fSize: 14),
                                          ),
                                          value: 'edite',
                                        ),
                                        PopupMenuItem(
                                          child: Container(
                                            child: ListTile(
                                              dense: true,
                                              horizontalTitleGap: -10,
                                              leading: Icon(
                                                Icons.delete,
                                                color: shiri,
                                              ),
                                              title: TextWd(
                                                  title: 'Delete'.tr(),
                                                  color: shiri,
                                                  fSize: 14),
                                            ),
                                          ),
                                          value: 'delete',
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
