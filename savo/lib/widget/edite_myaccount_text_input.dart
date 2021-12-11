import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class EditeProfileTextInput extends StatelessWidget {
  final Function(String?)? onSaved;
  final TextEditingController? controller;
  final String? title;
  const EditeProfileTextInput(
      {Key? key, this.onSaved, this.title, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(title);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        cursorColor: blackColor,
        style: TextStyle(color: blackColor, fontSize: 14, fontFamily: "rudaw"),
        decoration: InputDecoration(
          labelText: title,
          labelStyle:
              TextStyle(color: blackColor, fontSize: 12, fontFamily: "rudaw"),
          contentPadding: EdgeInsets.all(20),
          enabledBorder: title == 'Value'.tr() || title == 'Key'.tr()
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                      color: tarik, width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(20),
                ),
          focusedBorder: title == 'Value'.tr() || title == 'Key'.tr()
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: tarik),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                      color: tarik, width: 3, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(20),
                ),
          errorBorder: title == 'Value'.tr() || title == 'Key'.tr()
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: thered),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                      color: thered, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(10),
                ),
          focusedErrorBorder: title == 'Value'.tr() || title == 'Key'.tr()
              ? null
              : OutlineInputBorder(
                  borderSide: BorderSide(
                      color: thered, width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(10),
                ),
          prefixIcon: Icon(
            title == 'Name'.tr()
                ? Icons.person
                : title == 'Email'.tr()
                    ? Icons.email
                    : title == 'Write your experiece'.tr()
                        ? Icons.receipt_long
                        : title == 'Key'.tr() || title == 'Value'.tr()
                            ? null
                            : Icons.circle,
            color: tarik,
          ),
          errorMaxLines: 5,
          errorStyle:
              TextStyle(color: thered, fontSize: 10, fontFamily: "rudaw"),
        ),
        minLines: title == 'Write your experiece' ? 3 : 1,
        maxLines: 5,
        maxLength: title == 'Value'.tr() ? 3 : null,
        onSaved: onSaved,
        controller: controller,
        keyboardType: title == 'Value'.tr()
            ? TextInputType.number
            : title == 'Email'.tr()
                ? TextInputType.emailAddress
                : title == 'Write your experiece'.tr()
                    ? TextInputType.multiline
                    : TextInputType.text,
        validator: (value) {
          if (title == 'Name'.tr()) {
            if (value!.isEmpty) {
              return 'Enter a name please'.tr();
            }
            if (value.length < 3 || value.length > 30) {
              return 'Name length must be between 3 - 30 cahrecter'.tr();
            }
            if (!RegExp(r"^[A-Za-z]\w+$").hasMatch(value.toString())) {
              return 'invaled space and symbol'.tr();
            }
          }

          if (title == 'Email'.tr()) {
            if (value!.isEmpty) {
              return 'Please enter an email'.tr();
            }
            if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(value.toString()) ||
                value.isEmpty) {
              return 'Invaled email'.tr();
            }
          }

          if (title == 'Write your experiece'.tr() ||
              title == 'Write languages you know'.tr()) {
            if (value!.isEmpty) {
              return 'Enter the description for your post'.tr();
            }
            if (value.length < 30) {
              return 'Must be More than 30 characters'.tr();
            }
          }
          if (title == 'Key'.tr()) {
            if (value!.isEmpty) {
              return 'Please enter key , Ex( Adobe Photoshop )'.tr();
            }
            if (value.length < 3 || value.length > 20) {
              return 'Key length must be between 3 - 30 characters'.tr();
            }
          }
          if (title == 'Value'.tr()) {
            if (!RegExp(r"^[0-9]").hasMatch(value!)) {
              return 'Enter Number'.tr();
            }
            if (value.isEmpty) {
              return 'Enter value'.tr();
            }
            if (double.parse(value) < 1 || double.parse(value) > 100) {
              return 'Value, must be between 1 - 100 characters'.tr();
            }
          }
          return null;
        },
      ),
    );
  }
}
