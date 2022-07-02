import 'package:flutter/cupertino.dart';
import 'package:flutter_interview/screens/add_user_page.dart';
import 'package:flutter_interview/screens/home_page.dart';
import 'package:flutter_interview/screens/map_view.dart';
import 'package:flutter_interview/screens/splash_page.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> _routes = {
    SplashPage.routeName: (ctx) => SplashPage(),
    HomePage.routeName: (ctx) => HomePage(),
    AddUserPage.routeName: (ctx) => AddUserPage(),
    MapViewPage.routeName: (ctx) => MapViewPage(),
  };

  static get routes => _routes;
}
