import 'package:achievement_view/achievement_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:main/assets/my_flutter_app_icons.dart';
import 'package:main/color.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firebaseAuth.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/add_post.dart';
import 'package:main/screens/chat_room_savo.dart';
import 'package:main/screens/login_screen.dart';
import 'package:main/screens/map_screen.dart';
import 'package:main/screens/my_account.dart';
import 'package:main/screens/no_internet_screen.dart';
import 'package:main/widget/drawer.dart';
import 'package:main/widget/home_project_item.dart';
import 'package:main/widget/languages.dart';
import 'package:main/widget/seacrh_delegate.dart';
import 'package:main/widget/seacrh_delegate_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity/connectivity.dart';

import '../main.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _typePost = 'all';
  bool _onesSend = true;

  Map? filterItem = {};
  void _firstLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', 'en');
  }

  // void checkInternet() async {
  //   ConnectivityResult result = await Connectivity().checkConnectivity();

  //   if (result == ConnectivityResult.none) {
  //     Future.delayed(Duration.zero, () {
  //       Navigator.pushNamed(context, NoInternet.routeName);
  //     });
  //   }
  // }
  Future<void> tokenSet() async {
    var _fbm = FirebaseMessaging.instance;
    String? userId = await FirebaseAuth.instance.currentUser!.uid;

    UserModel? userData = await FireStore().getMyInfoFormFirestore();
    String? token = await _fbm.getToken();
    print(token);
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
        token: token!);

    FireAuth().updateMyProfile(userId, newUserModel, null);
  }

  @override
  void initState() {
    super.initState();
    tokenSet();
    // checkInternet();
    // Connectivity().checkConnectivity().then((value) {
    //   print(
    //       'r----------------------------------------------------------------esult');
    //   print(value);
    //   print(
    //       'r----------------------------------------------------------------esult');
    // });

    var initialAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initialSetting = InitializationSettings(android: initialAndroid);
    flutterLocalNotificationsPlugin!.initialize(initialSetting);
    var fbm = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channel!.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });
    fbm.subscribeToTopic('chat');

    _firstLanguage();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  getToket() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Scaffold(
          extendBody: true,
          backgroundColor: backgroundColor,
          //drawer
          drawer: DrawerScreen(),
          //appbar
          appBar: AppBar(
            elevation: 0,
            shape: Border(
              bottom: BorderSide(color: Colors.grey.shade50, width: 2),
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              'savo',
              style: TextStyle(
                  color: blackColor,
                  fontSize: 26,
                  fontFamily: 'savo1',
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.clear_all,
                  size: 35,
                  color: blackColor,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: blackColor,
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(
                        ' What are you looking for?'.tr(),
                        style: TextStyle(
                          color: blackColor,
                          fontFamily: 'rudaw',
                          fontSize: 18,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'user');
                          },
                          child: Text(
                            'User'.tr(),
                            style: TextStyle(
                              color: blackColor,
                              fontFamily: 'rudaw',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'post');
                          },
                          child: Text(
                            'Post'.tr(),
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
                    if (value == 'post') {
                      var data =
                          await FireStore().getPostFromFirestoreForSeach();
                      showSearch(
                          context: context, delegate: SeacrhDelegateW(data));
                    } else if (value == 'user') {
                      var data = await FireStore().getAllUserFromFirestore();
                      showSearch(
                          context: context, delegate: SeacrhDelegateWU(data!));
                    }
                  });
                },
              ),
              _typePost == 'question'
                  ? IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 30,
                        color: blackColor,
                      ),
                      onPressed: () async {
                        await user!.reload();
                        setState(() {});
                        if (user.emailVerified) {
                          Navigator.pushNamed(context, AddPostInput.routeName,
                              arguments: 'question');
                        } else {
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
                                title: 'Email'.tr(),
                                subTitle: 'Please verify your email.'.tr(),
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
                              title: 'Email'.tr(),
                              subTitle: 'Please verify your email.'.tr(),
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

                            print('1');
                            Future.delayed(
                              Duration(minutes: 5),
                              () {
                                setState(
                                  () {
                                    _onesSend = true;
                                  },
                                );
                              },
                            );
                          } else {
                            AchievementView(
                              context,
                              duration: Duration(seconds: 5),
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
                    )
                  : SizedBox(),
              FutureBuilder(
                  future: FireStore().getMyInfoFormFirestore(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Shimmer.fromColors(
                        period: Duration(milliseconds: 500),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: tarik),
                                  borderRadius: BorderRadius.circular(50)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ],
                        ),
                        baseColor: tarik,
                        highlightColor: greyShadeColor,
                      );
                    }
                    UserModel data = snapshot.data as UserModel;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, MyAccount.routeName);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: tarik),
                                  borderRadius: BorderRadius.circular(50)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: data.avatar != null &&
                                        data.avatar!.length > 5
                                    ? Image.network(data.avatar!)
                                    : Icon(
                                        Icons.person,
                                        color: tarik,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
          //bottomNavigationBar
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            //bottomNavigationBar Container
            child: Container(
              height: 56,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: tarik,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [BoxShadow()]),
              child: BottomNavigationBar(
                iconSize: 25,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                        border: _typePost == 'all'
                            ? Border(
                                bottom: BorderSide(width: 1, color: shiri),
                              )
                            : null,
                      ),
                      child: Icon(
                        _typePost == 'all' ? Icons.home : Icons.home_outlined,
                        color: shiri,
                      ),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                        border: _typePost == 'work'
                            ? Border(
                                bottom: BorderSide(width: 1, color: shiri),
                              )
                            : null,
                      ),
                      child: Icon(
                        _typePost == 'work'
                            ? Icons.business_center
                            : Icons.business_center_outlined,
                        color: shiri,
                      ),
                    ),
                    label: 'Work',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                        border: _typePost == 'project'
                            ? Border(
                                bottom: BorderSide(width: 1, color: shiri),
                              )
                            : null,
                      ),
                      child: Icon(
                        _typePost == 'project'
                            ? Icons.rule_folder
                            : Icons.rule_folder_outlined,
                        color: shiri,
                      ),
                    ),
                    label: 'Project',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                        border: _typePost == 'question'
                            ? Border(
                                bottom: BorderSide(width: 1, color: shiri),
                              )
                            : null,
                      ),
                      child: Icon(
                        MyIcon.question_solid,
                        color: _typePost == 'question' ? shiri : Colors.white54,
                        size: _typePost == 'question' ? 23 : 20,
                      ),
                    ),
                    label: 'question',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.my_location_outlined,
                      color: shiri,
                      size: 26,
                    ),
                    label: 'GPS',
                  ),
                ],
                currentIndex: 0,
                selectedItemColor: Colors.amber[800],
                onTap: (e) async {
                  if (e == 0) {
                    setState(() {
                      _typePost = 'all';
                    });
                  }
                  if (e == 1) {
                    setState(() {
                      _typePost = 'work';
                    });
                  }
                  if (e == 2) {
                    setState(() {
                      _typePost = 'project';
                    });
                  }
                  if (e == 3) {
                    setState(() {
                      _typePost = 'question';
                    });
                  }
                  if (e == 4) {
                    Navigator.pushNamed(context, GoogleMapScreen.routeName);
                  }
                },
              ),
            ),
          ),
          //body//////////////////////////////////////////////
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 0),
                        decoration: BoxDecoration(
                          color: tarik,
                          borderRadius: context.locale.toString() == 'ur' ||
                                  context.locale.toString() == 'ar' ||
                                  context.locale.toString() == 'fa'
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )
                              : BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                        ),
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.grain,
                            color: whiteColor,
                            size: 15,
                          ),
                          label: Text(
                            filterItem == null || filterItem!.length < 1
                                ? 'Filter'.tr()
                                : 'Remove Filter'.tr(),
                            style: TextStyle(
                                color:
                                    filterItem == null || filterItem!.length < 1
                                        ? whiteColor
                                        : thered,
                                fontFamily: "rudaw",
                                fontSize: 12,
                                fontWeight: FontWeight.w100),
                          ),
                          onPressed: () {
                            if (filterItem != null && filterItem!.length < 1) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  bool technology = false;
                                  bool science = false;
                                  bool health = false;
                                  bool sport = false;
                                  bool art = false;
                                  bool history = false;
                                  bool society = false;
                                  bool religion = false;
                                  bool employee = false;
                                  bool car = false;

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: Text(
                                          'Filter'.tr(),
                                          style: TextStyle(
                                              color: blackColor,
                                              fontFamily: "rudaw",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w100),
                                        ),
                                        content: Container(
                                          height: 300,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: technology,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      technology = value!;
                                                      print(technology);
                                                    });
                                                  },
                                                  title: Text(
                                                    'Technology'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                                /////science
                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: science,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      science = value!;
                                                      print(science);
                                                    });
                                                  },
                                                  title: Text(
                                                    'Science'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                                //////health
                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: health,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      health = value!;
                                                      print(health);
                                                    });
                                                  },
                                                  title: Text(
                                                    'Health'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                                //////sport
                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: sport,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      sport = value!;
                                                      print(sport);
                                                    });
                                                  },
                                                  title: Text(
                                                    'Sport'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                                //////Art
                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: art,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      art = value!;
                                                      print(art);
                                                    });
                                                  },
                                                  title: Text(
                                                    'Art'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                                //////history

                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: history,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      history = value!;
                                                      print(history);
                                                    });
                                                  },
                                                  title: Text(
                                                    'History'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                                //////society
                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: society,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      society = value!;
                                                      print(society);
                                                    });
                                                  },
                                                  title: Text(
                                                    'Society'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                                //////religion
                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: religion,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      religion = value!;
                                                      print(religion);
                                                    });
                                                  },
                                                  title: Text(
                                                    'Religion'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                                CheckboxListTile(
                                                  dense: true,
                                                  checkColor: whiteColor,
                                                  activeColor: blackColor,
                                                  value: employee,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      employee = value!;
                                                      print(employee);
                                                    });
                                                  },
                                                  title: Text(
                                                    'Employee'.tr(),
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "rudaw",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, {
                                                "technology": technology,
                                                "science": science,
                                                "health": health,
                                                "sport": sport,
                                                "art": art,
                                                "history": history,
                                                "society": society,
                                                "religion": religion,
                                                "employee": employee,
                                                "employee": employee,
                                              });
                                            },
                                            child: Text(
                                              'Ok'.tr(),
                                              style: TextStyle(
                                                  color: blackColor,
                                                  fontFamily: "rudaw",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, null);
                                            },
                                            child: Text(
                                              'Cancel'.tr(),
                                              style: TextStyle(
                                                  color: blackColor,
                                                  fontFamily: "rudaw",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              ).then((value) {
                                print(
                                    'ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');

                                print(value);
                                print(
                                    'ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');

                                setState(() {
                                  filterItem = value;
                                });
                              });
                            } else {
                              setState(() {
                                filterItem = {};
                              });
                            }
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('object');
                          Navigator.pushNamed(context, SavoChat.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 18),
                          margin: EdgeInsets.only(top: 5, left: 0),
                          decoration: BoxDecoration(
                            color: tarik,
                            borderRadius: context.locale.toString() == 'ur' ||
                                    context.locale.toString() == 'ar' ||
                                    context.locale.toString() == 'fa'
                                ? BorderRadius.only(
                                    topRight: Radius.circular(22),
                                    bottomRight: Radius.circular(22),
                                  )
                                : BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                    bottomLeft: Radius.circular(22),
                                  ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Savchat'.tr(),
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: "rudaw",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.chat_bubble,
                                color: whiteColor,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  StreamBuilder<Object>(
                      stream: FireStore()
                          .getPostFromFirestore(_typePost!, filterItem),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Shimmer.fromColors(
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: tarik,
                                            ),
                                            title: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: tarik,
                                              ),
                                              width: 100,
                                              height: 20,
                                            ),
                                          ),
                                          Container(
                                            height: 350,
                                            width: 350,
                                            decoration: BoxDecoration(
                                                color: tarik,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          )
                                        ],
                                      ),
                                      baseColor: tarik,
                                      highlightColor: Colors.grey),
                                );
                              });
                        }
                        var data = snapshot.data as List;
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return HomeItemProject(
                                myAccount: false,
                                id: data[index].id,
                                userId: data[index].userId,
                                date: data[index].date,
                                title: data[index].title,
                                image: data[index].imageUrl,
                                description: data[index].description,
                                price: data[index].price,
                                likes: data[index].likes,
                                comments: data[index].comments,
                                saveList: data[index].saveList,
                                category: data[index].category);
                          },
                          itemCount: data.length,
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
