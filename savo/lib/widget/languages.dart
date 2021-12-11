// import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Languages extends StatelessWidget {
//   final title;
//   final size;
//   final w;
//   final f;
//   final color;
//   Languages({
//     required this.title,
//     this.size,
//     this.w,
//     this.color,
//     this.f,
//   });

//   Future<String?> lan() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? lan = prefs.getString('language');
//     return lan;
//   }

//   String? label({title}) {
//     print('1');
//     var txt = '';
//     if (lan() == 'en') {
//       if (title == 'Email') {
//         txt = 'Email';
//       } else if (title == 'Please Verifye Your Email.') {
//         txt = 'Please Verifye Your Email.';
//       } else if (title == 'Save to the SAVO') {
//         txt = 'Save to the SAVO';
//       } else if (title == 'more') {
//         txt = 'more';
//       } else if (title == 'less ...') {
//         txt = 'less ...';
//       } else {
//         txt = title;
//       }
//     }
//     if (lan() == 'krd') {
//       if (title == 'Email') {
//         txt = 'ئیمەیڵ';
//       } else if (title == 'Please Verifye Your Email.') {
//         txt = 'تکایە ئیمەیڵەکەت پشت ڕاست بکەوە';
//       } else if (title == 'Save to the SAVO') {
//         txt = 'لە ساڤۆ هەڵگیرا';
//       } else if (title == 'more') {
//         txt = 'زیاتر';
//       } else if (title == 'less ...') {
//         txt = 'کەمتر...';
//       } else {
//         txt = title;
//       }
//     }

//     return txt;
//   }

// ///////////////////////////////////////////////////////////////////////////////
//   @override
//   Widget build(BuildContext context) {
//     print('2');
//     String txt = '';
//     TextAlign textAlign = TextAlign.left;
//     //english
//     if (lan() == 'en') {
//       if (title == 'question') {
//         txt = 'question';
//       } else if (title == 'work') {
//         txt = 'work';
//       } else if (title == 'project') {
//         txt = 'project';
//       } else if (title.toString().contains('likes')) {
//         var txt1 = title.toString().split('likes')[0];
//         txt = '$txt1 likes';
//       } else if (title.toString().contains('View the comment')) {
//         var txt1 = title.toString().split('comment')[1];
//         txt = 'View the comment $txt1 ';
//       } else if (title.toString().contains('View all comments')) {
//         var txt1 = title.toString().split('comments')[1];
//         txt = 'View all comments $txt1 ';
//       } else if (title == 'Theme') {
//         txt = 'Theme';
//       } else if (title == 'Show location') {
//         txt = 'Show location';
//       } else if (title == 'Languages') {
//         txt = 'Languages';
//       } else if (title == 'Log out') {
//         txt = 'Log out';
//       } else {
//         txt = title;
//       }
//     }
//     //kurdish
//     if (lan() == 'krd') {
//       if (title == 'question') {
//         txt = 'پرسیار';
//       } else if (title == 'work') {
//         txt = 'کار';
//       } else if (title == 'project') {
//         txt = 'پرۆژە';
//       } else if (title.toString().contains('likes')) {
//         var txt1 = title.toString().split('likes')[0];
//         txt = 'لایک $txt1';
//       } else if (title.toString().contains('View the comment')) {
//         var txt1 = title.toString().split('comment')[1];
//         txt = 'کۆمێنتەکە ببینە $txt1';
//       } else if (title.toString().contains('View all comments')) {
//         var txt1 = title.toString().split('comments')[1];
//         txt = 'کۆمێنتەکان ببینە $txt1';
//       } else if (title == 'Theme') {
//         txt = 'شێواز';
//       } else if (title == 'Show location') {
//         txt = 'شوێنەکەت دیاری بکە';
//       } else if (title == 'Languages') {
//         txt = 'زمان';
//       } else if (title == 'Log out') {
//         txt = 'چوونە دەر';
//       } else {
//         txt = title;
//       }
//     }

//     if (RegExp(r"^[\u0600-\u06FF\s]+$").hasMatch(txt) ||
//         RegExp(r"^[\u0621-\u064A]+$").hasMatch(txt)         ) {
//       TextAlign textAlign = TextAlign.right;
//     }

//     ////
//     return Text(
//       txt,
//       style: TextStyle(
//         fontFamily: f != null ? 'Ar' : f,
//         fontWeight: w != null ? w : null,
//         fontSize: size,
//         color: color,
//       ),
//       textAlign: textAlign,
//     );
//   }
// }
