import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'package:achievement_view/achievement_view.dart';
import 'package:fa_stepper/fa_stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:main/color.dart';
import 'package:main/models/project_model.dart';
import 'package:main/provider/firestore.dart';
import 'package:main/screens/home.dart';
import 'package:main/widget/Text.dart';
import 'package:main/widget/text_form_field_post.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class AddPostInput extends StatefulWidget {
  static const routeName = '/add-post';

  AddPostInput({Key? key}) : super(key: key);

  @override
  _AddPostInputState createState() => _AddPostInputState();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
// List<GlobalKey<FormState>> _formKeys = [
//   GlobalKey<FormState>(),
//   GlobalKey<FormState>(),
// ];
///////////////////////////////////////////////////////////////////////////////////////////////
final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
GlobalKey<TagsState> _tagskey = GlobalKey<TagsState>();
GlobalKey<FormState> _priceFormKey = GlobalKey<FormState>();

class _AddPostInputState extends State<AddPostInput>
    with TickerProviderStateMixin {
  late final AnimationController _controllerRotateIndecator;
////////////////////////////variable//////////////
  int _currentStep = 0;
  String? _typePost;
  bool? _checkBoxSale = true;
  List<File> _imageFileList = [];
  List<String> _imageUrlList = [];

  List _tags = [];
  late ProjectModel _dataText;
  List _colors = [
    shiri,
    Color(0xffF65b65),
    Colors.red,
    Color(0xfffac725),
    Color(0xff00dbde),
    Color(0xfffc00ff),
  ];
  final txtCtrlList = [
    // 0 =title
    // 1 =description
    // 2=price
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final _tagsController = TextEditingController();
  bool _onesRunDataFirstDidChangeType = true;
  bool _onesRunDataFirstDidChangeEdite = true;

///////////////////////////////////////////////////////
  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;

    _controllerRotateIndecator =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat();

    _dataText = ProjectModel(
      tags: [],
      id: null,
      userId: user!.uid,
      title: '',
      description: '',
      imageUrl: [],
      category: '',
      comments: {},
      date: DateFormat("dd-MM-yyyy h:mma", 'en').format(DateTime.now()),
      likes: [],
      saveList: [],
    );

    super.initState();
  }

//what type fun for define type post
  void _whatTypePostDidChange() async {
    if (_onesRunDataFirstDidChangeType) {
      String whatPorpose = ModalRoute.of(context)!.settings.arguments as String;
      if (whatPorpose == 'project' ||
          whatPorpose == 'work' ||
          whatPorpose == 'question') {
        String typepost = whatPorpose;
        setState(() {
          _typePost = typepost;
          //
          _dataText = ProjectModel(
            tags: [],
            id: null,
            userId: _dataText.userId,
            title: '',
            description: '',
            imageUrl: [],
            category: typepost,
            comments: {},
            date: DateFormat("dd-MM-yyyy h:mma", 'en').format(DateTime.now()),
            likes: [],
            saveList: [],
          );
        });
      }
    }
    setState(() {
      _onesRunDataFirstDidChangeType = false;
    });
  }

//edite fun
  void _editePostDidChange() async {
    if (_onesRunDataFirstDidChangeEdite) {
      String whatPorpose = ModalRoute.of(context)!.settings.arguments as String;

      if (whatPorpose != 'project' &&
          whatPorpose != 'work' &&
          whatPorpose != 'question') {
        String _postId = whatPorpose;
        var data = await FireStore().getPostFromFirestoreById(_postId);
        setState(() {
          _dataText = ProjectModel(
            tags: data!.tags,
            id: data.id,
            price: data.price,
            userId: data.userId,
            title: data.title,
            description: data.description,
            imageUrl: data.imageUrl,
            category: data.category,
            comments: data.comments,
            date: data.date,
            likes: data.likes,
            saveList: data.saveList,
          );
          _tags = _dataText.tags!;
          _typePost = data.category;
          //agar project and must be image not null
          if (_dataText.imageUrl != null) {
            _imageUrlList = [..._dataText.imageUrl!];
          }
        });
        txtCtrlList[0].text = _dataText.title!;
        txtCtrlList[1].text = _dataText.description!;
        // if price not not

        if (_dataText.price != null) {
          txtCtrlList[2].text = _dataText.price!.toString();
        }
      }
      setState(() {
        _onesRunDataFirstDidChangeEdite = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _whatTypePostDidChange();
    _editePostDidChange();
  }

  @override
  void dispose() {
    _controllerRotateIndecator.dispose();
    txtCtrlList.forEach((element) {
      element.dispose();
    });
    _tagsController.dispose();
    super.dispose();
  }

//ImagePicker
  void selectedImage() async {
    final _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    File? cropedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 90,
        maxHeight: 350,
        maxWidth: 350,
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
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
      _imageFileList.add(cropedImage!);
    });
  }

  // lodingg upload
  bool loadWorkAdd = false;
  bool loadUpload = false;
  double valueIndecator = 0;
  void _loadUpload(loadUploadd, valueIndecatorr) {
    setState(() {
      loadUpload = loadUploadd;
      valueIndecator = valueIndecatorr;
    });
  }

  void _goBack() {
    Navigator.of(context).pushReplacementNamed(Home.routeName);
  }

//override
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

//step item///////////////////////////////////////////////////////////////////////////
    List<FAStep> mySteps = [
      FAStep(
        //step one
        state: FAStepstate.indexed,
        isActive: true,
        title: Text(
          'Info'.tr(),
          style:
              TextStyle(color: blackColor, fontSize: 14, fontFamily: "rudaw"),
        ),
        content: Form(
          key: _formKeys,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormFieldPost(
                typePost: _typePost,
                typeInput: 'title',
                txtCtrl: txtCtrlList,
                onSaved: (value) {
                  setState(() {
                    _dataText = ProjectModel(
                        tags: _dataText.tags,
                        id: _dataText.id,
                        userId: _dataText.userId,
                        title: value,
                        description: _dataText.description,
                        category: _dataText.category,
                        comments: _dataText.comments,
                        imageUrl: _dataText.imageUrl,
                        likes: _dataText.likes,
                        price: _dataText.price,
                        date: _dataText.date,
                        saveList: _dataText.saveList);
                  });
                },
              ),
              TextFormFieldPost(
                typePost: _typePost,
                typeInput: 'description',
                txtCtrl: txtCtrlList,
                onSaved: (value) {
                  setState(() {
                    _dataText = ProjectModel(
                        tags: _dataText.tags,
                        id: _dataText.id,
                        userId: _dataText.userId,
                        date: _dataText.date,
                        title: _dataText.title,
                        description: value,
                        category: _dataText.category,
                        comments: _dataText.comments,
                        imageUrl: _dataText.imageUrl,
                        likes: _dataText.likes,
                        price: _dataText.price,
                        saveList: _dataText.saveList);
                  });
                },
              ),
              _typePost == 'project'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.grey,
                        ),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20)),
                          child: CheckboxListTile(
                            dense: true,
                            checkColor: whiteColor,
                            activeColor: blackColor,
                            value: _checkBoxSale,
                            onChanged: (value) {
                              setState(() {
                                _checkBoxSale = value;
                              });
                            },
                            title: TextWd(
                              title: 'For sale'.tr(),
                              color: blackColor,
                              fSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              _checkBoxSale! && _typePost == 'project'
                  ? Form(
                      key: _priceFormKey,
                      child: TextFormFieldPost(
                        typePost: _typePost,
                        typeInput: 'price',
                        txtCtrl: txtCtrlList,
                        onSaved: (value) {
                          setState(() {
                            _dataText = ProjectModel(
                              tags: _dataText.tags,
                              id: _dataText.id,
                              userId: _dataText.userId,
                              date: _dataText.date,
                              title: _dataText.title,
                              description: _dataText.description,
                              category: _dataText.category,
                              comments: _dataText.comments,
                              imageUrl: _dataText.imageUrl,
                              likes: _dataText.likes,
                              saveList: _dataText.saveList,
                              price: double.parse(value!),
                            );
                          });
                        },
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
//  step 2  //////////////////////////////////
      FAStep(
        isActive: true,
        state: FAStepstate.indexed,
        title: Text(
          'Add image'.tr(),
          style:
              TextStyle(color: blackColor, fontSize: 14, fontFamily: "rudaw"),
        ),
        content: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _imageFileList.length > 4
                      ? SizedBox()
                      : Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                          decoration: BoxDecoration(
                            color: thered,
                            borderRadius: BorderRadius.circular(27),
                          ),
                          child: TextButton.icon(
                            onPressed: () {
                              selectedImage();
                            },
                            icon: Icon(
                              Icons.add,
                              color: whiteColor,
                              size: 20,
                            ),
                            label: Text(
                              _imageFileList.length > 0
                                  ? 'Add more image'.tr()
                                  : 'Add image'.tr(),
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontFamily: "rudaw"),
                            ),
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: thered,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '${_imageFileList.length}/5',
                      style: TextStyle(
                        color: whiteColor,
                        fontFamily: 'rudaw',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //GridView
            GridView.builder(
              itemCount: _imageFileList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: (itemWidth / itemHeight)),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              // height: 150,
                              child: Image.file(
                                _imageFileList[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: tarik,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _imageFileList.removeAt(index);
                                    });
                                  },
                                  icon:
                                      Icon(Icons.clear, color: shiri, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),

      //step 3
      FAStep(
        isActive: true,
        state: FAStepstate.indexed,
        title: Text(
          'Add tags'.tr(),
          style:
              TextStyle(color: blackColor, fontSize: 14, fontFamily: "rudaw"),
        ),
        content: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Tags(
                key: _tagskey,
                itemCount: _tags.length,
                columns: 6,
                textField: TagsTextField(
                    helperText: 'Add tags'.tr(),
                    helperTextStyle:
                        TextStyle(color: blackColor, fontFamily: "rudaw"),
                    textStyle: TextStyle(
                        color: blackColor, fontSize: 14, fontFamily: "rudaw"),
                    inputDecoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: blackColor, fontSize: 14, fontFamily: "rudaw"),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: thered, width: 1, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: thered, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(
                        Icons.tag,
                        color: Colors.grey.shade400,
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
                      activeColor: _colors[Random().nextInt(6)],
                      textScaleFactor: 1,
                      index: index,
                      title: item,
                      textStyle: TextStyle(
                        color: tarik,
                        fontSize: 14,
                        fontFamily: "rudaw",
                      ),
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
        ),
      )
    ];
    if (_typePost != 'project' || _dataText.id != null) {
      mySteps.removeAt(1);
    }
    //scafold

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          title: Text(
            _typePost == 'question'
                ? 'typePostQ'.tr()
                : _typePost == 'work'
                    ? 'typePostW'.tr()
                    : _typePost == 'project'
                        ? 'typePostP'.tr()
                        : 'empry',
            style: TextStyle(
                color: blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: "rudaw"),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FAStepper(
                    titleIconArrange: FAStepperTitleIconArrange.row,
                    physics: ClampingScrollPhysics(),
                    currentStep: this._currentStep,
                    titleHeight: 120,
                    steps: mySteps,
                    type: FAStepperType.vertical,
                    stepNumberColor: thered,
                    // controlsBuilder: (BuildContext context,
                    //     {VoidCallback? onStepContinue,
                    //     VoidCallback? onStepCancel}) {
                    //   return Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 20),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         TextButton(
                    //           onPressed: onStepCancel,
                    //           child: Text(
                    //             'BACK'.tr(),
                    //             style: TextStyle(
                    //                 color: greyShadeColor,
                    //                 fontSize: 14,
                    //                 fontFamily: "rudaw"),
                    //           ),
                    //         ),
                    //         loadUpload || loadWorkAdd
                    //             ? AnimatedBuilder(
                    //                 animation: _controllerRotateIndecator,
                    //                 builder: (_, child) {
                    //                   return Transform.rotate(
                    //                     angle:
                    //                         _controllerRotateIndecator.value *
                    //                             2 *
                    //                             math.pi,
                    //                     child: child,
                    //                   );
                    //                 },
                    //                 child: CircularProgressIndicator(
                    //                   value: loadWorkAdd ? .8 : valueIndecator,
                    //                   color: thered,
                    //                 ))
                    //             : TextButton(
                    //                 onPressed: onStepContinue,
                    //                 child: Container(
                    //                   padding: EdgeInsets.all(10),
                    //                   decoration: BoxDecoration(
                    //                     color: thered,
                    //                     borderRadius: BorderRadius.circular(10),
                    //                   ),
                    //                   child: Text(
                    //                     _currentStep == mySteps.length - 1
                    //                         ? 'SUBMIT'.tr()
                    //                         : "CONTINUE".tr(),
                    //                     style: TextStyle(
                    //                         color: whiteColor,
                    //                         fontSize: 14,
                    //                         fontFamily: "rudaw"),
                    //                   ),
                    //                 ),
                    //               ),
                    //       ],
                    //     ),
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
                      bool _validatePrice = _typePost == 'project' &&
                              (_checkBoxSale != null && _checkBoxSale!)
                          ? _priceFormKey.currentState!.validate()
                          : true;

                      setState(() {
                        _formKeys.currentState!.save();
                        if (_formKeys.currentState!.validate() &&
                            _validatePrice) {
                          if (_currentStep < mySteps.length - 1) {
                            if (_currentStep != 1) {
                              _currentStep = _currentStep + 1;
                            } else {
                              if (_imageFileList.length > 0) {
                                _currentStep = _currentStep + 1;
                              } else {
                                AchievementView(
                                  context,
                                  alignment: Alignment.topCenter,
                                  elevation: 0,
                                  color: Colors.red,
                                  borderRadius: 50,
                                  icon: Icon(
                                    Icons.error_outline,
                                    color: spi,
                                    size: 25,
                                  ),
                                  title: 'Added image Please'.tr(),
                                  subTitle:
                                      'You cant create project without image.'
                                          .tr(),
                                  textStyleSubTitle: TextStyle(
                                    color: spi,
                                    fontSize: 14,
                                    fontFamily: 'rudaw',
                                  ),
                                  textStyleTitle: TextStyle(
                                    color: spi,
                                    fontSize: 14,
                                    fontFamily: 'rudaw',
                                  ),
                                )..show();
                              }
                            }
                          } else {
                            setState(() {
                              loadWorkAdd = true;
                            });
                            setState(() {
                              _dataText = ProjectModel(
                                tags: _tags,
                                id: _dataText.id,
                                userId: _dataText.userId,
                                date: _dataText.date,
                                title: _dataText.title,
                                description: _dataText.description,
                                category: _dataText.category,
                                comments: _dataText.comments,
                                imageUrl: _dataText.imageUrl,
                                likes: _dataText.likes,
                                saveList: _dataText.saveList,
                                price: _checkBoxSale!
                                    ? txtCtrlList[2].text.length > 0
                                        ? double.parse(txtCtrlList[2].text)
                                        : null
                                    : null,
                              );
                            });
                            print(_dataText.price);
                            FireStore()
                                .uloadToFireStorage(
                                    _typePost,
                                    _imageFileList,
                                    _dataText,
                                    _loadUpload,
                                    _imageFileList.length,
                                    _goBack)!
                                .then((value) => null)
                                .catchError((err) {
                              print(err);
                            });
                          }
                        } else {
                          print('why');
                        }
                      });
                      if (_currentStep == 2) {}
                    }

                    // Log function call

                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
