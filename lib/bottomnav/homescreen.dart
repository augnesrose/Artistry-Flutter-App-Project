import 'package:artistry_app/Category/abstract.dart';
import 'package:artistry_app/Category/collage.dart';
import 'package:artistry_app/Category/digital.dart';
import 'package:artistry_app/Category/painting.dart';
import 'package:artistry_app/Category/photography.dart';
import 'package:artistry_app/Category/sculpture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> categories = [
    {'image': 'images/circularcarousel/cc1.jpg', 'name': 'Paintings', 'page': Paintings()},
    {'image': 'images/circularcarousel/cc2.jpg', 'name': 'Photography', 'page': Photography()},
    {'image': 'images/circularcarousel/cc3.jpg', 'name': 'Sculpture', 'page': Sculpture()},
    {'image': 'images/circularcarousel/cc4.jpg', 'name': 'Collage', 'page': Collage()},
    {'image': 'images/circularcarousel/cc5.jpg', 'name': 'Digital Art', 'page': DigitalArt()},
    {'image': 'images/circularcarousel/cc6.jpg', 'name': 'Abstract', 'page': AbstractArt()},

  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body:SingleChildScrollView(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
        
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w), // Adjust the horizontal padding
              child: SizedBox(
                height: 50.h, // Adjust the height of the search box
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 16.w,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                SizedBox(width: 16.w,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Top Categories',style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    
                  ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
           SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.map((category) {
        return Padding(
          padding: EdgeInsets.only(left: 16.w), // Add left padding for spacing
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => category['page']),
              );
            },
            child: SizedBox(
              width: 100.w, // Fixed width for each item
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: AssetImage(category['image']),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
            }).toList(),
          ),
        ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                SizedBox(width: 16.w,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('New Arrivals',style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    
                  ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
           Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 206, 189, 173), // Background color for the entire section
            borderRadius: BorderRadius.circular(15.r), // Rounded corners for background
            boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => category['page']),
                );
              },
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(category['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      category['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
            ),
          ),
        ),
        SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                SizedBox(width: 16.w,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Curators\' Choice',style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    
                  ),
                  ),
                ),
              ],
            ),
            Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color:Color.fromARGB(255, 208, 96, 117), // Background color for the entire section
            borderRadius: BorderRadius.circular(15.r), // Rounded corners for background
            boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => category['page']),
                );
              },
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(category['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      category['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
            ),
          ),
        )
          ],
          
        ),
      ),

    );
  }
}
