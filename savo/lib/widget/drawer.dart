import 'package:achievement_view/achievement_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:main/color.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firebaseAuth.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/login_screen.dart';
import 'package:main/screens/note_screen.dart';
import 'package:main/screens/savo_save.dart';
import 'package:main/widget/languages.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool _mode = false;
  bool? _showLoc = false;
  bool _loadSwitchLoc = false;

  String dropdownValue = 'کوردی';
  void _showLocFun() async {
    bool? _check = await FireStore().getMyInfoAndCheckIfHaveLocation();
    setState(() {
      _showLoc = _check;
    });
  }

  @override
  void initState() {
    super.initState();
    _showLocFun();
  }

  @override
  Widget build(BuildContext context) {
    if (context.locale.toString().length > 1) {
      setState(() {
        if (context.locale.toString() == 'en') {
          dropdownValue = 'English';
        }
        if (context.locale.toString() == 'ar') {
          dropdownValue = 'عربي';
        }
        if (context.locale.toString() == 'ur') {
          dropdownValue = 'کوردی';
        }
        if (context.locale.toString() == 'de') {
          dropdownValue = 'German';
        }
        if (context.locale.toString() == 'fr') {
          dropdownValue = 'French';
        }
        if (context.locale.toString() == 'tr') {
          dropdownValue = 'Turkish';
        }
        if (context.locale.toString() == 'fa') {
          dropdownValue = 'فارسی';
        }
      });
    }
    return SafeArea(
        child: Container(
      width: 200,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        body: Container(
          width: 200,
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Theme'.tr(),
                    style: TextStyle(
                        color: blackColor, fontSize: 14.0, fontFamily: 'rudaw'),
                  ),
                  Text(
                    'Not available for now'.tr(),
                    style: TextStyle(
                        color: thered, fontSize: 12.0, fontFamily: 'rudaw'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: FlutterSwitch(
                        width: 100,
                        height: 40.0,
                        toggleSize: 50.0,
                        value: _mode,
                        borderRadius: 30.0,
                        padding: 0.0,
                        activeIcon: Image.asset('assets/images/sun.png'),
                        inactiveIcon: Image.asset('assets/images/moon.png'),
                        activeColor: whiteColor,
                        inactiveColor: greyShadeColor,
                        showOnOff: false,
                        onToggle: (val) {
                          setState(() {
                            _mode = val;
                          });
                        },
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: blackColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Show your location'.tr(),
                    style: TextStyle(
                        color: blackColor, fontSize: 14.0, fontFamily: 'rudaw'),
                  ),
                  Text(
                    '- ' + 'For map'.tr() + ' -',
                    style: TextStyle(
                        color: blackColor, fontSize: 14.0, fontFamily: 'rudaw'),
                  ),
                  _loadSwitchLoc
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: Container(
                              child: CircularProgressIndicator(
                                color: greyShadeColor,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: FlutterSwitch(
                              width: 100,
                              height: 40.0,
                              toggleSize: 50.0,
                              value: _showLoc!,
                              borderRadius: 30.0,
                              padding: 0.0,
                              inactiveIcon: CircleAvatar(
                                  backgroundColor: greyShadeColor,
                                  child: Icon(Icons.clear, color: whiteColor)),
                              activeIcon: CircleAvatar(
                                  backgroundColor: greyShadeColor,
                                  child: Icon(
                                    Icons.check,
                                    color: whiteColor,
                                  )),
                              activeColor: whiteColor,
                              inactiveColor: whiteColor,
                              showOnOff: false,
                              //
                              onToggle: (val) async {
                                String _userId = await FirebaseAuth
                                    .instance.currentUser!.uid;
                                if (val == false) {
                                  setState(() {
                                    _showLoc = false;
                                  });

                                  await FireStore()
                                      .updateLocation(_userId, false,
                                          lat: '', long: '')
                                      .catchError((err) {
                                    print(err);
                                  });
                                }
                                if (val == true) {
                                  final LocationData? locData =
                                      await Location().getLocation();

                                  var lat = locData!.latitude == null
                                      ? ''
                                      : locData.latitude.toString();
                                  var long = locData.longitude == null
                                      ? ''
                                      : locData.longitude.toString();
                                  _loadSwitchLoc = true;
                                  if (lat.length < 5 && long.length < 5) {
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
                                      title: 'Location'.tr(),
                                      subTitle:
                                          'Please retry switch location..'.tr(),
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
                                    return;
                                  } else {
                                    setState(() {
                                      _loadSwitchLoc = true;
                                    });
                                    await FireStore()
                                        .updateLocation(_userId, val,
                                            lat: lat, long: long)
                                        .then((value) {
                                      setState(() {
                                        _showLoc = val;
                                        _loadSwitchLoc = false;
                                      });
                                    }).catchError((err) {
                                      print(err);
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                  Divider(
                    height: 1,
                    color: greyShadeColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Language'.tr(),
                    style: TextStyle(
                        color: blackColor, fontSize: 14.0, fontFamily: 'rudaw'),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(
                      Icons.arrow_downward,
                      size: 20,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style:
                        TextStyle(color: greyShadeColor, fontFamily: "rudaw"),
                    underline: Container(
                      height: 2,
                      color: greyShadeColor,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        if (newValue == 'کوردی') {
                          context.setLocale(Locale('ur'));
                        }
                        if (newValue == 'English') {
                          context.setLocale(Locale('en'));
                        }
                        if (newValue == 'عربي') {
                          context.setLocale(Locale('ar'));
                        }
                        if (newValue == 'German') {
                          context.setLocale(Locale('de'));
                        }
                        if (newValue == 'French') {
                          context.setLocale(Locale('fr'));
                        }
                        if (newValue == 'Turkish') {
                          context.setLocale(Locale('tr'));
                        }
                        if (newValue == 'فارسی') {
                          context.setLocale(Locale('fa'));
                        }
                      });
                    },
                    items: [
                      'کوردی',
                      'عربي',
                      'فارسی',
                      'English',
                      'French',
                      'Turkish',
                      'German'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Divider(
                    height: 1,
                    color: blackColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    decoration: BoxDecoration(
                      color: greyShadeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.bookmark,
                        color: whiteColor,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SavoList.routeName);
                      },
                      label: Text(
                        'My savo list'.tr(),
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: 'rudaw',
                            fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 1,
                    color: blackColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    decoration: BoxDecoration(
                      color: thered,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, NoteScreen.routeName);
                      },
                      child: Text(
                        'Note, Read it please'.tr(),
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: 'rudaw',
                            fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Divider(
                    height: 1,
                    color: blackColor,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextButton(
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
                          if (value == 'yes') {
                            String myId =
                                await FirebaseAuth.instance.currentUser!.uid;
                            UserModel? userData =
                                await FireStore().getMyInfoFormFirestore();

                            UserModel newUserModel = await UserModel(
                                id: userData!.id,
                                rating: userData.rating,
                                email: userData.email,
                                avatar: userData.avatar,
                                name: userData.name,
                                date: userData.date,
                                ListOfLanguages: userData.ListOfLanguages,
                                experience: userData.experience,
                                listOfExperiences: userData.listOfExperiences,
                                gender: userData.gender,
                                language: userData.language,
                                location: userData.location,
                                tags: userData.tags,
                                token: '');

                            await FireAuth()
                                .updateMyProfile(myId, newUserModel, null)!
                                .then((value) => FirebaseAuth.instance
                                    .signOut()
                                    .then((value) =>
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            LoginScreen.routeName,
                                            (route) => false)));

                            // FirebaseAuth.instance.signOut().then((value) =>
                            //     Navigator.pushNamedAndRemoveUntil(context,
                            //         LoginScreen.routeName, (route) => false));
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: greyShadeColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Log out'.tr(),
                            style: TextStyle(
                                color: blackColor,
                                fontSize: 14.0,
                                fontFamily: 'rudaw'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: blackColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Copyright 2021 | All Rights Reserved.'.tr(),
                    style: TextStyle(
                        color: greyShadeColor,
                        fontFamily: 'rudaw',
                        fontSize: 10),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
