import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/productfinalization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlaceOrder extends StatefulWidget {
  PlaceOrder({super.key});

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _housenameController = TextEditingController();
  final _localityController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> addAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No token found");
      return;
    }

    try {
      final url = Uri.parse("http://192.168.67.52:3000/checkout/addAddress");
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final body = json.encode({
        'name': _nameController.text.trim(),
        'phone': _mobileController.text.trim(),
        'pinCode': _pincodeController.text.trim(),
        'houseName': _housenameController.text.trim(),
        'locality': _localityController.text.trim(),
        'district': _districtController.text.trim(),
        'state': _stateController.text.trim(),
      });
      print("Request body being sent: $body");
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Address added successfully!"),duration:Duration(seconds: 1)));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductConfirm()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to add address: ${response.body}"),duration:Duration(seconds: 1)));
      }
    } catch (err) {
      print("Error Occurred: $err");
    }
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(
            'ADDRESS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                if (_formKey.currentState!.validate()) {
                  addAddress();
                }
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18.h),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Text(
                    'Contact Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
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
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            validator: (value) =>
                                value!.isEmpty ? "Please enter your name" : null,
                            decoration: _inputDecoration("Name", Icons.man_2_outlined),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter mobile number";
                              } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                return "Enter a valid 10-digit number";
                              }
                              return null;
                            },
                            decoration: _inputDecoration("Mobile No.", Icons.mobile_friendly),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
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
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter pincode";
                              } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                                return "Enter a valid 6-digit pincode";
                              }
                              return null;
                            },
                            decoration: _inputDecoration("Pincode", Icons.pin_drop),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: _housenameController,
                            validator: (value) => value!.isEmpty
                                ? "Please enter house/area/street details"
                                : null,
                            decoration: _inputDecoration("Address(House No.,Building,Street,Area)", Icons.home),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: _localityController,
                            validator: (value) =>
                                value!.isEmpty ? "Please enter locality/town" : null,
                            decoration: _inputDecoration("Locality/Town", Icons.location_city),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: _districtController,
                            validator: (value) =>
                                value!.isEmpty ? "Please enter district" : null,
                            decoration: _inputDecoration("District", Icons.map),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: _stateController,
                            validator: (value) =>
                                value!.isEmpty ? "Please enter state" : null,
                            decoration: _inputDecoration("State", Icons.flag),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }
}
