import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class TextLoginForm extends StatefulWidget {
  final emailController;
  final String? title;
  final icon;
  final confirmPasswordController;
  final confirmPasswordControllerText;
  final Function(String?)? onSaved;
  TextLoginForm({
    Key? key,
    @required this.title,
    this.icon,
    this.onSaved,
    this.confirmPasswordController,
    this.confirmPasswordControllerText,
    this.emailController,
  }) : super(key: key);

  @override
  _TextLoginFormState createState() => _TextLoginFormState();
}

class _TextLoginFormState extends State<TextLoginForm> {
  bool visiblePassword = true;

  @override
  Widget build(BuildContext context) {
    // print(widget.confirmPasswordController.text);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        textAlign: TextAlign.left,
        keyboardType: widget.title == 'Email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        enableSuggestions: true,
        style: TextStyle(color: shiri, fontSize: 14),
        obscureText:
            widget.title == 'Password' || widget.title == 'Confirm password'
                ? visiblePassword
                : false,
        controller: widget.title == 'Email'
            ? widget.emailController
            : widget.confirmPasswordController,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: tarik),
          filled: true,
          fillColor: tarik,
          labelText: '${widget.title}'.tr(),
          labelStyle:
              TextStyle(color: shiri, fontFamily: 'rudaw', fontSize: 14),
          prefixIcon: Icon(widget.icon, color: shiri),
          suffixIcon: widget.title == 'Password' ||
                  widget.title == 'Confirm password'
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      visiblePassword = !visiblePassword;
                    });
                  },
                  icon: Icon(
                    visiblePassword ? Icons.visibility_off : Icons.visibility,
                    color: shiri,
                  ),
                )
              : null,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: thered, width: 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: thered, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: theyellow, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: theyellow, width: .5),
          ),
        ),
        onSaved: widget.onSaved,
        validator: (value) {
          print(value);
          //name
          if (widget.title == 'Name') {
            if (value!.length < 3) {
              return 'Shoud not empty';
            }
            if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(value.toString())) {
              return 'Invalid name'.tr();
            }
            if (!RegExp(r"^[A-Za-z]\w+$").hasMatch(value.toString())) {
              return 'invaled space and symbol'.tr();
            }
          }
          //email
          if (widget.title == 'Email') {
            if (value!.isEmpty) {
              return 'Please enter an email'.tr();
            }
            if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(value.toString()) ||
                value.isEmpty) {
              return 'Invalid email'.tr();
            }
          }
          //password
          if (widget.title == 'Password') {
            if (value!.isEmpty || value.length < 6) {
              return 'Must be more than 6 characters.'.tr();
            }
          }
          if (widget.title == 'Confirm password') {
            if (value!.isEmpty || value.length < 6) {
              return 'Must be more than 6 characters.'.tr();
            }
            if (widget.confirmPasswordControllerText != value) {
              print(widget.confirmPasswordControllerText);
              return 'Not the same password.'.tr();
            }
          }
          print(widget.confirmPasswordControllerText);
          return null;
        },
      ),
    );
  }
}
