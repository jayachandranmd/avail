import 'package:avail_itech_hackfest/screens/home/feed.dart';
import 'package:avail_itech_hackfest/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/colors.dart';
import '../../utils/textstyle.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late bool isLoggedIn;
  getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final showHome = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isLoggedIn = showHome;
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    getLoginInfo();
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [HexColor('#FEED5F'), HexColor('#FFFFFF')])),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: vpad12 + hpad20,
                      child: Text(
                        'Recent',
                        style: textFieldTitle,
                      ),
                    ),
                    //Contributors Card
                    Padding(
                      padding: hpad20,
                      child: SizedBox(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('feeds')
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              ));
                            }
                            return SizedBox(
                              height: 150,
                              child: Swiper(
                                physics: const ScrollPhysics(),
                                autoplay: true,
                                scale: 0.7,
                                autoplayDisableOnInteraction: true,
                                autoplayDelay: 3000,
                                itemCount: snapshot.data.docs.length < 5
                                    ? snapshot.data.docs.length
                                    : 5,
                                itemBuilder: (BuildContext context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      side: BorderSide(color: yellow, width: 1),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: hpad12 + vpad4,
                                          child: Text(
                                            snapshot.data.docs[index]
                                                ['content'],
                                            style: contributorText,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8, left: 4),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.location_on,
                                                      color: black),
                                                  Text(
                                                    snapshot.data.docs[index]
                                                        ['city'],
                                                    style: subtitle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (snapshot.data.docs[index]
                                                    ['tag'] ==
                                                'food')
                                              ClipRect(
                                                  clipBehavior: Clip.antiAlias,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/foodCC.png?alt=media&token=70614cf5-dd1b-459d-94b3-06f822b96459",
                                                    height: 80,
                                                  )),
                                            if (snapshot.data.docs[index]
                                                    ['tag'] ==
                                                'clothes')
                                              ClipRect(
                                                  clipBehavior: Clip.antiAlias,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/clothesCC.png?alt=media&token=46708efd-979a-4eb5-88f5-bde1faedf28d",
                                                    height: 80,
                                                  )),
                                            if (snapshot.data.docs[index]
                                                    ['tag'] ==
                                                'volunteer')
                                              ClipRect(
                                                  clipBehavior: Clip.antiAlias,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/volunteerCC.png?alt=media&token=3748d8f6-20e2-44b2-aa3b-c37806fb213c",
                                                    height: 80,
                                                  )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ]),
            ),
            Container(
              decoration: BoxDecoration(color: black),
              child: TabBar(
                tabs: [
                  Tab(text: "Food"),
                  Tab(text: "Clothes"),
                  Tab(text: "Volunteer"),
                ],
                controller: _tabController,
                labelColor: yellow,
                unselectedLabelColor: white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: UnderlineTabIndicator(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: yellow, width: 3)),
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                HomeFeed(postTag: 'food'),
                HomeFeed(postTag: 'clothes'),
                HomeFeed(postTag: 'volunteer'),
              ]),
            )
          ],
        ),
      ),
    );
  }

  void commonShare(String message) {
    Share.share(message);
  }
}
