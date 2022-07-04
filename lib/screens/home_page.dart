import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview/models/user.dart';
import 'package:flutter_interview/screens/add_user_page.dart';
import 'package:flutter_interview/screens/item_card.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:math' as Math;

double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(deg2rad(lat1)) *
          Math.cos(deg2rad(lat2)) *
          Math.sin(dLon / 2) *
          Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}

double deg2rad(deg) {
  return deg * (Math.pi / 180);
}

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
    getLocation();
  }

  getLocation() async {
    Location location = new Location();
    pos = await location.getLocation();
    fetchUserByLocation();
    setState(() {
      isGetLocation = true;
    });
  }

  Stream<List<User>> fetchUserByLocation() {
    final fireStore = FirebaseFirestore.instance;
    Geoflutterfire geo = Geoflutterfire();

    double lat = pos.latitude;
    double lng = pos.longitude;

    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    var collectionReference = fireStore.collection('users');

    var stream = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map(
            (snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())))
        .toList();

    List<User> users = [];

    getAllUsers().then((value) => value.forEach((user) {
          var km = getDistanceFromLatLonInKm(
              center.latitude, center.longitude, user.lat, user.long);
          user.distance = km;
          users.add(user);
        }));

    print("users ${users.length}");

    users.sort((a, b) {
      return a.distance.compareTo(b.distance);
    });
    // Geolocator.distanceBetween(center.latitude,center.longitude, geo.latitude,destination.longitude);
    //
    // (center: center, radius: 30000, field: 'position')
    //     .map((snapshot) =>
    //         snapshot.map((e) => User.fromJson(e.data())).toList());

    return Stream.value(users);
  }

  Future<List<User>> getAllUsers() async {
    List<User> users = [];

    await FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .forEach((snapshot) {
      // users = snapshot.docs.map((doc) => User.fromJson(doc.data()));
      users = usersFromJson(json.encode(snapshot.docs));
    });

    return users;
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isGetLocation
                        ? StreamBuilder<List<User>>(
                            stream: fetchUserByLocation(),
                            builder: (BuildContext context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                    height: MediaQuery.of(context).size.height -
                                        150,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator());
                              } else {
                                final users = snapshot.data;
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: ListView.builder(
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
                                  ),
                                );
                              }
                            })
                        : Container(
                            height: MediaQuery.of(context).size.height - 150,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator()),
                  ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddUserPage.routeName);
        },
        backgroundColor: Colors.cyan,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
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
