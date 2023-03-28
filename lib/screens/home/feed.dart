import 'package:avail_itech_hackfest/screens/home/post_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/textstyle.dart';

class HomeFeed extends StatefulWidget {
  String postTag;
  HomeFeed({super.key, required this.postTag});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('feeds')
              .where('tag', isEqualTo: widget.postTag)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.yellow));
            }
            // ignore: sized_box_for_whitespace
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostInfo(
                                        docId: snapshot
                                            .data.docs[index].reference.id,
                                      )));
                        },
                        child: Card(
                          margin: const EdgeInsets.only(top: 10),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data.docs[index]['uid'])
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot2) {
                                    if (!snapshot2.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.black));
                                    }
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                snapshot2.data['photoUrl']),
                                      ),
                                      title: Text(
                                        snapshot.data.docs[index]['name'],
                                        style: username,
                                      ),
                                    );
                                  },
                                ),
                                sBoxH10,
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data.docs[index]
                                        ['photoUrl'],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 100, bottom: 100),
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              color: Colors.yellow)),
                                    ),
                                  ),
                                ),
                                sBoxH10,
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                      snapshot.data.docs[index]['content'],
                                      style:
                                          TextStyle(color: black, fontSize: 15),
                                      textScaleFactor: 1.2),
                                ),
                                sBoxH5,
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    '50 Mins ago',
                                    style: TextStyle(color: HexColor('767676')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  );
                });
          }),
    );
  }
}
