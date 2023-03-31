import 'dart:io';

import 'package:avail_itech_hackfest/screens/auth/sign_in.dart';
import 'package:avail_itech_hackfest/utils/auth_method.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          activeControlsWidgetColor: yellow,
          toolbarTitle: 'Cropper',
          toolbarColor: yellow,
          toolbarWidgetColor: Colors.black,
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

  Map<String, String> Tag = {
    'NGO':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/ngoprofiletag.png?alt=media&token=021945ea-1f27-4ba4-b0dc-776bb832a820',
    'Individual':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/individualtag.png?alt=media&token=6795a440-41bb-41fc-89a3-cc9cb1e72f6b',
    'Hotels':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/hoteltagprofile.png?alt=media&token=0b23ae71-8bb0-4f2c-a838-237ae6391a38',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 115.0,
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        color: HexColor('#FEED5F'),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                                MediaQuery.of(context).size.width, 98.0)),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 145,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                snapshot.data['photoUrl'].toString(),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: selectImage,
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
                        sBoxW10,
                        Text('Edit Profie Pic',
                            style: TextStyle(
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ),
                ),
                sBoxH30,

                Center(
                  child: Text(
                    snapshot.data['firstName'],
                    style: username,
                  ),
                ),
                sBoxH10,
                Container(
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
                        imageUrl: Tag[snapshot.data['userType']].toString(),
                        height: 20,
                      ),
                      sBoxW10,
                      Text(snapshot.data['userType'],
                          style: TextStyle(
                            fontSize: 13,
                          )),
                    ],
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
                sBoxH10,
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
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("isLoggedIn", false);
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
