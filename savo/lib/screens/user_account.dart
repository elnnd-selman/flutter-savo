import 'package:achievement_view/achievement_view.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/provider/firestoreChat.dart';
import 'package:main/screens/add_post.dart';
import 'package:main/screens/chat_savo.dart';
import 'package:main/screens/chat_savo_2.dart';
import 'package:main/screens/edite_my_profile.dart';
import 'package:main/screens/home.dart';
import 'package:main/widget/Text.dart';
import 'package:main/widget/home_project_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class UserAccount extends StatefulWidget {
  static const routeName = '/user-account';

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<UserAccount> {
  bool loadDelete = false;
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    //user in modal to retrive user info
    String? userId = ModalRoute.of(context)!.settings.arguments as String?;
    //my id when login
    String? _myUserId = FirebaseAuth.instance.currentUser!.uid;
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
            Navigator.pop(context);
          },
        ),
        actions: [],
        backgroundColor: Colors.transparent,

        //actions
      ),

      // body
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FutureBuilder first
              FutureBuilder(
                future: FireStore().getUserByIdFromFirestore(userId!),
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
                  bool _showRatebutton = true;
                  if (data.rating != null) {
                    data.rating!.forEach(
                      (key, value) {
                        if (value.contains(_myUserId)) {
                          _showRatebutton = false;
                          print(_showRatebutton);
                        }
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
                  }
                  print(_showRatebutton);
                  double rate = (5 * _5 + 4 * _4 + 3 * _3 + 2 * _2 + 1 * _1) /
                      (_5 + _4 + _3 + _2 + _1);
                  if (rate.isNaN) {
                    rate = 0;
                  }

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

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      TextButton.icon(
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatSavoScrenn2(
                                                nameSecound: data.name!,
                                                tokenSecound: data.token,
                                                userId2: data.id!,
                                              ),
                                            ),
                                          ).then((value) async {
                                            if (value == 'delete') {
                                              await FireStoreChat()
                                                  .deletEmptyChat();
                                            }
                                          });
                                          ;
                                        },
                                        icon: Icon(
                                          Icons.chat_bubble,
                                          size: 23,
                                          color: tarik,
                                        ),
                                        label: Text(
                                          'Send message'.tr(),
                                          style: TextStyle(
                                              color: tarik,
                                              fontFamily: 'rudaw',
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Divider(
                                  height: 1,
                                  color: tarik,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //ratting
                                    Column(
                                      children: [
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
                                        _showRatebutton
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: TextButton.icon(
                                                    icon: Icon(
                                                      Icons.reviews,
                                                      size: 20,
                                                      color: tarik,
                                                    ),
                                                    label: Text(
                                                      'Rate me please'.tr(),
                                                      style: TextStyle(
                                                        color: tarik,
                                                        fontFamily: 'rudaw',
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Container(
                                                                child: Center(
                                                                  child: Text(
                                                                    'Rate my project and my experience'
                                                                        .tr(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          tarik,
                                                                      fontFamily:
                                                                          'rudaw',
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                      side:
                                                                          BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            shiri,
                                                                      )),
                                                              content:
                                                                  Container(
                                                                height: 240,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    //1
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _showRatebutton =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context,
                                                                            '1');
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                30,
                                                                            vertical:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                tarik,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '1',
                                                                            style: TextStyle(
                                                                                color: whiteColor,
                                                                                fontFamily: 'rudaw',
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    //2
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _showRatebutton =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context,
                                                                            '2');
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                30,
                                                                            vertical:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                tarik,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '2',
                                                                            style: TextStyle(
                                                                                color: whiteColor,
                                                                                fontFamily: 'rudaw',
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    //3
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _showRatebutton =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context,
                                                                            '3');
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                30,
                                                                            vertical:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                tarik,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '3',
                                                                            style: TextStyle(
                                                                                color: whiteColor,
                                                                                fontFamily: 'rudaw',
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    //4
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _showRatebutton =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context,
                                                                            '4');
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                30,
                                                                            vertical:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                tarik,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '4',
                                                                            style: TextStyle(
                                                                                color: whiteColor,
                                                                                fontFamily: 'rudaw',
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    //5
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _showRatebutton =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context,
                                                                            '5');
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                30,
                                                                            vertical:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                tarik,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '5',
                                                                            style: TextStyle(
                                                                                color: whiteColor,
                                                                                fontFamily: 'rudaw',
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: [],
                                                            );
                                                          }).then((value) async {
                                                        if (value != null) {
                                                          await FireStore()
                                                              .rateUser(
                                                                  userId,
                                                                  value,
                                                                  _myUserId)
                                                              .then((value) {
                                                            AchievementView(
                                                              context,
                                                              alignment:
                                                                  Alignment
                                                                      .topCenter,
                                                              elevation: 0,
                                                              color: tarik,
                                                              borderRadius: 50,
                                                              icon: Icon(
                                                                Icons.check,
                                                                color:
                                                                    whiteColor,
                                                                size: 25,
                                                              ),
                                                              title:
                                                                  'Rate'.tr(),
                                                              subTitle:
                                                                  'Thank you for rate me.'
                                                                      .tr(),
                                                              textStyleSubTitle:
                                                                  TextStyle(
                                                                color: spi,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'rudaw',
                                                              ),
                                                              textStyleTitle:
                                                                  TextStyle(
                                                                color: spi,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'rudaw',
                                                              ),
                                                            )..show();
                                                          });
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
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
                                  height: 5,
                                ),
                                Divider(
                                  height: 1,
                                  color: tarik,
                                ),
                                SizedBox(
                                  height: 5,
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
                                                fontFamily: 'rudaw',
                                              ),
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
                                                expandText: 'more',
                                                collapseText: 'less',
                                                maxLines: 5,
                                                linkColor: Colors.grey,
                                                animation: true,
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
                  future: FireStore().getUserPostByIdFromFirestore(userId),
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
                                  userId: userId,
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
