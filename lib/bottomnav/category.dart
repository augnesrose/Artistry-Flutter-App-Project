import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/Category/abstract.dart';
import 'package:artistry_app/Category/collage.dart';
import 'package:artistry_app/Category/digital.dart';
import 'package:artistry_app/Category/painting.dart';
import 'package:artistry_app/Category/photography.dart';
import 'package:artistry_app/Category/sculpture.dart';
import 'package:artistry_app/Category/sketches.dart';
import 'package:artistry_app/Category/poster.dart';

class Categories extends StatelessWidget {
  Categories({super.key});

  final List<Map<String, dynamic>> categories = [
    {'image': 'images/category/cat3.jpg', 'name': 'Paintings', 'page': Paintings('Paintings')},
    {'image': 'images/category/cat1.jpg', 'name': 'Photography', 'page': Paintings('Photography')},
    {'image': 'images/category/cat2.jpg', 'name': 'Sculpture', 'page': Paintings('Sculpture')},
    {'image': 'images/category/cat5.jpg', 'name': 'Collage', 'page': Paintings('Collage')},
    {'image': 'images/category/cat4.jpg', 'name': 'Digital Art', 'page': Paintings('Digital Art')},
    {'image': 'images/category/cat8.jpg', 'name': 'Abstract', 'page': Paintings('Abstract')},
    {'image': 'images/category/cat7.jpg', 'name': 'Posters', 'page': Paintings('Poster')},
    {'image': 'images/category/cat6.jpg', 'name': 'Sketches', 'page': Paintings('Sketches')},
    
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => categories[index]['page'],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Stack(
                          children: [
                            // Background Image
                            Positioned.fill(
                              child: Image.asset(
                                categories[index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Gradient Overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                    stops: [0.0, 0.3, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            // Category Text
                            Center(
                              child: Text(
                                categories[index]['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3.0,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}