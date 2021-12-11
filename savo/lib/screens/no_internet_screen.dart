import 'package:flutter/material.dart';
import 'package:main/color.dart';

class NoInternet extends StatelessWidget {
  static const routeName = "/no-internet";
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(children: [
            Icon(
              Icons.wifi_off,
              size: 40,
              color: tarik,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.replay,
                size: 40,
                color: tarik,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
