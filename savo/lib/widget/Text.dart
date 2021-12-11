import 'package:flutter/material.dart';

class TextWd extends StatelessWidget {
  final String? title;
  final Color? color;
  final double? fSize;
// final Size

  const TextWd(
      {Key? key,
      @required this.title,
      @required this.color,
      @required this.fSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      style: TextStyle(color: color, fontSize: fSize),
    );
  }
}
