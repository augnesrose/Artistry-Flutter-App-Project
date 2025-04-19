import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/placeorder.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddToCart extends StatefulWidget {
  AddToCart({super.key});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  List<dynamic> cartDetail = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No token found! User is not authenticated.");
      return;
    }
    try {
      var url = Uri.parse("http://192.168.67.52:3000/cart/getFromCart");

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token" // Include token if needed
        },
      );

      if (response.statusCode == 200) {
        print("Response Body: ${response.body}");
        var jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('cart')) {
          setState(() {
            cartDetail = jsonResponse['cart'];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<bool> removeFromCart(String productId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    if (token == null) {
      print("No token found");
      return false;
    }
    try {
      var url = Uri.parse("http://192.168.67.52:3000/cart/remove");
      var response = await http.delete(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode({"productId": productId}));
      if (response.statusCode == 200) {
        print("Product removed Successfully");
        return true;
      } else {
        print("Product not removed");
        return false;
      }
    } catch (err) {
      print("Error removing product : $err");
      return false;
    }
  }

  Future<void> deleteAddress() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String ? token = pref.getString('token');

    if(token == null){
      print("Token not found");
    }
    try{

      final url = Uri.parse("http://192.168.67.52:3000/checkout/deleteAddress");
      final header = {
        "Authorization":"Bearer $token",
        "Content-Type":"application/json",
      };
      final response = await http.delete(url,headers:header);
      final data=json.decode(response.body);

      if(response.statusCode==200){
        print("${data['message']}");
      }
    }
    catch(e){
      print("Error Occured : $e");
    }


  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : cartDetail.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_checkout_outlined,
                            size: 80.r, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text('Your cart is empty',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.h),
                        Text('Add items that you like to your cart',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: cartDetail.map((cart) {
                        return Padding(
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
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      "http://192.168.67.52:3000/uploads/${cart['image']}",
                                      fit: BoxFit.cover,
                                      width: 120.h,
                                      height: 120.h,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 8),
                                        child: Text(
                                          cart['productName'],
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text('Artist : ${cart['artistName']}',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 4.h),
                                      Text('Price : \u20B9 ${cart['price']}',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 8.h),
                                      SizedBox(
                                        height: 32,
                                        child: TextButton(
                                          onPressed: () async {
                                            String productId = cart['productId'];
                                            bool success =
                                                await removeFromCart(productId);
                                            if (success) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Item removed from the cart successfully"),duration:Duration(seconds: 1),),);
                                              await fetchProducts();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Failed to remove item from the cart"),duration:Duration(seconds: 1)));
                                            }
                                          },
                                          child: Text('Remove',
                                              style:
                                                  TextStyle(fontSize: 14.sp)),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList()
                        ..add(Padding(
                          padding: const EdgeInsets.all(12),
                          child: _buildPriceDetails(),
                        )), 
                    ),
                  ),
        bottomNavigationBar: cartDetail.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 1)
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: TextButton(
                    onPressed: () async{
                      await deleteAddress();
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PlaceOrder()));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Proceed to Pay',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w600)),
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }

 Widget _buildPriceDetails() {
  if (cartDetail.isEmpty) return SizedBox();

  double calculateSubtotal() {
    double total = 0;
    for (var item in cartDetail) {
      // Use tryParse and provide a default value if parsing fails
      double? price = double.tryParse(item['price']?.toString() ?? '0');
      total += price ?? 0; // Use 0 if price is null
    }
    return total;
  }

  double calculateShippingCharge() {
    double shippingCharge = 0;
    for (var item in cartDetail) {
      // Use tryParse and provide a default value if parsing fails
      double? shippingFee = double.tryParse(item['shippingFee']?.toString() ?? '0');
      shippingCharge += shippingFee ?? 0; // Use 0 if shippingFee is null
    }
    return shippingCharge;
  }

  double calculateGrandTotal() {
    return calculateSubtotal() + calculateShippingCharge();
  }

  return Card(
    elevation: 2,
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Items:', style: TextStyle(fontSize: 14.sp)),
              Text('${cartDetail.length}',
                  style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal:', style: TextStyle(fontSize: 14.sp)),
              Text(
                '\u20B9${calculateSubtotal().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping Fee:', style: TextStyle(fontSize: 14.sp)),
              Text(
                '\u20B9${calculateShippingCharge().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Divider(height: 24.h, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount Payable:',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '\u20B9${calculateGrandTotal().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}