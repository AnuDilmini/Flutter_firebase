import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesClass {
  SharedPreferences preferences;

  Future<bool> saveLocation({double lat, double long}) async{
    preferences = await SharedPreferences.getInstance();
    preferences.setDouble("lat", lat);
    preferences.setDouble("long", long);
    return true;
  }

  Future<List<double>> getLocation() async{
    preferences = await SharedPreferences.getInstance();
    double lat = preferences.getDouble("lat");
    double long = preferences.getDouble("long");

    print("lat $lat ,,,, long $long");
    return [lat, long];

  }







}