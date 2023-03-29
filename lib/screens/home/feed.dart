import 'package:avail_itech_hackfest/screens/home/post_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/textstyle.dart';
import '../../utils/time_ago.dart';

class HomeFeed extends StatefulWidget {
  final String postTag;
  HomeFeed({super.key, required this.postTag});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  Map<String, String> postTag = {
    'NGO':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/ngoprofiletag.png?alt=media&token=021945ea-1f27-4ba4-b0dc-776bb832a820',
    'Individual':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/individualtag.png?alt=media&token=6795a440-41bb-41fc-89a3-cc9cb1e72f6b',
    'Hotels':
        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/hoteltagprofile.png?alt=media&token=0b23ae71-8bb0-4f2c-a838-237ae6391a38',
  };

  String? timeagoText;
  /*updateTimeAgo() async {
    
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
  }*/

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('feeds')
              .where('tag', isEqualTo: widget.postTag)
              .snapshots(),
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
                                      trailing: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.7,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: yellow),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: postTag[snapshot2
                                                      .data['userType']]
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
                                  padding: hpad8,
                                  child: ListTile(
                                    title: Text(
                                        snapshot.data.docs[index]['content'],
                                        style: TextStyle(
                                            color: black, fontSize: 15),
                                        textScaleFactor: 1.2),
                                    subtitle: Text(
                                      snapshot.data.docs[index]['timeago'],
                                      style:
                                          TextStyle(color: HexColor('767676')),
                                    ),
                                    trailing: RichText(
                                      text: TextSpan(
                                          text: snapshot.data.docs[index]
                                                  ['city'] +
                                              ", ",
                                          style: contributorText,
                                          children: [
                                            TextSpan(
                                                text: snapshot.data.docs[index]
                                                    ['city'],
                                                style: contributorText)
                                          ]),
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(left: 20),
                                //   child: Text(
                                //       snapshot.data.docs[index]['content'],
                                //       style:
                                //           TextStyle(color: black, fontSize: 15),
                                //       textScaleFactor: 1.2),
                                // ),
                                // sBoxH5,
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 20),
                                //   child: Text(
                                //     '50 Mins ago',
                                //     style: TextStyle(color: HexColor('767676')),
                                //   ),
                                // ),
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
