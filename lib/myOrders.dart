import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/checkStatus.dart';

class Orders extends StatefulWidget {
 Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final List<Map<String, dynamic>> proDetail= [
    {'image': 'images/catPaintings/paint1.jpg', 'name': ' "Her Eyes" ', 'price' : '\$4,000','artist':'Simon'},
    {'image': 'images/catPhotography/pho1.jpg', 'name': ' "Scooter" ', 'price' : '\$110','artist':'Cade'}
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              Text('My Orders'),
              SizedBox(width: 8.w),
              Icon(Icons.favorite, size: 14.r),
            ],
          ),
        ),
        body: SingleChildScrollView(
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
                        offset: Offset(0, 4),
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
                              padding: EdgeInsets.only(top: 15, bottom: 8),
                              child: Text(proDetail[0]['name'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                    ),
                            ),
                            Text('Artist : ${proDetail[0]['artist']}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[700],
                                  )
                                  ),
                                  SizedBox(height: 4.h,),
                            Text('Price : ${proDetail[0]['price']}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  )
                                  ),
                                  SizedBox(height: 8.h,),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 32,
                                    child: TextButton(
                                      onPressed: () {
                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderStatusPage()));
                                      },
                                      child: Text(
                                        'Check Status',
                                        style: TextStyle(fontSize: 13.sp), 
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                
                              ],
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
                        offset: Offset(0, 4),
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
                            Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 8),
                              child: Text(proDetail[1]['name'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                    ),
                            ),
                            Text('Artist : ${proDetail[1]['artist']}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[700],
                                  )
                                  ),
                                  SizedBox(height: 4.h,),
                            Text('Price : ${proDetail[1]['price']}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  )
                                  ),
                                  SizedBox(height: 8.h,),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 32,
                                    child: TextButton(
                                      onPressed: () {
                                        
                                        
                                      },
                                      child: Text(
                                        'Check Status',
                                        style: TextStyle(fontSize: 13.sp), 
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],  
          ),
        ),
       
      ),
    );
  }
}