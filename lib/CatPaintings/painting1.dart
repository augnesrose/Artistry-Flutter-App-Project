import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/bottomnav/addtocart.dart';
import 'package:artistry_app/home.dart';



class Product1 extends StatefulWidget {
  Product1({super.key});

  @override
  State<Product1> createState() => _Product1State();

   final List<Map<String, dynamic>> proDetail= [
    {'image': 'images/catPaintings/paint1.jpg', 'name': ' "Her Eyes" ', 'price' : '\$4,000',
      'description':'"Her Eyes" captures the depth and mystery of a woman\'s gaze, inviting the viewer into a world of untold stories and emotions. The painting\'s focus on the eyes highlights their expressive power, reflecting vulnerability, strength, and an unspoken connection to the world around her. Each brushstroke brings life to the subtle nuances of her expression, allowing the eyes to tell a story far beyond the canvas.'
    }
  ];
  final List<Map<String, dynamic>> artDetail= [
    {'image': 'images/artistimages/artistpa1.jpg', 'artist':'Simon',
      'artistdet':'Simon is a talented artist known for his captivating use of color and emotion. His work explores the depths of human expression, often focusing on the intricate details that tell profound stories.'
    }  
  ];
  final List<Map<String, dynamic>> Detail= [
    {
      'medium':'Oil',
      'material':'Canvas',
      'width':'30 in',
      'height':'20 in',
    }  
  ];
}

class _Product1State extends State<Product1> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  widget.proDetail[0]['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.h,),
              Padding(
                padding:  EdgeInsets.only(left: 16),
                child: Text(widget.proDetail[0]['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
        
                ),
              ),
               SizedBox(height: 10.h,),
              Padding(
                padding: const EdgeInsets.only(left:16),
                child: Text(widget.artDetail[0]['artist'],
                style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20.h,),
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
                      ]
                    ),
                  ),
                  SizedBox(height: 30.h,)
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          elevation: 10,
          
          child: Row(
            children: [
              SizedBox(width: 10.w,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(widget.proDetail[0]['price'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PlayFair'
                    ),
                  ),

              ),
              SizedBox(
                width: 20.w,
              ),
              ElevatedButton.icon(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(initialIndex : 3, )));
                }, 
                icon: Icon(Icons.shopping_cart_rounded), 
                label:Text('Add to Cart',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600
                      ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20)
                ),
                ),
            ],
          ),
        
        ),
      ),
    );
  }
}