import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/user_account.dart';
import 'package:main/widget/utils-map-style.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import '../color.dart';

class GoogleMapScreen extends StatefulWidget {
  static const routeName = '/map-savo';
  GoogleMapScreen({Key? key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _myMapController;
  PageController? _pageController;
  Set<Marker> _markers = {};
  List<UserModel> _users = [];
  bool _showPageViews = false;
  bool _pageViewsFirstJump = false;
  void mapCreated(GoogleMapController controller) {
    controller.setMapStyle(UtilMapStyle.mapStyle);
    setState(() {
      _myMapController = controller;
      _showPageViews = true;
    });
  }

  Future<Uint8List?> getMarkerIcon({String? url, int? markerSize}) async {
    try {
      File markerImageFile = await DefaultCacheManager().getSingleFile(url!);
      Uint8List markerImageByte = await markerImageFile.readAsBytes();
      ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        markerImageByte,
        targetWidth: markerSize,
        targetHeight: markerSize,
      );
      ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      ByteData? byteData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
      return resizedMarkerImageBytes;
    } catch (e) {
      return null;
    }
  }

  //addUserToListMarkers
  void _addUserToListMarkers() async {
    var users = await FireStore().getAllUserFromFirestore();

    int index = 0;
    for (var i = 0; i < users!.length; i++) {
      if (users[i].location!.values.toList()[0].length > 3 &&
          users[i].location!.values.toList()[1].length > 3) {
        setState(() {
          _users.add(users[i]);
        });
        String? _avatar = await users[i].avatar;
        Uint8List? _image = await getMarkerIcon(url: _avatar, markerSize: 100);
        BitmapDescriptor mapMarker = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/marker.png');
        setState(() {
          _markers.add(
            Marker(
              onTap: () {
                _pageController!.jumpToPage(i);

                index++;
              },
              icon: _image != null
                  ? BitmapDescriptor.fromBytes(_image)
                  : mapMarker,
              markerId: MarkerId(users[i].email!),
              position: LatLng(
                double.parse(users[i].location!['lat']),
                double.parse(users[i].location!['long']),
              ),
              draggable: false,
              infoWindow: InfoWindow(
                title: 'Hey!'.tr(),
                snippet: "I'm".tr() + " ${users[i].name}",
              ),
            ),
          );
        });
      }
    }
    setState(() {
      _pageViewsFirstJump = true;
    });
  }

  @override
  void initState() {
    _addUserToListMarkers();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: .92,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: FireStore().getMyInfoFormFirestore(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: tarik,
              ),
            );
          }
          //Has data
          UserModel data = snapshot.data as UserModel;
          int _index;
          if (_pageViewsFirstJump) {
            print(_users.length);
            _users.forEach((element) {
              print(element.id);
              print(data.id);
              if (element.id == data.id!) {
                if (_users.contains(element)) {
                  _index = _users.indexOf(element);
                  print(_index);
                  if (_showPageViews) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      _pageController!.jumpToPage(_index);
                    });
                  }
                }
              }
            });
          }

          var lat = 33.2232;
          var long = 43.6793;
          if (data.location!.values.toList()[0].length > 3 &&
              data.location!.values.toList()[1].length > 3) {
            lat = double.parse(data.location!['lat']);
            long = double.parse(data.location!['long']);
          }
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                //Google map
                child: GoogleMap(
                  liteModeEnabled: false,
                  compassEnabled: true,
                  buildingsEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  trafficEnabled: false,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, long),

                    // target: LatLng(36.1901, 43.9930),
                    zoom: 5.0,
                  ),
                  mapType: MapType.normal,
                  onMapCreated: mapCreated,
                ),
              ),
              _showPageViews
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 50),
                        height: 150,
                        width: double.infinity,
                        //page Views
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _users.length,
                          onPageChanged: (value) {
                            // Future.delayed(
                            //   Duration(milliseconds: 200),
                            //   () {
                            _myMapController!.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  bearing: 10,
                                  zoom: 15,
                                  tilt: 10,
                                  target: LatLng(
                                    double.parse(
                                        _users[value].location!['lat']),
                                    double.parse(
                                        _users[value].location!['long']),
                                  ),
                                ),
                              ),
                              //   );
                              // },
                            );
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, UserAccount.routeName,
                                            arguments: _users[index].id);
                                      },
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: tarik,
                                        backgroundImage: _users[index].avatar !=
                                                    null &&
                                                _users[index].avatar!.length > 1
                                            ? NetworkImage(
                                                _users[index].avatar!)
                                            : null,
                                        child: _users[index].avatar == null ||
                                                _users[index].avatar!.length < 1
                                            ? Icon(
                                                Icons.person,
                                                color: whiteColor,
                                              )
                                            : null,
                                      ),
                                    ),
                                    Container(
                                      width: 3,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: tarik,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 100,
                                        width: 200,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  _users[index].name!,
                                                  style: TextStyle(
                                                    color: tarik,
                                                    fontFamily: 'rudaw',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textDirection: RegExp(
                                                                  r"^[\u0600-\u06FF\s]+$")
                                                              .hasMatch(_users[
                                                                      index]
                                                                  .experience!) ||
                                                          RegExp(r"^[\u0621-\u064A]+$")
                                                              .hasMatch(_users[
                                                                      index]
                                                                  .experience!)
                                                      ? ui.TextDirection.rtl
                                                      : ui.TextDirection.ltr,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                _users[index].experience!,
                                                textDirection: RegExp(
                                                                r"^[\u0600-\u06FF\s]+$")
                                                            .hasMatch(_users[
                                                                    index]
                                                                .experience!) ||
                                                        RegExp(r"^[\u0621-\u064A]+$")
                                                            .hasMatch(_users[
                                                                    index]
                                                                .experience!)
                                                    ? ui.TextDirection.rtl
                                                    : ui.TextDirection.ltr,
                                                style: TextStyle(
                                                    fontFamily: 'rudaw',
                                                    fontSize: 14,
                                                    color: tarik),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
