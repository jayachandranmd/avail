import 'dart:io';

import 'package:avail_itech_hackfest/screens/home/mainhomepage.dart';
import 'package:avail_itech_hackfest/utils/constants.dart';
import 'package:avail_itech_hackfest/utils/textstyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/colors.dart';

class PostForm extends StatefulWidget {
  PostForm({Key? key}) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  File? imageFile;
  TextEditingController locationController = TextEditingController();
  final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final time = DateFormat('hh:mm:ss').format(DateTime.now());
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController postDetail = TextEditingController();
  final TextEditingController contact = TextEditingController();
  List<bool> values = [false, false, false];
  List tags = ['Clothes', 'Food', 'Volunteering'];
  List image = [
    'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/clothes_Tag.png?alt=media&token=09e3f3d0-012c-4fb8-92e7-5a739f56fcea',
    'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/clothes_Tag.png?alt=media&token=09e3f3d0-012c-4fb8-92e7-5a739f56fcea',
    'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/clothes_Tag.png?alt=media&token=09e3f3d0-012c-4fb8-92e7-5a739f56fcea'
  ];
  Map<String, bool> postTag = {
    'Clothes': false,
    'Food': false,
    'Volunteering': false,
  };
  var updated;

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
                    children: [
                      sBoxH20, sBoxH5,
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Locating...",
                          suffixIcon: Icon(Icons.location_searching),
                          suffixIconColor: yellow,
                        ),
                        controller: locationController,
                      ),
                      sBoxH20,
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
                                subtitle: const Text(
                                  'username',
                                  style: TextStyle(fontSize: 18),
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
                                      textInputAction: TextInputAction.newline,
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
                        child: Row(
                          children: [
                            Text(
                              'Tags',
                              style: textFieldTitle,
                            ),
                            Text(
                              '*',
                              style: TextStyle(color: red, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      sBoxH20,
                      //Tags
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        values[index] = !values[index];
                                        postTag.update(
                                            postTag.keys.toList()[index],
                                            (value) => values[index]);
                                        if (kDebugMode) {
                                          print(postTag);
                                        }
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: HexColor('#FEED5F'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      backgroundColor: values[index] == true
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
                      Padding(
                        padding: hpad4,
                        child: Row(
                          children: [
                            Text(
                              'Contact',
                              style: textFieldTitle,
                            ),
                            Text(
                              '*',
                              style: TextStyle(color: red, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      sBoxH10,
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Mobile",
                        ),
                        controller: contact,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Contact number is required");
                          }
                          if (value.length < 10) {
                            return ("Mobile Number must be of 10 digit");
                          }
                          return null;
                        },
                        cursorColor: HexColor('#AEAEAE'),
                        onSaved: (value) {
                          contact.text = value!;
                        },
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    _imgFromGallery() async {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;

        final tempImage = File(image.path);
        setState(() {
          this.imageFile = tempImage;
        });
      } on PlatformException catch (e) {
        print('Failed to pick image $e');
      }
    }

    _imgFromCamera() async {
      try {
        final image = await ImagePicker()
            .pickImage(source: ImageSource.camera, imageQuality: 100);
        if (image == null) return;

        final tempImage = File(image.path);
        setState(() {
          this.imageFile = tempImage;
        });
      } on PlatformException catch (e) {
        print('Failed to pick image $e');
      }
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
                      _imgFromGallery();
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
                      _imgFromCamera();
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
    if (postDetail.toString().isNotEmpty &&
        postDetail.toString().trim() != " " &&
        contact.text.isNotEmpty) {
      await _firestore.collection("feeds").add({
        "content": postDetail.text.toString(),
        "contact": contact.text.toString(),
        "name": user.data()!["firstName"],
        "photoUrl": user.data()!["photoUrl"],
        "volunteerStatus": postTag['Volunteering'],
        "clothes": postTag['Clothes'],
        "food": postTag['Food'],
        "date": date.toString(),
        "time": time.toString(),
        "timestamp": FieldValue.serverTimestamp(),
      });
      Fluttertoast.showToast(msg: "Post added");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainHomePage()));
    } else {
      Fluttertoast.showToast(msg: "Please fill the content");
    }
  }
}
