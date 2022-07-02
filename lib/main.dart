import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_interview/common/app_routes.dart';
import 'package:flutter_interview/screens/splash_page.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Test',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: SplashPage(),
        routes: AppRoutes.routes,
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: child,
          );
        },
    );
  }
}