import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Product1 extends StatefulWidget {
  Product1({super.key});

  final List<Map<String, dynamic>> proDetail = [
    {
      'image': 'images/catCollage/cola1.jpg',
      'name': ' "Child" ',
      'price': '\$4,000',
      'description': '"Her Eyes" captures the depth and mystery of a woman\'s gaze, inviting the viewer into a world of untold stories and emotions. The painting\'s focus on the eyes highlights their expressive power, reflecting vulnerability, strength, and an unspoken connection to the world around her. Each brushstroke brings life to the subtle nuances of her expression, allowing the eyes to tell a story far beyond the canvas.'
    }
  ];
  final List<Map<String, dynamic>> artDetail = [
    {
      'image': 'images/artistimages/artistco1.jpg',
      'artist': 'Gamora Salas',
      'artistdet': 'Gamora is a talented artist known for his captivating use of color and emotion. His work explores the depths of human expression, often focusing on the intricate details that tell profound stories.'
    }
  ];
  final List<Map<String, dynamic>> Detail = [
    {
      'medium': 'Oil',
      'material': 'Canvas',
      'width': '30 in',
      'height': '20 in',
    }
  ];

  @override
  State<Product1> createState() => _Product1State();
}

class _Product1State extends State<Product1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'productImage',
                    child: Image.asset(
                      widget.proDetail[0]['image'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      widget.proDetail[0]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      widget.artDetail[0]['artist'],
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'About the Painting',
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontFamily: 'PlayFair',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      widget.proDetail[0]['description'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'About the Artist',
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontFamily: 'PlayFair',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(widget.artDetail[0]['image']),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      widget.artDetail[0]['artistdet'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontFamily: 'PlayFair',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Medium: ${widget.Detail[0]['medium']}', 
                             style: TextStyle(fontSize: 16.sp)),
                        Text('Material: ${widget.Detail[0]['material']}', 
                             style: TextStyle(fontSize: 16.sp)),
                        Text('Height: ${widget.Detail[0]['height']}', 
                             style: TextStyle(fontSize: 16.sp)),
                        Text('Width: ${widget.Detail[0]['width']}', 
                             style: TextStyle(fontSize: 16.sp)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: FadeTransition(
          opacity: _fadeAnimation,
          child: BottomAppBar(
            color: Colors.black,
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Text(
                    widget.proDetail[0]['price'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PlayFair',
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.shopping_cart_rounded),
                      label: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 20.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}