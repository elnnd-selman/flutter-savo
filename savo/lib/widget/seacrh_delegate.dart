import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/color.dart';
import 'package:main/models/project_model.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/detial_project_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

@override
String get searchFieldLabel => 'custom label';

class SeacrhDelegateW extends SearchDelegate {
  final List<ProjectModel>? data;

  SeacrhDelegateW(this.data)
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
    final List<ProjectModel> suggestionsName = data!.where((data) {
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
          return FutureBuilder(
              //FutureBuilder
              future: FireStore()
                  .getUserByIdFromFirestore(suggestionsName[index].userId!),
              builder: (context, snapshot) {
                //shimmer
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                      enabled: true,
                      period: Duration(milliseconds: 800),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              ListTile(
                                  leading: CircleAvatar(
                                    //avatar
                                    backgroundColor: tarik,
                                  ),
                                  title: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: tarik,
                                    ),
                                    width: 30,
                                    height: 10,
                                  ),
                                  isThreeLine: true,
                                  subtitle: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: tarik,
                                    ),
                                  )),

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
                                    itemCount: 10,
                                    itemBuilder: (context, index1) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Center(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: tarik,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          width: 30,
                                          height: 10,
                                        )),
                                      );
                                    }),
                              ),
                              Divider(
                                height: 1,
                                color: tarik,
                              ),
                            ],
                          ),
                        ),
                      ),
                      baseColor: tarik,
                      highlightColor: Colors.grey);
                }

                //Has data
                UserModel data = snapshot.data as UserModel;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                    decoration: BoxDecoration(
                        color: shiri, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            //avatar
                            backgroundImage: NetworkImage(data.avatar!),
                          ),
                          title: Text(
                            //name
                            data.name!,
                            style: TextStyle(
                                color: tarik,
                                fontFamily: 'rudaw',
                                fontSize: 16),
                          ),
                          isThreeLine: true,
                          subtitle: Text(
                            //decription
                            suggestionsName[index].description!,
                            textDirection: RegExp(r"^[\u0600-\u06FF\s]+$")
                                        .hasMatch(suggestionsName[index]
                                            .description!) ||
                                    RegExp(r"^[\u0621-\u064A]+$").hasMatch(
                                        suggestionsName[index].description!)
                                ? ui.TextDirection.rtl
                                : ui.TextDirection.ltr,
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
                );
              });
        },
      ),
    );
  }

////////////////////////////////////////////////
  @override
  Widget buildSuggestions(BuildContext context) {
    final List<ProjectModel> suggestionsName = data!.where((data) {
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
          return FutureBuilder(
              //FutureBuilder
              future: FireStore()
                  .getUserByIdFromFirestore(suggestionsName[index].userId!),
              builder: (context, snapshot) {
                //shimmer
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                      enabled: true,
                      period: Duration(milliseconds: 800),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              ListTile(
                                  leading: CircleAvatar(
                                    //avatar
                                    backgroundColor: tarik,
                                  ),
                                  title: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: tarik,
                                    ),
                                    width: 30,
                                    height: 10,
                                  ),
                                  isThreeLine: true,
                                  subtitle: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: tarik,
                                    ),
                                  )),

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
                                    itemCount: 10,
                                    itemBuilder: (context, index1) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Center(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: tarik,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          width: 30,
                                          height: 10,
                                        )),
                                      );
                                    }),
                              ),
                              Divider(
                                height: 1,
                                color: tarik,
                              ),
                            ],
                          ),
                        ),
                      ),
                      baseColor: tarik,
                      highlightColor: Colors.grey);
                }
                ////has data
                UserModel data = snapshot.data as UserModel;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetialsScreen(
                            image: suggestionsName[index].imageUrl,
                            likes: suggestionsName[index].likes,
                            price: suggestionsName[index].price,
                            saveList: suggestionsName[index].saveList,
                            userId: suggestionsName[index].userId,
                            id: suggestionsName[index].id,
                            date: suggestionsName[index].date,
                            title: suggestionsName[index].title,
                            description: suggestionsName[index].description,
                            category: suggestionsName[index].category,
                            comments: suggestionsName[index].comments),
                      ),
                    );

                    // Navigator.pushNamed(context, ProjectDetialsScreen.routeName,
                    //     arguments:
                    // ProjectModel(
                    //         likes: suggestionsName[index].likes,
                    //         price: suggestionsName[index].price,
                    //         saveList: suggestionsName[index].saveList,
                    //         userId: suggestionsName[index].userId,
                    //         id: suggestionsName[index].id,
                    //         tags: suggestionsName[index].tags,
                    //         date: suggestionsName[index].date,
                    //         title: suggestionsName[index].title,
                    //         description: suggestionsName[index].description,
                    //         imageUrl: suggestionsName[index].imageUrl,
                    //         category: suggestionsName[index].category,
                    //         comments: suggestionsName[index].comments)
                    // );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: shiri,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              //avatar
                              backgroundImage: NetworkImage(data.avatar!),
                            ),
                            title: Text(
                              //name
                              data.name!,
                              style: TextStyle(
                                  color: tarik,
                                  fontFamily: 'rudaw',
                                  fontSize: 16),
                            ),
                            isThreeLine: true,
                            subtitle: Text(
                              //decription
                              suggestionsName[index].description!,
                              textDirection: RegExp(r"^[\u0600-\u06FF\s]+$")
                                          .hasMatch(suggestionsName[index]
                                              .description!) ||
                                      RegExp(r"^[\u0621-\u064A]+$").hasMatch(
                                          suggestionsName[index].description!)
                                  ? ui.TextDirection.rtl
                                  : ui.TextDirection.ltr,
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
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
              });
        },
      ),
    );
  }
}
