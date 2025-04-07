import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/CatPaintings/painting1.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Mywishlist extends StatefulWidget {
  Mywishlist({super.key});

  @override
  State<Mywishlist> createState() => _MywishlistState();
}

class _MywishlistState extends State<Mywishlist> {
  List<dynamic> wishlistDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlistProducts();
  }

  Future<void> fetchWishlistProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No token is available");
      return;
    }

    try {
      var url = Uri.parse("http://192.168.67.52:3000/wishlist/getWishlistProducts");
      var header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };

      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('wishlist')) {
          setState(() {
            wishlistDetails = jsonResponse['wishlist'];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error occurred: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> removeFromWishlist(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No token is available");
      return false;
    }
    try {
      var url = Uri.parse("http://192.168.67.52:3000/wishlist/removeWishlistProduct");
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      var body = jsonEncode({"productId": productId});
      var response = await http.delete(url, headers: header, body: body);
      if (response.statusCode == 200) {
        print("Product removed from wishlist");
        return true;
      } else {
        print("Product not removed from wishlist");
        return false;
      }
    } catch (e) {
      print("Error Occurred: $e");
      return false;
    }
  }

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
              Text('My Wishlist'),
              SizedBox(width: 8.w),
              Icon(Icons.favorite, size: 14.r),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : wishlistDetails.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, size: 80.r, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text('Your wishlist is empty',
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.h),
                        Text('Add items that you like to your wishlist',
                            style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: wishlistDetails.length,
                    itemBuilder: (context, index) {
                      final wishlist = wishlistDetails[index];
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Product1(wishlist['productId'])));
                          },
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
                                ]),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      "http://192.168.67.52:3000/uploads/${wishlist['image']}",
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
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 15, bottom: 8),
                                            child: Text(wishlist['productName'] ?? 'Unknown',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                          Text('Artist: ${wishlist['artistName'] ?? 'Unknown'}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[700],
                                              )),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          Text('Price: ₹${wishlist['price'] ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              )),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                        ]
                                  ),
                                    ]
                                )
                                ),
                                SizedBox(width: 1.w,),
                                Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  bool success = await removeFromWishlist(wishlist['productId']);
                                                  if (success) {
                                                    setState(() {
                                                      wishlistDetails.removeAt(index);
                                                    });
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Removed from wishlist')),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[50],
                                                    borderRadius: BorderRadius.circular(6.r),
                                                  ),
                                                  child: Icon(
                                                    Icons.delete_outline,
                                                    size: 25.r,
                                                    color: const Color.fromARGB(255, 185, 3, 3),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        );
                    }
                      )
                      )
                      );
  }
}
                    
                  
      
    
  
