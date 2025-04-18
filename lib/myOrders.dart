import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/checkStatus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:artistry_app/home.dart';
import 'package:artistry_app/home.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Orders extends StatefulWidget {
  Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<dynamic> orderDetails = [];
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchOrderDetails();
  }
  
  Future<void> fetchOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if(token == null){
      print('Token is null');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final url = Uri.parse("http://192.168.67.52:3000/order/myOrders");
      final header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };
      final response = await http.get(url, headers: header);
      if(response.statusCode == 200) {
        print("Response Order: ${response.body}");
        final jsonResponse = json.decode(response.body);
        

        if (jsonResponse['orders'] != null && jsonResponse['orders'].isNotEmpty) {
          print("First order structure: ${jsonResponse['orders'][0]}");
        }
        
        setState(() {
          orderDetails = jsonResponse['orders'] ?? [];
          isLoading = false;
        });
      } else {
        print("Error status code: ${response.statusCode}");
        setState(() {
          orderDetails = [];
          isLoading = false;
        });
      }
    } catch(e) {
      print("Error fetching order details: $e");
      setState(() {
        orderDetails = [];
        isLoading = false;
      });
    }
  }
  
  
  int getOrderTotal(dynamic order) {
    if (order == null || order['productId'] == null) return 0;
    
    int price = 0;
    try {
     
      price = int.tryParse(order['productId']['price']?.toString() ?? '0') ?? 0;
      
     
      int shippingFee = int.tryParse(order['productId']['shippingFee']?.toString() ?? '0') ?? 0;
      price += shippingFee;
    } catch (e) {
      print("Error calculating price: $e");
    }
    return price;
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return WillPopScope(
      onWillPop: () async {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => Home(initialIndex: 2)),
      // );
      return true; // Prevents the default pop
    },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
             leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home(initialIndex: 2)),
              );
              // Prevents the default pop
            },
          ),
            title: Row(
              children: [
                Text('My Orders'),
                SizedBox(width: 8.w),
                Icon(Icons.favorite, size: 14.r),
              ],
            ),
          ),
          body: isLoading ? 
            Center(child: CircularProgressIndicator()) :
            orderDetails.isEmpty ? 
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 80.r, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text('No Orders Yet',
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.h),
                    Text('You have not placed any orders yet.',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                  ],
                ),
              ) :
              ListView.builder(
                itemCount: orderDetails.length,
                itemBuilder: (context, index) {
                  final order = orderDetails[index];
                 
                  final orderTotal = getOrderTotal(order);
                  
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: double.infinity,
                     
                      height: 150.h,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: order['productId'] != null && order['productId']['productImage'] != null ?
                                Image.network(
                                  "http://192.168.67.52:3000/uploads/${order['productId']['productImage']}",
                                  fit: BoxFit.cover,
                                  width: 100.h,
                                  height: 100.h,
                                  errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 100.h,
                                      height: 100.h,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                ) :
                                Container(
                                  width: 140.h,
                                  height: 140.h,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image_not_supported),
                                ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 4),
                                  child: Text(
                                    order['productId'] != null ? 
                                      (order['productId']['name'] ?? 'Unknown Product') : 
                                      'Unknown Product',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  'Artist: ' + (order['productId'] != null && 
                                             order['productId']['artistName'] != null ? 
                                             order['productId']['artistName'] : 'N/A'),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Price: \u20B9 $orderTotal',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                                SizedBox(height: 7.h),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 60,
                                      height: 40,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                            OrderStatusPage(orderId: order['_id'])
                                          ));
                                        },
                                        child: Text('Status',style: TextStyle(color:Colors.white,fontSize: 10.sp),),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              )
        ),
      ),
    );
  }
}