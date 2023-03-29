import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/textstyle.dart';
import '../../utils/time_ago.dart';

class PostInfo extends StatefulWidget {
  final String docId;
  PostInfo({Key? key, required this.docId}) : super(key: key);

  @override
  State<PostInfo> createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  Map<String, String> postTag = {
    'NGO':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/ngoprofiletag.png?alt=media&token=021945ea-1f27-4ba4-b0dc-776bb832a820',
    'Individual':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/individualtag.png?alt=media&token=6795a440-41bb-41fc-89a3-cc9cb1e72f6b',
    'Hotels':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/hoteltagprofile.png?alt=media&token=0b23ae71-8bb0-4f2c-a838-237ae6391a38',
  };
  String? timeagoText;
  updateTimeAgo() async {
    final col = await FirebaseFirestore.instance
        .collection('feeds')
        .doc(widget.docId)
        .get();
    setState(() {
      timeagoText = timeAgo(col.data()!['date'].toString());
    });
    await FirebaseFirestore.instance
        .collection('feeds')
        .doc(widget.docId)
        .update({'timeago': timeagoText.toString()});
  }

  @override
  void initState() {
    updateTimeAgo();
    print(timeagoText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 2,
        toolbarHeight: 70,
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
              width: 110,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: HexColor('#FEED5F'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                child: const Text('Share',
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
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('feeds')
                .doc(widget.docId)
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
                  sBoxH20,
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(snapshot.data['uid'])
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot2) {
                      if (!snapshot2.hasData) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.black));
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider(
                              snapshot2.data['photoUrl']),
                        ),
                        trailing: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 3.7,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: yellow),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: postTag[snapshot2.data['userType']]
                                    .toString(),
                                height: 20,
                              ),
                              sBoxW10,
                              Text(snapshot2.data['userType'],
                                  style: TextStyle(
                                    fontSize: 13,
                                  )),
                            ],
                          ),
                        ),
                        title: Text(
                          snapshot.data['name'],
                          style: username,
                        ),
                      );
                    },
                  ),
                  sBoxH10,
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data['photoUrl'],
                      )),
                  sBoxH10,
                  Padding(
                    padding: hpad8,
                    child: ListTile(
                      title: Text(snapshot.data['content'],
                          style: TextStyle(color: black, fontSize: 15),
                          textScaleFactor: 1.2),
                      subtitle: Text(
                        snapshot.data['timeago'],
                        style: TextStyle(color: HexColor('767676')),
                      ),
                      trailing: RichText(
                        text: TextSpan(
                            text: snapshot.data['city'] + ', ',
                            style: contributorText,
                            children: [
                              TextSpan(
                                  text: snapshot.data['state'],
                                  style: contributorText)
                            ]),
                      ),
                    ),
                  ),
                  sBoxH5,
                  Divider(
                    thickness: 1,
                  ),
                  sBoxH10,
                  snapshot.data['tag'].toString() == 'volunteer'
                      ? Padding(
                          padding: hpad20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Volunteers",
                                style: textFieldTitle,
                              ),
                              sBoxH10,
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: yellow, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor('fffdef')),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data['volunteer'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: black),
                                    ),
                                    Icon(
                                      Icons.people,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                              sBoxH20,
                            ],
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: hpad20,
                    child: Text(
                      'Location',
                      style: textFieldTitle,
                    ),
                  ),
                  sBoxH20,
                  Padding(
                    padding: hpad20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            var mobile = snapshot.data['contact'];
                            final Uri phoneNumber = Uri.parse('tel:+91$mobile');
                            print(await canLaunchUrl(phoneNumber));
                            launchUrl(phoneNumber);
                          },
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: yellow, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('fffdef')),
                            child: Column(
                              children: [
                                Icon(Icons.add_ic_call),
                                sBoxH10,
                                Text(
                                  'Call',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: black),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            var mobile = snapshot.data['contact'];
                            final Uri whatsapp =
                                Uri.parse('whatsapp://send?phone=+91$mobile');
                            launchUrl(whatsapp);
                          },
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: yellow, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('fffdef')),
                            child: Column(
                              children: [
                                Image.network(
                                    alignment: Alignment.centerRight,
                                    height: 21,
                                    'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/whatsapp.png?alt=media&token=fba174f0-dd72-41e4-9b06-d28281c41189'),
                                sBoxH10,
                                Text(
                                  'Whatsapp',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: black),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            commonShare(snapshot.data['content'].toString());
                          },
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: yellow, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('fffdef')),
                            child: Column(
                              children: [
                                Icon(Icons.share),
                                sBoxH10,
                                Text(
                                  'Share',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  sBoxH10,
                  sBoxH10,
                  snapshot.data['tag'].toString() == '(volunteer)'
                      ? Padding(
                          padding: hpad20,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: yellow),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Apply',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: black),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              );
            }),
      ),
    ));
  }

  void commonShare(String message) {
    Share.share(message);
  }
}
