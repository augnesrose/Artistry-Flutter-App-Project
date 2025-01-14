import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/productfinalization.dart';
class PlaceOrder extends StatelessWidget {
  PlaceOrder({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              Text('ADDRESS',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
              ),
              SizedBox(
                width: 15.w,
              ),
              
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductConfirm()));
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
                'Add Address',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:18.h ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Row(
                  children: [
                    Text('Contact Details',
                    style:TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    )
                    ),
                    
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [ 
                        TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Name',
                                          prefixIcon: Icon(
                                          Icons.man_2_outlined,
                                          color: Colors.black,
                                        ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16
                                      )
                                        ),
                                      ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Mobile No.',
                                          prefixIcon: Icon(
                                          Icons.mobile_friendly,
                                          color: Colors.black,
                                        ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16
                                      )
                                        ),
                                      ),

                      ],
                    ),
                  ),
                ),
                ),
                 SizedBox(height:18.h ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Row(
                  children: [
                    Text('Address',
                    style:TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    )
                    ),
                   
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [ 
                        TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Pincode',
                                          prefixIcon: Icon(
                                          Icons.pin_drop,
                                          color: Colors.black,
                                        ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16
                                      )
                                        ),
                                      ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Address(House No.,Building,Street,Area)',
                                          prefixIcon: Icon(
                                          Icons.home,
                                          color: Colors.black,
                                        ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16
                                      )
                                        ),
                                      ),

                                      SizedBox(
                            height: 10.h,
                          ),
                          TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Locality/Town',
                                          prefixIcon: Icon(
                                          Icons.location_city,
                                          color: Colors.black,
                                        ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16
                                      )
                                        ),
                                      ),
                                        SizedBox(
                            height: 10.h,
                          ),
                          TextField(
                                        decoration: InputDecoration(
                                          hintText: 'District',
                                          prefixIcon: Icon(
                                          Icons.map,
                                          color: Colors.black,
                                        ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16
                                      )
                                        ),
                                      ),
                                        SizedBox(
                            height: 10.h,
                          ),
                          TextField(
                                        decoration: InputDecoration(
                                          hintText: 'State',
                                          prefixIcon: Icon(
                                          Icons.flag,
                                          color: Colors.black,
                                        ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16
                                      )
                                        ),
                                      ),

                      ],
                    ),
                  ),
                ),
                )

            ],
          ),
        ),
      ),
    );
  }
}