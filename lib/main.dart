import 'package:artistry_app/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 812), 
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Splashscreen(),
        );
      },
    ),
  );
}