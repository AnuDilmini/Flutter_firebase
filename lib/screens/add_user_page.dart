import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview/common/shared_pref.dart';
import 'package:flutter_interview/common/snackbar_dialog.dart';
import 'package:flutter_interview/models/user.dart';
import 'package:flutter_interview/screens/map_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class AddUserPage extends StatefulWidget {
  static const routeName = "/address-page";
  const AddUserPage({Key key}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  TextEditingController cityController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String locationSelect = "Select Location";
  bool isLocationSelect = false;
  bool isAddUser = false;
  String location = "";
  double lat,long;
  String chosenGender;

  @override
  void initState() {
    super.initState();
  }

  validateForm() async {
    if (nameController.text.isEmpty) {
      SnackBarDialog.showSnackBar(context, "User Name is required !",
          isNormal: false);
      return;
    } else if (chosenGender == null) {
      SnackBarDialog.showSnackBar(context, "Gender is required !",
          isNormal: false);
      return;
    } else if (phoneController.text.isEmpty) {
      SnackBarDialog.showSnackBar(context, "Phone number is required !",
          isNormal: false);
      return;
    } else if (!isLocationSelect) {
      SnackBarDialog.showSnackBar(context, "Location is required !",
          isNormal: false);
    } else if (isLocationSelect) {
      List<double> location = await SharedPreferencesClass().getLocation();
      lat = location[0];
      long = location[1];

      if (lat == null || long == null) {
        SnackBarDialog.showSnackBar(context, "Location is required !",
            isNormal: false);
      } else {
        await _getAddressFromLatLng();

        setState(() {
          isAddUser = true;
        });
        createUser(
            name: nameController.text,
            gender: chosenGender,
            phone: phoneController.text,
            lat: lat,
            long: long);
      }
    }
  }

  Future createUser(
      {String name,
      String phone,
      String gender,
      double lat,
      double long}) async {
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint point = geo.point(latitude: lat, longitude: long);


    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final user = User(
        id: docUser.id,
        name: name,
        address: locationSelect,
        gender: gender,
        phone: phone,
        lat: lat,
        long: long,
        position: point.data
    );

    final json = user.toJson();

    await docUser.set(json);
    setState(() {
      isAddUser = false;
    });
    SnackBarDialog.showSnackBar(context, "User Added", isNormal: true);
  }

  _getAddressFromLatLng() async {
    try {

      List<Placemark> placemarks = await placemarkFromCoordinates(
          lat,
          long
      );

      Placemark place = placemarks[0];

      setState(() {
        locationSelect = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 1.2,
          centerTitle: false,
          titleSpacing: 15,
          title: Text(
            "Add User",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Details",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blueGrey,
                        ),
                      ),
                      child: TextField(
                        controller: nameController,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textCapitalization: TextCapitalization.sentences,
                        textAlignVertical: TextAlignVertical.center,
                        autofocus: false,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blueGrey,
                        ),
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textCapitalization: TextCapitalization.sentences,
                        autofocus: false,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        locationSelect = "Location Selected";
                        isLocationSelect = true;
                        Navigator.pushNamed(context, MapViewPage.routeName);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height * 0.05,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blueGrey,
                          ),
                        ),
                        child: Text(
                          locationSelect,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blueGrey,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: chosenGender,
                        elevation: 0,
                        underline: Container(),
                        isExpanded: true,
                        style: TextStyle(
                            color: Colors.black, fontSize: 15),
                        items: <String>[
                          'Male', 'Female', 'Other',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            chosenGender = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        validateForm();
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.058,
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: isAddUser
                              ? CircularProgressIndicator(
                                  semanticsLabel: 'Linear progress indicator',
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  "Submit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ]),
            )));
  }
}
