import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview/models/user.dart';
import 'package:flutter_interview/screens/add_user_page.dart';
import 'package:flutter_interview/screens/item_card.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home-page";
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  var pos;
  String nearBy = "Near By";
  bool isClickNearBy = false;
  bool isGetLocation = false;

  @override
  void initState() {
    super.initState();
  }

  getLocation() async {
    Location location = new Location();
    pos = await location.getLocation();
    setState(() {
      isGetLocation = true;
    });
  }

  Stream<List<User>> fetchUserByLocation() {
    final firestore = FirebaseFirestore.instance;
    Geoflutterfire geo = Geoflutterfire();

    double lat = pos.latitude;
    double lng = pos.longitude;

    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    var collectionReference = firestore.collection('users');

    var stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: 30000, field: 'position')
        .map((snapshot) =>
            snapshot.map((e) => User.fromJson(e.data())).toList());


    return stream;
  }

  Stream<List<User>> getAllUsers() {
    var stream = FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

    return stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          elevation: 3.0,
          centerTitle: true,
          titleSpacing: 15,
          title: Text(
            "All Users",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600),
          ),
        ),
        body: isLoading
            ? SizedBox()
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AddUserPage.routeName);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Text(
                              "Add New User",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            isClickNearBy = !isClickNearBy;
                            if (isClickNearBy) {
                              await getLocation();
                              nearBy = "Normal";
                            }else{
                              nearBy = "Near By";
                            }
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Text(
                              "$nearBy",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: isClickNearBy && isGetLocation
                          ? StreamBuilder<List<User>>(
                              stream: fetchUserByLocation(),
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  final users = snapshot.data;
                                  return ListView.builder(
                                    itemCount: users.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: EdgeInsets.only(top: 10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: ItemCard(user: users[index]));
                                    },
                                  );
                                }
                              })
                          : StreamBuilder<List<User>>(
                              stream: getAllUsers(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Somthing went wrong!');
                                } else if (snapshot.hasData) {
                                  final users = snapshot.data;

                                  if (users != null) {
                                    return ListView.builder(
                                      itemCount: users.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      padding: EdgeInsets.only(top: 10),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child:
                                                ItemCard(user: users[index]));
                                      },
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              })),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  //   child: ListView.builder(
                  //     itemCount: 10,
                  //     shrinkWrap: true,
                  //     primary: false,
                  //     padding: EdgeInsets.only(top: 10),
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               vertical: 10, horizontal: 10),
                  //           child: ItemCard(userId: index));
                  //     },
                  //   ),
                  // )
                ])));
  }

  Widget buildUser(User user) => ListTile(
        isThreeLine: true,
        leading: CircleAvatar(
          child: Text('F'),
        ),
        title: Text(user.name),
        subtitle: RichText(
          textAlign: TextAlign.start,
          maxLines: 3,
          overflow: TextOverflow.fade,
          text: TextSpan(
            style: TextStyle(
                height: 1.5,
                fontSize: 15,
                letterSpacing: 0.8,
                color: Colors.black,
                fontWeight: FontWeight.w500),
            children: <TextSpan>[
              TextSpan(
                text: user.phone,
                style: TextStyle(),
              ),
              TextSpan(
                text: "Location",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
}
