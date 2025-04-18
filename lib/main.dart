import 'package:artistry_app/get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:artistry_app/splashscreen.dart';
import 'package:artistry_app/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure the app runs only in portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Check if token exists
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(
    ScreenUtilInit(
      designSize: Size(360, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: token != null ? Home() : Splashscreen(), // Navigate based on token
        );
      },
    ),
  );
}
