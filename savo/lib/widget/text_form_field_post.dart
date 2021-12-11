import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class TextFormFieldPost extends StatelessWidget {
  final String? typePost;
  final String? typeInput;

  final Function(String?)? onSaved;
  final List<TextEditingController>? txtCtrl;
  const TextFormFieldPost(
      {Key? key,
      @required this.typePost,
      @required this.typeInput,
      @required this.txtCtrl,
      @required this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: TextFormField(
        textAlign: TextAlign.right,
        textDirection: ui.TextDirection.rtl,
        cursorColor: blackColor,
        cursorHeight: 20,
        style: TextStyle(color: blackColor, fontSize: 14, fontFamily: "rudaw"),
        decoration: InputDecoration(
          labelText: typeInput == 'title'
              ? typePost == 'question'
                  ? 'Title of your '.tr() + 'typePostQ'.tr()
                  : typePost == 'work'
                      ? 'Title of your '.tr() + 'typePostW'.tr()
                      : typePost == 'project'
                          ? 'Title of your '.tr() + 'typePostP'.tr()
                          : "empty1"
              : typeInput == 'description'
                  ? typePost == 'question'
                      ? 'Description of your '.tr() + 'typePostQ'.tr()
                      : typePost == 'work'
                          ? 'Description of your '.tr() + 'typePostW'.tr()
                          : typePost == 'project'
                              ? 'Description of your '.tr() + 'typePostP'.tr()
                              : "empty2"
                  : typeInput == "price"
                      ? "Price".tr()
                      : "empty",
          labelStyle: TextStyle(
            color: blackColor,
            fontSize: 12,
          ),
          filled: true,
          fillColor: Colors.grey.shade300,
          contentPadding: EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade600,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: thered,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: thered,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixText: typeInput == 'price' ? 'IQD' : null,
          suffixStyle: TextStyle(
            fontFamily: "rudaw",
            fontSize: 14,
          ),
          prefixIcon: Icon(
            typeInput == 'title'
                ? Icons.title
                : typeInput == 'description'
                    ? Icons.description
                    : typeInput == 'price'
                        ? Icons.money
                        : Icons.circle,
            color: shiri,
          ),
          errorMaxLines: 2,
          errorStyle: TextStyle(
            color: thered,
            fontSize: 10,
          ),
        ),
        minLines: typeInput == 'description' ? 3 : 1,
        maxLines: 50,
        toolbarOptions:
            ToolbarOptions(paste: true, selectAll: true, copy: true, cut: true),
        onSaved: onSaved,
        keyboardType: typeInput == 'price'
            ? TextInputType.number
            : typeInput == 'description'
                ? TextInputType.multiline
                : TextInputType.text,
        textInputAction: typeInput != 'description'
            ? TextInputAction.next
            : TextInputAction.none,
        validator: (value) {
          if (typeInput == 'title') {
            if (value!.length > 30 || value.length < 3) {
              return 'must be between 3-30 charecter'.tr();
            }
          }
          if (typeInput == 'description') {
            if (value!.length < 20 || value.length > 500 || value.isEmpty) {
              return 'letter description length must be between 20-500'.tr();
            }
          }
          if (typeInput == 'price') {
            if (value!.isEmpty) {
              return 'fill price please should not empty, or unselect check sale'
                  .tr();
            }
            if (value.length > 10) {
              return 'Its too much , please be kind'.tr();
            }
          }

          return null;
        },
        controller: txtCtrl![typeInput == 'title'
            ? 0
            : typeInput == 'description'
                ? 1
                : typeInput == 'price'
                    ? 2
                    : 100],
      ),
    );
  }
}
