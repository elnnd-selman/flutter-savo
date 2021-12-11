import 'package:achievement_view/achievement_view.dart';
import 'package:fa_stepper/fa_stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:main/color.dart';
import 'package:main/models/user_model.dart';
import 'package:main/provider/firebaseAuth.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/my_account.dart';
import 'package:main/widget/edite_myaccount_text_input.dart';
import 'package:main/widget/selecting_city_edite_profile.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

List<GlobalKey<FormState>> _forms = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
];
GlobalKey<FormState> _expenriesListForm = GlobalKey<FormState>();
GlobalKey<FormState> _languagesListForm = GlobalKey<FormState>();
enum SingingCharacter { Female, Male, Other }

class EditeMyProfile extends StatefulWidget {
  static const routeName = 'edite-profile';
  EditeMyProfile({Key? key}) : super(key: key);

  @override
  _EditeMyProfileState createState() => _EditeMyProfileState();
}

class _EditeMyProfileState extends State<EditeMyProfile> {
  final GlobalKey<TagsState> _tagskey = GlobalKey<TagsState>();
  List _tags = [];
  bool _loadUpload = false;
  int _currentStep = 0;
  File? file;
  SingingCharacter? _character;
  UserModel? userInfoForUpdate;
  Map _experience = {};
  Map _languages = {};
  bool? _addLanguages = false;
  bool? _addExperience = false;
  bool? continueClick = false;
  bool? cancelClick = false;
  UserModel? _userData;
  List<TextEditingController> _controllers = [
    TextEditingController(), //0name
    TextEditingController(), //1email
    TextEditingController(), //2expe text
    TextEditingController(), //3ex key
    TextEditingController(), //4ex value
    TextEditingController(), //5langug text
    TextEditingController(), //6lang key
    TextEditingController(), //7lang value
    TextEditingController(), //8 location Lat
    TextEditingController(), //9 location long
  ];
  void _setListExperience() async {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel? data = await FireStore().getUserByIdFromFirestore(user!.uid);
    _experience = data!.listOfExperiences as Map;
  }

  void _setListLanguages() async {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel? data = await FireStore().getUserByIdFromFirestore(user!.uid);
    _languages = data!.ListOfLanguages as Map;
  }

  void _toFireStore(UserModel userData) async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _loadUpload = true;
    });
    FireAuth().updateMyProfile(user!.uid, userData, file)!.then((value) {
      print('Update my profile');
      setState(() {
        _loadUpload = false;
      });
      Navigator.pushReplacementNamed(context, MyAccount.routeName);
    });
  }

  void _getUserDataFirst() async {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel? data = await FireStore().getUserByIdFromFirestore(user!.uid);
    _userData = await UserModel(
        rating: data!.rating,
        id: data.id,
        language: data.language,
        email: data.email,
        name: data.name,
        ListOfLanguages: data.ListOfLanguages,
        avatar: data.avatar,
        date: data.date,
        experience: data.experience,
        gender: data.gender,
        listOfExperiences: data.listOfExperiences,
        location: data.location,
        tags: data.tags,
        token: data.token);
    _experience = data.listOfExperiences as Map;
    _languages = data.ListOfLanguages as Map;
    // _selectCity = data.location!;
    _controllers[0].text = data.name!;
    _controllers[1].text = data.email!;
    _controllers[2].text = data.experience!;
    _controllers[5].text = data.language!;
    _controllers[8].text = data.location!['lat'];
    _controllers[9].text = data.location!['long'];
    _tags = data.tags!;
    setState(() {
      if (_userData!.gender == 'Male') {
        _character = SingingCharacter.Male;
      }
      if (_userData!.gender == 'Female') {
        _character = SingingCharacter.Female;
      }
      if (_userData!.gender == 'Other') {
        _character = SingingCharacter.Other;
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    final LocationData? locData = await Location().getLocation();
    if (locData != null) {
      _controllers[8].text = locData.latitude.toString();
      _controllers[9].text = locData.longitude.toString();
      setState(() {});
    }
  }

  @override
  void initState() {
    _getUserDataFirst();
    // _setListExperience();
    // _setListLanguages();
    super.initState();
  }

  @override
  void dispose() {
    _controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // void selectCategoryFun(value) {
    //   setState(() {
    //     _userData = UserModel(
    //       language: _userData!.language,
    //       email: _userData!.email,
    //       name: _userData!.name,
    //       ListOfLanguages: _userData!.ListOfLanguages,
    //       avatar: _userData!.avatar,
    //       date: _userData!.date,
    //       experience: _userData!.experience,
    //       gender: _userData!.gender,
    //       listOfExperiences: _userData!.listOfExperiences,
    //       location: {},
    //       tags: _userData!.tags,
    //     );
    //   });
    // }

    void _addedToListExperience() {
      setState(() {
        _experience[_controllers[3].text] = _controllers[4].text;
      });
      _controllers[3].text = '';
      _controllers[4].text = '';
    }

    void _addedToListLanguages() {
      setState(() {
        _languages[_controllers[6].text] = _controllers[7].text;
      });
      _controllers[6].text = '';
      _controllers[7].text = '';
    }

    // void _selectingImage() async {
    //   final imagePicker = ImagePicker();
    //   XFile? imageFile =
    //       await imagePicker.pickImage(source: ImageSource.gallery);

    //   setState(() {
    //     file = File(imageFile!.path);
    //   });
    // }

    void _selectingImage() async {
      final _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return null;
      }
      File? cropedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 350,
          maxWidth: 350,
          cropStyle: CropStyle.circle,
          compressFormat: ImageCompressFormat.png,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop'.tr(),
              toolbarColor: tarik,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
              cropFrameColor: thered,
              activeControlsWidgetColor: thered,
              statusBarColor: tarik,
              cropGridStrokeWidth: 2
              // cropGridColor: thered,
              ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      setState(() {
        file = cropedImage!;
      });
    }

//////List steps
    List<FAStep> _myStep = [
      ////first step
      FAStep(
        title: Text(
          'Profile'.tr(),
          style:
              TextStyle(color: blackColor, fontSize: 12, fontFamily: "rudaw"),
        ),
        isActive: true,
        state: FAStepstate.indexed,
        content: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: whiteColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              //avatar
              _userData != null &&
                      _userData!.avatar != null &&
                      _userData!.avatar!.length > 5
                  ? CircleAvatar(
                      backgroundColor: thered,
                      radius: 40,
                      child: _userData!.avatar != null &&
                              _userData!.avatar!.length > 5
                          ? null
                          : Icon(Icons.image, color: tarik),
                      backgroundImage: _userData!.avatar != null &&
                              _userData!.avatar!.length > 5
                          ? NetworkImage(_userData!.avatar!)
                          : null,
                    )
                  : CircleAvatar(
                      backgroundColor: tarik,
                      radius: 40,
                      child: file != null
                          ? null
                          : Icon(Icons.image, color: whiteColor),
                      backgroundImage: file != null ? FileImage(file!) : null,
                    ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: file == null
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceAround,
                children: [
                  _userData != null &&
                              _userData!.avatar != null &&
                              _userData!.avatar!.length > 5 ||
                          file != null
                      ? TextButton.icon(
                          onPressed: () async {
                            if (_userData!.avatar != null &&
                                _userData!.avatar!.length > 5) {
                              await FireAuth()
                                  .deletAvatarImage(_userData!.avatar!);
                            }
                            setState(() {
                              file = null;
                              if (_userData != null &&
                                  _userData!.avatar != null &&
                                  _userData!.avatar!.length > 5) {
                                _userData = UserModel(
                                    id: _userData!.id,
                                    rating: _userData!.rating,
                                    language: _userData!.language,
                                    email: _userData!.email,
                                    name: _userData!.name,
                                    ListOfLanguages: _userData!.ListOfLanguages,
                                    avatar: '',
                                    date: _userData!.date,
                                    experience: _userData!.experience,
                                    gender: _userData!.gender,
                                    listOfExperiences:
                                        _userData!.listOfExperiences,
                                    location: _userData!.location,
                                    tags: _userData!.tags,
                                    token: _userData!.token);
                              }
                            });
                          },
                          icon: Icon(Icons.remove_circle, color: tarik),
                          label: Text(
                            'Remove image'.tr(),
                            style: TextStyle(
                                color: tarik,
                                fontSize: 12,
                                fontFamily: "rudaw"),
                          ),
                        )
                      : SizedBox(),
                  file == null &&
                          (_userData != null &&
                              (_userData!.avatar == null ||
                                  _userData!.avatar!.length < 4))
                      ? TextButton.icon(
                          onPressed: () {
                            _selectingImage();
                          },
                          icon: Icon(Icons.image, color: tarik),
                          label: Text(
                            'Select image'.tr(),
                            style: TextStyle(
                                color: tarik,
                                fontSize: 12,
                                fontFamily: "rudaw"),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _forms[0],
                child: Column(
                  children: [
                    EditeProfileTextInput(
                      controller: _controllers[0],
                      onSaved: (value) {
                        setState(() {
                          _userData = UserModel(
                              rating: _userData!.rating,
                              id: _userData!.id,
                              language: _userData!.language,
                              email: _userData!.email,
                              name: value,
                              ListOfLanguages: _userData!.ListOfLanguages,
                              avatar: _userData!.avatar,
                              date: _userData!.date,
                              experience: _userData!.experience,
                              gender: _userData!.gender,
                              listOfExperiences: _userData!.listOfExperiences,
                              location: _userData!.location,
                              tags: _userData!.tags,
                              token: _userData!.token);
                        });
                      },
                      title: 'Name'.tr(),
                    ),
                    EditeProfileTextInput(
                      controller: _controllers[1],
                      onSaved: (value) {
                        setState(() {
                          _userData = UserModel(
                              rating: _userData!.rating,
                              id: _userData!.id,
                              language: _userData!.language,
                              email: value,
                              name: _userData!.name,
                              ListOfLanguages: _userData!.ListOfLanguages,
                              avatar: _userData!.avatar,
                              date: _userData!.date,
                              experience: _userData!.experience,
                              gender: _userData!.gender,
                              listOfExperiences: _userData!.listOfExperiences,
                              location: _userData!.location,
                              tags: _userData!.tags,
                              token: _userData!.token);
                        });
                      },
                      title: 'Email'.tr(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: tarik,
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'Gender'.tr(),
                                style: TextStyle(
                                    color: tarik,
                                    fontSize: 14,
                                    fontFamily: "rudaw"),
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: shiri,
                            ),
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: tarik,
                              ),
                              child: RadioListTile<SingingCharacter>(
                                dense: true,
                                activeColor: tarik,
                                title: Text(
                                  'Male'.tr(),
                                  style: TextStyle(
                                      color: tarik,
                                      fontFamily: "rudaw",
                                      fontSize: 14),
                                ),
                                value: SingingCharacter.Male,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: tarik,
                              ),
                              child: RadioListTile<SingingCharacter>(
                                activeColor: tarik,
                                title: Text(
                                  'Female'.tr(),
                                  style: TextStyle(
                                      color: tarik,
                                      fontFamily: "rudaw",
                                      fontSize: 14),
                                ),
                                value: SingingCharacter.Female,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: tarik,
                              ),
                              child: RadioListTile<SingingCharacter>(
                                dense: true,
                                activeColor: tarik,
                                title: Text(
                                  'Other'.tr(),
                                  style: TextStyle(
                                      color: tarik,
                                      fontFamily: "rudaw",
                                      fontSize: 14),
                                ),
                                value: SingingCharacter.Other,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2,
                            color: tarik,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: tarik,
                              ),
                              child: TextButton.icon(
                                onPressed: _getCurrentLocation,
                                icon: Icon(
                                  Icons.add_location_alt,
                                  color: whiteColor,
                                  size: 20,
                                ),
                                label: Text(
                                  'add location'.tr(),
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 12,
                                      fontFamily: "rudaw"),
                                ),
                              ),
                            ),
                            _controllers[8].text.length < 1 &&
                                    _controllers[9].text.length < 1
                                ? Text(
                                    'optional!'.tr(),
                                    style: TextStyle(
                                        color: thered,
                                        fontSize: 12,
                                        fontFamily: "rudaw"),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _controllers[8].text = '';
                                        _controllers[9].text = '';
                                        print(_controllers[9].text);
                                      });
                                    },
                                    child: Text(
                                      'Clear'.tr(),
                                      style: TextStyle(
                                          color: thered,
                                          fontSize: 12,
                                          fontFamily: "rudaw"),
                                    )),
                            _controllers[8].text.length > 1 &&
                                    _controllers[9].text.length > 1
                                ? Expanded(
                                    child: Icon(Icons.check),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    )
                    //select city
                    // Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //   child: Container(
                    //     width: double.infinity,
                    //     padding: EdgeInsets.symmetric(horizontal: 10),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         width: 2,
                    //         color: tarik,
                    //       ),
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     child: SelectingCity(
                    //       initialCity: _selectCity,
                    //       type: 'city',
                    //       selectCategoryFun: selectCategoryFun,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      //step 2////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      FAStep(
        title: Text(
          'Experiece'.tr(),
          style: TextStyle(color: tarik, fontSize: 12, fontFamily: "rudaw"),
        ),
        isActive: true,
        state: FAStepstate.indexed,
        content: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: whiteColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              //form
              Form(
                key: _forms[1],
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditeProfileTextInput(
                        controller: _controllers[2],
                        onSaved: (value) {
                          setState(() {
                            _userData = UserModel(
                                rating: _userData!.rating,
                                id: _userData!.id,
                                language: _userData!.language,
                                email: _userData!.email,
                                name: _userData!.name,
                                ListOfLanguages: _userData!.ListOfLanguages,
                                avatar: _userData!.avatar,
                                date: _userData!.date,
                                experience: value, //ex
                                gender: _userData!.gender,
                                listOfExperiences: _userData!.listOfExperiences,
                                location: _userData!.location,
                                tags: _userData!.tags,
                                token: _userData!.token);
                          });
                        },
                        title: 'Write your experiece'.tr(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _experience.keys.toList().length > 0
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'List of your experience'.tr(),
                                      style: TextStyle(
                                          color: tarik,
                                          fontSize: 16,
                                          fontFamily: "rudaw"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(width: 2, color: tarik),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //listViews
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _experience.keys.toList().length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          child: Row(children: [
                                            CircleAvatar(
                                              backgroundColor: tarik,
                                              radius: 10,
                                              child: Text(
                                                '${(index + 1).toString()} ',
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontFamily: "rudaw",
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  ' ${_experience.keys.toList()[index].toString()} :',
                                                  style: TextStyle(
                                                    color: tarik,
                                                    fontFamily: "rudaw",
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${_experience.values.toList()[index].toString()}% ',
                                                  style: TextStyle(
                                                    color: tarik,
                                                    fontFamily: "rudaw",
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _experience.remove(_experience
                                                      .keys
                                                      .toList()[index]
                                                      .toString());
                                                });
                                              },
                                              icon: Icon(
                                                Icons.clear,
                                                color: tarik,
                                                size: 20,
                                              ),
                                            ),
                                          ]),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: tarik,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: tarik),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // width: 150,
                            child: CheckboxListTile(
                              dense: true,
                              activeColor: tarik,
                              checkColor: whiteColor,
                              value: _addExperience,
                              onChanged: (value) {
                                setState(() {
                                  _addExperience = value;
                                });
                              },
                              title: Text(
                                'Added experience to list'.tr(),
                                style: TextStyle(
                                    color: tarik,
                                    fontSize: 14,
                                    fontFamily: "rudaw"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      _addExperience!
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, right: 10, top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: tarik),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Form(
                                  key: _expenriesListForm,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      EditeProfileTextInput(
                                          controller: _controllers[3],
                                          onSaved: (value) {},
                                          title: 'Key'.tr()),
                                      EditeProfileTextInput(
                                          controller: _controllers[4],
                                          onSaved: (value) {},
                                          title: 'Value'.tr()),
                                      Container(
                                        width: double.infinity,
                                        height: 45,
                                        color: tarik,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            if (_expenriesListForm.currentState!
                                                .validate()) {
                                              _addedToListExperience();
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: whiteColor,
                                            size: 20,
                                          ),
                                          label: Text(
                                            'Add'.tr(),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 14,
                                                fontFamily: "rudaw"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      //step 3/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      FAStep(
        title: Text(
          'Languages'.tr(),
          style: TextStyle(color: tarik, fontSize: 12, fontFamily: "rudaw"),
        ),
        isActive: true,
        state: FAStepstate.indexed,
        content: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: whiteColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              //form
              Form(
                key: _forms[2],
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditeProfileTextInput(
                        controller: _controllers[5],
                        onSaved: (value) {
                          setState(() {
                            _userData = UserModel(
                                rating: _userData!.rating,
                                id: _userData!.id,
                                language: value,
                                email: _userData!.email,
                                name: _userData!.name,
                                ListOfLanguages: _userData!.ListOfLanguages,
                                avatar: _userData!.avatar,
                                date: _userData!.date,
                                experience: _userData!.experience,
                                gender: _userData!.gender,
                                listOfExperiences: _userData!.listOfExperiences,
                                location: _userData!.location,
                                tags: _userData!.tags,
                                token: _userData!.token);
                          });
                        },
                        title: 'Write languages you know'.tr(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _languages.keys.toList().length > 0
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'List of your languages'.tr(),
                                      style: TextStyle(
                                          color: tarik,
                                          fontSize: 16,
                                          fontFamily: "rudaw"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(width: 2, color: tarik),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _languages.keys.toList().length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: 45,
                                          child: Row(children: [
                                            CircleAvatar(
                                              backgroundColor: tarik,
                                              radius: 10,
                                              child: Text(
                                                '${(index + 1).toString()} ',
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontFamily: "rudaw",
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                ' ${_languages.keys.toList()[index].toString()} :',
                                                style: TextStyle(
                                                  color: tarik,
                                                  fontFamily: "rudaw",
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              ' ${_languages.values.toList()[index].toString()}% ',
                                              style: TextStyle(
                                                color: tarik,
                                                fontFamily: "rudaw",
                                                fontSize: 14,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _languages.remove(_languages
                                                      .keys
                                                      .toList()[index]
                                                      .toString());
                                                });
                                              },
                                              icon: Icon(
                                                Icons.clear,
                                                color: tarik,
                                                size: 20,
                                              ),
                                            ),
                                          ]),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: tarik,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: tarik),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // width: 150,
                            child: CheckboxListTile(
                              dense: true,
                              activeColor: tarik,
                              checkColor: whiteColor,
                              value: _addLanguages,
                              onChanged: (value) {
                                setState(() {
                                  _addLanguages = value;
                                });
                              },
                              title: Text(
                                'Added languages to list'.tr(),
                                style: TextStyle(
                                    color: tarik,
                                    fontSize: 14,
                                    fontFamily: "rudaw"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      _addLanguages!
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, right: 10, top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: tarik),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Form(
                                  key: _languagesListForm,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      EditeProfileTextInput(
                                        controller: _controllers[6],
                                        onSaved: (value) {},
                                        title: 'Key'.tr(),
                                      ),
                                      EditeProfileTextInput(
                                        controller: _controllers[7],
                                        onSaved: (value) {},
                                        title: 'Value'.tr(),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 45,
                                        color: tarik,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            if (_languagesListForm.currentState!
                                                .validate()) {
                                              _addedToListLanguages();
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: shiri,
                                            size: 20,
                                          ),
                                          label: Text(
                                            'Add'.tr(),
                                            style: TextStyle(
                                              color: shiri,
                                              fontFamily: "rudaw",
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      //step third
      FAStep(
        isActive: true,
        state: FAStepstate.indexed,
        title: Text(
          'Tags'.tr(),
          style: TextStyle(color: tarik, fontSize: 12, fontFamily: "rudaw"),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tags(
              key: _tagskey,
              itemCount: _tags.length,
              columns: 6,
              textField: TagsTextField(
                  helperText: 'Add tags'.tr(),
                  helperTextStyle: TextStyle(
                      fontSize: 14, color: tarik, fontFamily: "rudaw"),
                  textStyle: TextStyle(
                      color: tarik, fontSize: 14, fontFamily: "rudaw"),
                  inputDecoration: InputDecoration(
                    labelText: 'Add tags'.tr(),
                    labelStyle: TextStyle(
                        color: tarik, fontSize: 14, fontFamily: "rudaw"),
                    contentPadding: EdgeInsets.all(20),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: tarik,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: tarik,
                        width: 3,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: thered,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: thered, width: 2, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(
                      Icons.tag,
                      color: tarik,
                    ),
                    errorMaxLines: 2,
                    errorStyle: TextStyle(
                        color: thered, fontSize: 10, fontFamily: "rudaw"),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _tags.add(value);
                    });
                  }),
              itemBuilder: (index) {
                final item = _tags[index];
                return ItemTags(
                    color: shiri,
                    colorShowDuplicate: tarik,
                    highlightColor: theyellow,
                    activeColor: tarik,
                    textScaleFactor: 1,
                    index: index,
                    title: item,
                    // customData: item.customdata,
                    textStyle: TextStyle(
                        color: tarik, fontSize: 14, fontFamily: "rudaw"),
                    // combine: ItemTagsCombine.imageOrIconOrText,

                    onPressed: (value) {
                      print(value);
                    },
                    removeButton: ItemTagsRemoveButton(onRemoved: () {
                      setState(() {
                        _tags.removeAt(index);
                      });
                      return true;
                    }));
              },
            )
          ],
        ),
      )
    ];

// Scaffold
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        body: Theme(
          data: ThemeData(canvasColor: Colors.lightBlue),
          child: FAStepper(
            type: FAStepperType.horizontal,
            stepNumberColor: tarik,
            steps: _myStep,
            titleIconArrange: FAStepperTitleIconArrange.column,
            currentStep: _currentStep,
            // controlsBuilder: (BuildContext context,
            //     {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
            //   return Column(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.only(top: 50, bottom: 10),
            //         width: double.infinity,
            //         padding: EdgeInsets.symmetric(vertical: 0),
            //         decoration: BoxDecoration(
            //           color: tarik,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: _loadUpload
            //             ? Center(
            //                 child: CircularProgressIndicator(
            //                   color: whiteColor,
            //                 ),
            //               )
            //             : TextButton(
            //                 onPressed: onStepContinue,
            //                 child: Text(
            //                   _currentStep == 0
            //                       ? 'SUBMIT STEP 1'.tr()
            //                       : _currentStep == 1
            //                           ? 'SUBMIT STEP 2'.tr()
            //                           : _currentStep == 2
            //                               ? 'SUBMIT STEP 3'.tr()
            //                               : 'SUBMIT'.tr(),
            //                   style: TextStyle(
            //                       color: whiteColor,
            //                       fontSize: 16,
            //                       fontFamily: "rudaw"),
            //                 ),
            //               ),
            //       ),

            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 10.0),
            //         child: Transform.scale(
            //           scale: cancelClick! ? .5 : 1,
            //           child: Container(
            //             width: double.infinity,
            //             decoration: BoxDecoration(
            //               color: Colors.transparent,
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             child: TextButton(
            //               onPressed: onStepCancel,
            //               child: Text(
            //                 'BACK'.tr(),
            //                 style: TextStyle(
            //                     color: tarik,
            //                     fontSize: 16,
            //                     fontWeight: FontWeight.w700,
            //                     fontFamily: "rudaw"),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       // ),
            //     ],
            //   );
            // },
            onStepCancel: () {
              setState(() {
                if (_currentStep > 0) {
                  _currentStep = _currentStep - 1;
                } else {
                  _currentStep = 0;
                }
              });
            },
            onStepContinue: () {
              setState(() {
                var _checkValidate = _currentStep < 2
                    ? _forms[_currentStep].currentState!.validate()
                    : true;

                if (_checkValidate) {
                  if (_currentStep < _myStep.length - 1) {
                    _forms[_currentStep].currentState!.save();
                    print(_userData!.name);
                    _currentStep = _currentStep + 1;
                  } else {
                    if (_currentStep != 3) {
                      _forms[_currentStep].currentState!.save();
                    }
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user!.email != _userData!.email) {
                      FireAuth()
                          .changeEmail(email: _userData!.email)!
                          .then((value) async {
                        print(_userData!.email);
                        print('changed email');
                        await user.reload();
                        setState(() {
                          _userData = UserModel(
                              rating: _userData!.rating,
                              id: _userData!.id,
                              language: _userData!.language,
                              email: _userData!.email,
                              name: _userData!.name,
                              ListOfLanguages: _languages,
                              avatar: _userData!.avatar,
                              date: _userData!.date,
                              experience: _userData!.experience,
                              gender: _character.toString().split('.')[1],
                              listOfExperiences: _experience,
                              location: {
                                'lat': _controllers[8].text.toString(),
                                'long': _controllers[9].text.toString(),
                              },
                              tags: _tags,
                              token: _userData!.token);
                        });

                        _toFireStore(_userData!);
                      }).catchError((e) {
                        print(
                            '-----------------------------------------------------------------------');
                        print(e
                            .toString()
                            .split('[firebase_auth/requires-recent-login]')[1]);
                        print(
                            '-----------------------------------------------------------------------');
                        AchievementView(
                          context,
                          duration: Duration(seconds: 5),
                          alignment: Alignment.topCenter,
                          elevation: 0,
                          color: Colors.red,
                          borderRadius: 50,
                          icon: Icon(
                            Icons.error_outline,
                            color: spi,
                            size: 25,
                          ),
                          title: 'Change email?'.tr(),
                          subTitle:
                              ' This operation is sensitive and requires recent authentication. Cencel this all step and log in again before retrying this request.'
                                  .tr(),
                          textStyleSubTitle: TextStyle(
                            color: whiteColor,
                            fontSize: 14,
                            fontFamily: 'rudaw',
                          ),
                          textStyleTitle: TextStyle(
                            color: whiteColor,
                            fontSize: 14,
                            fontFamily: 'rudaw',
                          ),
                        )..show();
                      });
                    } else {
                      setState(() {
                        _userData = UserModel(
                            rating: _userData!.rating,
                            id: _userData!.id,
                            language: _userData!.language,
                            email: _userData!.email,
                            name: _userData!.name,
                            ListOfLanguages: _languages,
                            avatar: _userData!.avatar,
                            date: _userData!.date,
                            experience: _userData!.experience,
                            gender: _character.toString().split('.')[1],
                            listOfExperiences: _experience,
                            location: {
                              'lat': _controllers[8].text.toString(),
                              'long': _controllers[9].text.toString(),
                            },
                            tags: _tags,
                            token: _userData!.token);
                      });

                      _toFireStore(_userData!);
                    }
                  }
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
