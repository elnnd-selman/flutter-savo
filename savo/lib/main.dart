import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main/provider/firebaseAuth.dart';
import 'package:main/screens/add_post.dart';
import 'package:main/screens/chat_room_savo.dart';
import 'package:main/screens/comment_screen.dart';
import 'package:main/screens/detial_project_screen.dart';
import 'package:main/screens/edite_my_profile.dart';
import 'package:main/screens/helper_screen.dart';
import 'package:main/screens/home.dart';
import 'package:main/screens/login_screen.dart';
import 'package:main/screens/map_screen.dart';
import 'package:main/screens/my_account.dart';
import 'package:main/screens/no_internet_screen.dart';
import 'package:main/screens/note_screen.dart';
import 'package:main/screens/savo_save.dart';
import 'package:main/screens/user_account.dart';
import 'package:main/widget/languages.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.notification!.title);
  print(message.notification!.body);
  flutterLocalNotificationsPlugin!.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel!.id,
          channel!.name,
          channel!.description,

          icon: 'launch_background',
        ),
      ));
}

AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('en'),
          Locale('ur'),
          Locale('ar'),
          Locale('de'),
          Locale('fr'),
          Locale('fa'),
          Locale('tr')
        ],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          create: (context) => FireAuth().user,
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'lalavook',
        initialRoute: HelperScreen.routeName,
        routes: {
          HelperScreen.routeName: (context) => HelperScreen(),
          Home.routeName: (context) => Home(),
          AddPostInput.routeName: (context) => AddPostInput(),
          MyAccount.routeName: (context) => MyAccount(),
          LoginScreen.routeName: (context) => LoginScreen(),
          EditeMyProfile.routeName: (context) => EditeMyProfile(),
          ProjectDetialsScreen.routeName: (context) => ProjectDetialsScreen(),
          UserAccount.routeName: (context) => UserAccount(),
          GoogleMapScreen.routeName: (context) => GoogleMapScreen(),
          CommentScreen.routeName: (context) => CommentScreen(),
          SavoChat.routeName: (context) => SavoChat(),
          SavoList.routeName: (context) => SavoList(),
          NoteScreen.routeName: (context) => NoteScreen(),
          NoInternet.routeName: (context) => NoInternet(),
        },
      ),
    );
  }
}
