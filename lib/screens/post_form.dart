import 'dart:io';

import 'package:avail_itech_hackfest/utils/constants.dart';
import 'package:avail_itech_hackfest/utils/textstyle.dart';
import 'package:avail_itech_hackfest/utils/time_ago.dart';
import 'package:avail_itech_hackfest/widgets/textformfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/colors.dart';
import '../utils/image_picker.dart';
import '../utils/storage_methods.dart';
import 'home/homepage.dart';

class PostForm extends StatefulWidget {
  PostForm({Key? key}) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  List<bool> values = [true, false, false];

  File? imageFile;
  TextEditingController locationController = TextEditingController();
  final date = DateTime.now();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController postDetail = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController volunteersNeeded = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String stateValue = "";
  String cityValue = "";

  bool stateselected = false;
  bool cityselected = false;

  List tags = ['clothes', 'food', 'volunteer'];
  List image = [
    'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/clothestag.png?alt=media&token=e5688e79-adf3-4a8f-bdb5-59d6bb656af9',
    'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/foodtag.png?alt=media&token=c8066b5e-685d-4cc0-acb8-2cd9f6b9152b',
    'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/ngoprofiletag.png?alt=media&token=ef5c8a99-62e0-4d4d-ac4a-51acaaaf9301'
  ];
  Map<String, bool> postTag = {
    'clothes': false,
    'food': false,
    'volunteer': false,
  };
  var updated;
  var selected = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 80,
          elevation: 2,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: black,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      updated = postTag.keys
                          .where((element) => postTag[element] == true);
                      if (kDebugMode) {
                        print(updated);
                      }
                    });
                    postFeed();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: HexColor('#FEED5F'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  child: const Text('Post',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: key,
            child: Padding(
              padding: vpad8 + hpad8,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .get(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sBoxH20, sBoxH5,
                        SizedBox(
                          //height: 400,
                          width: double.infinity,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: HexColor('#FEED5F'),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            shadowColor: HexColor('#FEED5F'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sBoxH10, sBoxH5,
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: CachedNetworkImageProvider(
                                        snapshot.data['photoUrl']),
                                  ),
                                  title: Text(
                                    snapshot.data['firstName'],
                                    style: textFieldTitle,
                                  ),
                                  trailing: imageFile == null
                                      ? SizedBox(
                                          height: 0,
                                          width: 0,
                                        )
                                      : Image.file(
                                          File(imageFile!.path),
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                                //Content
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SingleChildScrollView(
                                    child: SizedBox(
                                      //height: 200,
                                      child: TextFormField(
                                        maxLines: 30,
                                        minLines: 2,
                                        textInputAction:
                                            TextInputAction.newline,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          hintText: "Write a caption",
                                          fillColor: Colors.white,
                                        ),
                                        style: textFieldpara,
                                        cursorColor: HexColor('#AEAEAE'),
                                        cursorHeight: 20,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter sentence";
                                          }
                                          return null;
                                        },
                                        controller: postDetail,
                                        onSaved: (value) {
                                          postDetail.text = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Map<Permission, PermissionStatus> status =
                                        await [
                                      Permission.storage,
                                      Permission.camera,
                                      Permission.photos,
                                    ].request();
                                    if (status[Permission.camera]!.isGranted) {
                                      showImagePicker(context);
                                    } else {
                                      print("No permission provider");
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          'Add Image',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: black),
                                        )),
                                  ),
                                ),
                                sBoxH10,
                              ],
                            ),
                          ),
                        ),
                        sBoxH20,
                        Padding(
                          padding: hpad4,
                          child: Text(
                            'Tags',
                            style: textFieldTitle,
                          ),
                        ),
                        sBoxH20,
                        //Tags
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                snapshot.data['userType'].toString() == "NGO"
                                    ? values.length
                                    : values.length - 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          selected = index;
                                          print(selected);
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: HexColor('#FEED5F'),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        backgroundColor: selected == index
                                            ? HexColor('#FEED5F')
                                            : white,
                                        side: BorderSide(
                                            color: HexColor('#FEED5F')),
                                      ),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: image[index],
                                            height: 20,
                                          ),
                                          sBoxW5,
                                          Text(
                                            tags[index],
                                            style: textFieldpara,
                                          )
                                        ],
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                        sBoxH20,
                        CSCPicker(
                          defaultCountry: CscCountry.India,
                          disableCountry: true,

                          ///placeholders for dropdown search field
                          countrySearchPlaceholder: "Country",
                          stateSearchPlaceholder: "State",
                          citySearchPlaceholder: "City",

                          ///labels for dropdown
                          stateDropdownLabel: "State",
                          cityDropdownLabel: "City",
                          onCountryChanged: (value) {},
                          onStateChanged: (value) {
                            setState(() {
                              stateValue = value.toString();
                              stateselected = true;
                            });
                          },
                          onCityChanged: (value) {
                            setState(() {
                              cityValue = value.toString();
                              cityselected = true;
                            });
                          },
                        ),
                        sBoxH20,
                        Padding(
                          padding: hpad4,
                          child: Text(
                            'Contact',
                            style: textFieldTitle,
                          ),
                        ),
                        sBoxH10,
                        Padding(
                          padding: hpad12,
                          child: TextFieldInput(
                            hintText: "Mobile",
                            textEditingController: contact,
                            keyboard: TextInputType.number,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return ("Contact number is required");
                              }
                              if (value.length < 10 || value.length > 10) {
                                return ("Mobile Number must be of 10 digit");
                              }
                              return null;
                            },
                            save: (value) {
                              contact.text = value!;
                            },
                          ),
                        ),
                        selected == 2
                            ? Padding(
                                padding: hpad12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sBoxH20,
                                    Text(
                                      'Volunteers',
                                      style: textFieldTitle,
                                    ),
                                    sBoxH10,
                                    TextFieldInput(
                                      hintText: "Enter number",
                                      textEditingController: volunteersNeeded,
                                      keyboard: TextInputType.number,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return ("volunteer required");
                                        }
                                        if (value.length > 2) {
                                          return 'Enter a number less than 100';
                                        }
                                        return null;
                                      },
                                      save: (value) {
                                        volunteersNeeded.text = value!;
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  void showImagePicker(BuildContext context) {
    void cropImage(filePath) async {
      File? croppedFile = (await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            activeControlsWidgetColor: yellow,
            toolbarTitle: 'Cropper',
            toolbarColor: yellow,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ));
      if (croppedFile != null) {
        setState(() {
          imageFile = croppedFile;
        });
      }
    }

    selectImage(ImageSource imageSource) async {
      final img = await pickImage(imageSource);
      cropImage(img!.path);
    }

    showBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
              height: MediaQuery.of(context).size.height / 5.2,
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: InkWell(
                    child: Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 60,
                        ),
                        sBoxH10,
                        Text(
                          'Gallery',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        )
                      ],
                    ),
                    onTap: () {
                      selectImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  )),
                  Expanded(
                      child: InkWell(
                    child: SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 60,
                          ),
                          sBoxH10,
                          Text(
                            'Camera',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      selectImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  )),
                ],
              ),
            ),
          );
        });
  }

  void postFeed() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final user = await _firestore.collection("users").doc(uid).get();
    final postDocIdRef = _firestore.collection('feeds').doc();
    String timeAgoText = timeAgo(date.toString());
    if (postTag['volunteer'] == true) {
      if (postDetail.toString().isNotEmpty &&
          postDetail.toString().trim() != " " &&
          contact.text.isNotEmpty &&
          imageFile!.path.isNotEmpty &&
          volunteersNeeded.text.isNotEmpty &&
          cityselected == true &&
          stateselected == true &&
          selected != -1 &&
          key.currentState!.validate()) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        String photoUrl = await StorageMethods()
            .uploadPostImageToStroage('postPics', imageFile!, postDocIdRef.id);
        await _firestore.collection('feeds').doc(postDocIdRef.id).set({
          "content": postDetail.text.toString(),
          "contact": contact.text.toString(),
          "name": user.data()!["firstName"],
          "uid": uid.toString(),
          "tag": tags[selected],
          "date": date.toString(),
          "volunteer": volunteersNeeded.text.toString(),
          "timestamp": FieldValue.serverTimestamp(),
          'photoUrl': photoUrl.toString(),
          "state": stateValue.toString(),
          "city": cityValue.toString(),
          "timeago": timeAgoText.toString()
        });

        Fluttertoast.showToast(msg: "Post added");
      }
    } else if (postDetail.toString().isNotEmpty &&
        postDetail.toString().trim() != " " &&
        contact.text.isNotEmpty &&
        imageFile!.path.isNotEmpty &&
        cityselected == true &&
        stateselected == true &&
        selected != -1 &&
        key.currentState!.validate()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      String photoUrl = await StorageMethods()
          .uploadPostImageToStroage('postPics', imageFile!, postDocIdRef.id);
      await _firestore.collection('feeds').doc(postDocIdRef.id).set({
        "content": postDetail.text.toString(),
        "contact": contact.text.toString(),
        "name": user.data()!["firstName"],
        "uid": uid.toString(),
        "tag": tags[selected],
        "date": date.toString(),
        "timestamp": FieldValue.serverTimestamp(),
        'photoUrl': photoUrl.toString(),
        "state": stateValue.toString(),
        "city": cityValue.toString(),
        "timeago": timeAgoText.toString()
      });

      Fluttertoast.showToast(msg: "Post added");
    } else {
      Fluttertoast.showToast(msg: "Please fill the content");
    }
  }
}
