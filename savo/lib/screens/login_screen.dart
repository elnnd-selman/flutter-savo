import 'package:achievement_view/achievement_view.dart';
import 'package:animated_button/animated_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/login_info_model.dart';
import 'package:main/provider/firebaseAuth.dart';
import 'package:main/screens/home.dart';
import 'package:main/screens/my_account.dart';
import 'package:main/screens/no_internet_screen.dart';
import 'package:main/widget/text_login_form.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formLogin = GlobalKey();
  bool login = true;
  LoginInfo _loginInfo = LoginInfo(name: '', email: '', password: '');
  bool visiblePassword = true;
  bool load = false;
  bool _onesResetPasswordRequest = true;
  final confirmPasswordController = TextEditingController();
  final email = TextEditingController();

  // void checkInternet() async {
  //   ConnectivityResult result = await Connectivity().checkConnectivity();
  //   print(
  //       'r----------------------------------------------------------------esult');
  //   print(result);
  //   print(
  //       'r----------------------------------------------------------------esult');
  //   if (result == ConnectivityResult.none) {
  //     Future.delayed(Duration.zero, () {
  //       Navigator.pushNamed(context, NoInternet.routeName);
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   checkInternet();
  // }

  @override
  void dispose() {
    confirmPasswordController.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dropdownValue = 'select language';

    if (context.locale.toString().length > 0) {
      setState(
        () {
          dropdownValue = context.locale.toString() == 'en'
              ? 'English'
              : context.locale.toString() == 'ur'
                  ? 'کوردی'
                  : context.locale.toString() == 'fr'
                      ? 'French'
                      : context.locale.toString() == 'de'
                          ? 'German'
                          : context.locale.toString() == 'fa'
                              ? 'فارسی'
                              : context.locale.toString() == 'tr'
                                  ? "Turkish"
                                  : context.locale.toString() == 'ar'
                                      ? 'عربي'
                                      : 'select language';
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(
                  Icons.arrow_downward,
                  color: tarik,
                  size: 12,
                ),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: greyShadeColor),
                underline: Container(
                  height: 1,
                  color: tarik,
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
                    if (newValue == 'French') {
                      context.setLocale(Locale('fr'));
                    }
                    if (newValue == 'German') {
                      context.setLocale(Locale('de'));
                    }
                    if (newValue == 'فارسی') {
                      context.setLocale(Locale('fa'));
                    }
                    if (newValue == 'Turkish') {
                      context.setLocale(Locale('tr'));
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
                  'German',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/images/Savo.png'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formLogin,
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      !login
                          ? TextLoginForm(
                              title: 'Name',
                              icon: Icons.person,
                              onSaved: (value) {
                                setState(() {
                                  _loginInfo = LoginInfo(
                                      name: value,
                                      email: _loginInfo.email,
                                      password: _loginInfo.password);
                                });
                              },
                            )
                          : SizedBox(),
                      TextLoginForm(
                        emailController: email,
                        title: 'Email',
                        icon: Icons.email,
                        onSaved: (value) {
                          setState(() {
                            _loginInfo = LoginInfo(
                                name: _loginInfo.name,
                                email: value,
                                password: _loginInfo.password);
                          });
                        },
                      ),
                      TextLoginForm(
                        title: 'Password',
                        confirmPasswordController: confirmPasswordController,
                        icon: Icons.security,
                        onSaved: (value) {
                          setState(() {
                            _loginInfo = LoginInfo(
                                name: _loginInfo.name,
                                email: _loginInfo.email,
                                password: value);
                          });
                        },
                      ),
                      !login
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                style: TextStyle(color: shiri),
                                obscureText: visiblePassword,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: tarik,
                                  labelText: 'Confirm password'.tr(),
                                  labelStyle: TextStyle(
                                      color: shiri,
                                      fontFamily: 'rudaw',
                                      fontSize: 14),
                                  prefixIcon:
                                      Icon(Icons.security, color: shiri),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        visiblePassword = !visiblePassword;
                                      });
                                    },
                                    icon: Icon(
                                      visiblePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: shiri,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: thered, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: thered, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: theyellow, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: theyellow, width: .5),
                                  ),
                                ),
                                validator: (value) {
                                  if (confirmPasswordController.text != value) {
                                    return 'Password not much'.tr();
                                  }

                                  return null;
                                },
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 1, left: 20, right: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), color: thered),
                    child: Center(
                      child: AnimatedButton(
                        width: 330,
                        color: Colors.transparent,
                        duration: 10,
                        onPressed: load
                            ? () {}
                            : () async {
                                if (_formLogin.currentState!.validate()) {
                                  _formLogin.currentState!.save();
                                  if (!login) {
                                    try {
                                      setState(() {
                                        load = true;
                                      });
                                      await FireAuth().signIn(
                                          name: _loginInfo.name,
                                          email: _loginInfo.email,
                                          password: _loginInfo.password);
                                      setState(() {
                                        load = false;
                                      });
                                      User? user =
                                          FirebaseAuth.instance.currentUser;

                                      Navigator.pushReplacementNamed(
                                          context, Home.routeName);
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        load = false;
                                      });
                                      if (e.code == 'weak-password') {
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
                                              'The password provided is too weak.'
                                                  .tr(),
                                          textStyleSubTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                          textStyleTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                        )..show();
                                      } else if (e.code ==
                                          'email-already-in-use') {
                                        AchievementView(
                                          context,
                                          alignment: Alignment.topCenter,
                                          elevation: 0,
                                          color: Colors.red,
                                          borderRadius: 25,
                                          icon: Icon(
                                            Icons.error_outline,
                                            color: spi,
                                            size: 30,
                                          ),
                                          title: 'Error'.tr(),
                                          subTitle:
                                              'The account already exists for that email.'
                                                  .tr(),
                                          textStyleSubTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                          textStyleTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                        )..show();
                                      } else {
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
                                              'Check All input please.'.tr(),
                                          textStyleSubTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                          textStyleTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                        )..show();
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  } else {
                                    try {
                                      setState(() {
                                        load = true;
                                      });
                                      await FireAuth()
                                          .logIn(
                                              email: _loginInfo.email,
                                              password: _loginInfo.password)!
                                          .then((value) {
                                        setState(() {
                                          load = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, Home.routeName);
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        load = false;
                                      });
                                      if (e.code == 'user-not-found') {
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
                                          title: 'Error email'.tr(),
                                          subTitle:
                                              'No user found for that email.'
                                                  .tr(),
                                          textStyleSubTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                          textStyleTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                        )..show();
                                      } else if (e.code == 'wrong-password') {
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
                                          title: 'Wrong password'.tr(),
                                          subTitle:
                                              'Please enter correct password.'
                                                  .tr(),
                                          textStyleSubTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                          textStyleTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                        )..show();
                                      } else {
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
                                              'Check All input please.'.tr(),
                                          textStyleSubTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                          textStyleTitle: TextStyle(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontFamily: 'rudaw',
                                          ),
                                        )..show();
                                      }
                                    }
                                  }
                                }
                              },
                        child: load
                            ? CircularProgressIndicator(
                                color: tarik,
                              )
                            : Text(
                                login ? 'Sign in'.tr() : 'Sign up'.tr(),
                                style: TextStyle(
                                    color: shiri,
                                    fontFamily: 'rudaw',
                                    fontSize: 14),
                              ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: tarik,
                        fontSize: 14,
                        fontFamily: 'rudaw',
                      ),
                      children: [
                        TextSpan(
                          text: login
                              ? 'I have not account?'.tr()
                              : 'I already have account'.tr(),
                        ),
                        TextSpan(
                          text: login ? 'Sign up'.tr() : 'Sign in'.tr(),
                          style: TextStyle(
                            color: thered,
                            fontSize: 14,
                            fontFamily: 'rudaw',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                login
                    ? TextButton(
                        onPressed: () async {
                          if (email.text.length > 6 &&
                              RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(email.text.toString())) {
                            if (_onesResetPasswordRequest) {
                              print(
                                  'must one titm////////////////////////////////////////////');
                              setState(() {
                                _onesResetPasswordRequest = false;
                              });
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text)
                                  .catchError((err) {
                                print(err);
                              });
                              AchievementView(
                                context,
                                alignment: Alignment.topCenter,
                                elevation: 0,
                                color: Colors.green,
                                borderRadius: 25,
                                icon: Icon(
                                  Icons.check,
                                  color: spi,
                                  size: 30,
                                ),
                                title: 'Check email'.tr(),
                                subTitle:
                                    'We send you email reset password link please check your email.'
                                        .tr(),
                                textStyleSubTitle: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontFamily: 'rudaw',
                                ),
                                textStyleTitle: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontFamily: 'rudaw',
                                ),
                              )..show();
                              Future.delayed(Duration(minutes: 5), () {
                                setState(() {
                                  _onesResetPasswordRequest = true;
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
                                    'We send you email reset passwrod link pleas check your email. You cant send any resset passwrod request until 5 minute'
                                        .tr(),
                                textStyleSubTitle: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontFamily: 'rudaw',
                                ),
                                textStyleTitle: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontFamily: 'rudaw',
                                ),
                              )..show();
                            }
                          } else {
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
                              title: 'Error email'.tr(),
                              subTitle: 'please enter email.'.tr(),
                              textStyleSubTitle: TextStyle(
                                color: whiteColor,
                                fontSize: 14,
                                fontFamily: 'rudaw',
                              ),
                              textStyleTitle: TextStyle(
                                color: whiteColor,
                                fontSize: 14,
                                fontFamily: 'rudaw',
                              ),
                            )..show();
                          }
                        },
                        child: Text(
                          'Forget password?'.tr(),
                          style: TextStyle(
                            color: tarik,
                            fontSize: 14,
                            fontFamily: 'rudaw',
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
