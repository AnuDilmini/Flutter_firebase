// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:geoflutterfire/geoflutterfire.dart';

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.gender,
    this.lat,
    this.long,
    this.position
  });

  String id;
  String name;
  String address;
  String phone;
  String gender;
  double lat;
  double long;
  dynamic position;
  double distance;


  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    address: json["address"] == null ? null : json["address"],
    phone: json["phone"] == null ? null : json["phone"],
    gender: json["gender"] == null ? null : json["gender"],
    lat: json["lat"] == null ? null : json["lat"],
    long: json["long"] == null ? null : json["long"],
    position: json["postion"] == null ? null : json["postion"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "address": address == null ? null : address,
    "phone": phone == null ? null : phone,
    "gender": gender == null ? null : gender,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "position": position == null ? null : position,
  };
}
