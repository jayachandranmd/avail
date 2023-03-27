import 'dart:io';

import 'package:avail_itech_hackfest/screens/auth/sign_in.dart';
import 'package:avail_itech_hackfest/screens/contributers/contributer_intro.dart';
import 'package:avail_itech_hackfest/utils/auth_method.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/image_picker.dart';
import '../utils/storage_methods.dart';
import '../utils/textstyle.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _image;
  selectImage() async {
    final img = await pickImage(ImageSource.gallery);
    cropImage(img!.path);
  }

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
          toolbarTitle: 'Cropper',
          toolbarColor: HexColor('#ED7524'),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }

    String photoUrl =
        await StorageMethods().uploadImageToStroage('profilePics', _image!);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'photoUrl': photoUrl});
    print(photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: selectImage),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                Image.asset(
                  'assets/images/shape.png',
                  width: double.infinity,
                ),
                sBoxH10,
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          snapshot.data['photoUrl'].toString(),
                        ),
                      )),
                ),
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: yellow),
                        child: InkWell(
                            onTap: selectImage, child: Icon(Icons.camera_alt)),
                      ),
                    ),
                  ],
                ),
                sBoxH20,
                Center(
                  child: Text(
                    snapshot.data['firstName'],
                    style: username,
                  ),
                ),
                sBoxH30,
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContributerIntro()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: white,
                      border: Border.all(color: yellow),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/NGO_Tag.png?alt=media&token=3a0ca98d-c0f1-423f-9a2a-89e2a552f551',
                          height: 25,
                        ),
                        sBoxW10,
                        const Text('NGO',
                            style: TextStyle(
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ),
                ),
                sBoxH10,
                // Center(
                //   child: Text('Verification process pending...',
                //   style: TextStyle(
                //     fontSize:17,
                //     color: red
                //   ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                sBoxH20,
                Divider(
                  color: lightgray,
                  thickness: 1,
                ),
                sBoxH5,
                Padding(
                  padding: hpad12 + hpad4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.mode_edit_outlined,
                        color: black,
                        size: 25,
                      ),
                      sBoxW10,
                      sBoxW5,
                      Text('Edit', style: username),
                    ],
                  ),
                ),
                sBoxH5,
                Divider(
                  color: lightgray,
                  thickness: 1,
                ),
                sBoxH5,
                Padding(
                  padding: hpad12 + hpad4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.mail_outline,
                        color: black,
                        size: 25,
                      ),
                      sBoxW10,
                      sBoxW5,
                      Text(snapshot.data['email'], style: username),
                    ],
                  ),
                ),
                sBoxH5,
                Divider(
                  color: lightgray,
                  thickness: 1,
                ),
                sBoxH5,
                Padding(
                  padding: hpad12 + hpad4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.call_outlined,
                        color: black,
                        size: 25,
                      ),
                      sBoxW10,
                      sBoxW5,
                      Text(snapshot.data['phnNum'], style: username),
                    ],
                  ),
                ),
                sBoxH5,
                Divider(
                  color: lightgray,
                  thickness: 1,
                ),
                sBoxH5,
                Padding(
                  padding: hpad12 + hpad4,
                  child: GestureDetector(
                    onTap: () async {
                      await AuthMethods().signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: black,
                          size: 25,
                        ),
                        sBoxW10,
                        sBoxW5,
                        Text('Logout', style: username),
                      ],
                    ),
                  ),
                ),
                sBoxH5,
                Divider(
                  color: lightgray,
                  thickness: 1,
                ),
              ],
            );
          }),
    ));
  }
}
