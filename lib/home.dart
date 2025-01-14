import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/bottomnav/addtocart.dart';
import 'package:artistry_app/bottomnav/profile.dart';
import 'package:artistry_app/bottomnav/category.dart';
import 'package:artistry_app/bottomnav/homescreen.dart';


class Home extends StatefulWidget {
   final int initialIndex;
  Home({super.key, this.initialIndex=0,});

 

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int myCurrentIndex;
  List<Widget> pages=[
    HomeScreen(),
    Categories(),
    Profile(),
    AddToCart(),
    
  ];
  @override
  void initState() {
    super.initState();
    // Initialize the current index with the passed initialIndex
    myCurrentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              SizedBox(
                height: 300.h,
                width: 150.w,
                child: Image.asset('images/ARTISTRY-nobg.png',height:200,))
            ],
          ),
      
        ),
        body: IndexedStack(
          index: myCurrentIndex, // Display the page corresponding to the current index
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: myCurrentIndex, // Highlight the current tab
          onTap: (index) {
            setState(() {
              myCurrentIndex = index; // Change the current index
            });
          },
          items: [
          BottomNavigationBarItem(icon:Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon:Icon(Icons.dashboard),label: 'Category'),
          BottomNavigationBarItem(icon:Icon(Icons.person),label: 'Profile'),
          BottomNavigationBarItem(icon:Icon(Icons.shopping_cart),label: 'Cart')
        ],
         selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
        )
      ),
    );
  }
}