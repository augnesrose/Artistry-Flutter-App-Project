import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/placeorder.dart';

class AddToCart extends StatelessWidget {
  AddToCart({super.key});
  final List<Map<String, dynamic>> proDetail= [
    {'image': 'images/catPaintings/paint1.jpg', 'name': ' "Her Eyes" ', 'price' : '\$4,000','artist':'Simon'},
    {'image': 'images/catPhotography/pho1.jpg', 'name': ' "Scooter" ', 'price' : '\$110','artist':'Cade'}
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        
        body:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0,4),
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            proDetail[0]['image'],
                            width: 120.h,
                            height: 120.h,
                            fit: BoxFit.cover,
                            ),
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 15,bottom: 8),
                              child: Text(proDetail[0]['name'],
                                    style:TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                    ),
                            ),
                            Text('Artist : ${proDetail[0]['artist']}',
                                  style:TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  )
                                  ),
                                  SizedBox(height: 4.h,),
                            Text('Price : ${proDetail[0]['price']}',
                                  style:TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  )
                                  ),
                                  SizedBox(height: 8.h,),
                            SizedBox(
                              height: 32,
                              child: TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Remove',
                                                      style: TextStyle(fontSize: 14.sp), 
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.black,
                                                      foregroundColor: Colors.white,
                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), 
                                                      shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(6),
                                                            ),
                                                         ),
                                                      ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
          
               SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0,4),
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            proDetail[1]['image'],
                            width: 120.h,
                            height: 120.h,
                            fit: BoxFit.cover,
                            ),
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(https://github.com/Augnes2002/Flutter-Project-Artistry-mobile-App.git
                              padding: EdgeInsets.only(top: 15,bottom: 8),
                              child: Text(proDetail[1]['name'],
                                    style:TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                    ),
                            ),
                            Text('Artist : ${proDetail[1]['artist']}',
                                  style:TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  )
                                  ),
                                  SizedBox(height: 4.h,),
                            Text('Price : ${proDetail[1]['price']}',
                                  style:TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  )
                                  ),
                                  SizedBox(height: 8.h,),
                            SizedBox(
                              height: 32,
                              child: TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Remove',
                                                      style: TextStyle(fontSize: 14.sp), 
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.black,
                                                      foregroundColor: Colors.white,
                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), 
                                                      shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(6),
                                                            ),
                                                         ),
                             ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0,4),
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text('Price Details',
                        style: TextStyle(
                          color:Color.fromARGB(255, 212, 85, 108),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500
                        ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text('Total Quantity  :   2',
                        style: TextStyle(
                          color:Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400
                        ),
                        ),
                      ),
                       SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Row(
                          children: [
                            Text('Shipping Charge  :',
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400
                            ),
                            ),
                            SizedBox(width: 10.w,),
                            Text('Free',
                            style: TextStyle(
                              color:Color.fromARGB(255, 212, 85, 108),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500
                            ),
                            ),
                          ],
                        ),
                      ),
                       SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Row(
                          children: [
                            Text('Total Price  : ',
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400
                            ),
                            ),
                             SizedBox(
                              width: 10.w,
                            ),
                            Text('\$4,110',
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600
                            ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                )
          
            ],  
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceOrder()));
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Proceed to Pay',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
}