import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/project_model.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/detial_project_screen.dart';
import 'package:main/screens/my_account.dart';
import 'package:main/screens/user_account.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class SeacrhDelegateWU extends SearchDelegate {
  final List<UserModel> data;

  SeacrhDelegateWU(this.data)
      : super(
          searchFieldLabel: 'Search'.tr(),
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, 'result');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser!.uid;
    final List<UserModel> suggestionsName = data.where((data) {
      return data.tags!
          .any((element) => element.toString().toLowerCase().contains(query));
    }).toList();
    print(suggestionsName);
    return Container(
      //Listviews
      color: tarik,
      child: ListView.builder(
        itemCount: suggestionsName.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (suggestionsName[index].id == userId) {
                Navigator.pushNamed(context, MyAccount.routeName);
              } else {
                Navigator.pushNamed(context, UserAccount.routeName,
                    arguments: suggestionsName[index].id);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Container(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                    color: shiri, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                          backgroundColor: whiteColor,
                          //avatar
                          backgroundImage:
                              suggestionsName[index].avatar != null &&
                                      suggestionsName[index].avatar!.length > 5
                                  ? NetworkImage(suggestionsName[index].avatar!)
                                  : null,
                          child: suggestionsName[index].avatar == null ||
                                  suggestionsName[index].avatar!.length < 5
                              ? Icon(
                                  Icons.person,
                                  color: tarik,
                                )
                              : null),
                      title: Text(
                        //name
                        suggestionsName[index].name!,
                        style: TextStyle(
                            color: tarik, fontFamily: 'rudaw', fontSize: 16),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        //decription
                        suggestionsName[index].email!,

                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'rudaw',
                            fontSize: 14),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: tarik,
                    ),
                    //tags
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestionsName[index].tags!.length,
                          itemBuilder: (context, index1) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  suggestionsName[index].tags![index1],
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontFamily: 'rudaw',
                                      fontSize: 14),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

////////////////////////////////////////////////
  @override
  Widget buildSuggestions(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    final List<UserModel> suggestionsName = data.where((data) {
      return data.tags!
          .any((element) => element.toString().toLowerCase().contains(query));
    }).toList();

    return Container(
      //Listviews
      color: tarik,
      child: ListView.builder(
        itemCount: suggestionsName.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print(suggestionsName[index].id);
              print(userId);
              if (suggestionsName[index].id == userId) {
                Navigator.pushNamed(context, MyAccount.routeName);
              } else {
                Navigator.pushNamed(context, UserAccount.routeName,
                    arguments: suggestionsName[index].id);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Container(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                    color: shiri, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                          backgroundColor: whiteColor,
                          //avatar
                          backgroundImage:
                              suggestionsName[index].avatar != null &&
                                      suggestionsName[index].avatar!.length > 5
                                  ? NetworkImage(suggestionsName[index].avatar!)
                                  : null,
                          child: suggestionsName[index].avatar == null ||
                                  suggestionsName[index].avatar!.length < 5
                              ? Icon(
                                  Icons.person,
                                  color: tarik,
                                )
                              : null),
                      title: Text(
                        //name
                        suggestionsName[index].name!,
                        style: TextStyle(
                            color: tarik, fontFamily: 'rudaw', fontSize: 16),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        //decription
                        suggestionsName[index].email!,

                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'rudaw',
                            fontSize: 14),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: tarik,
                    ),
                    //tags
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestionsName[index].tags!.length,
                          itemBuilder: (context, index1) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  suggestionsName[index].tags![index1],
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontFamily: 'rudaw',
                                      fontSize: 14),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
