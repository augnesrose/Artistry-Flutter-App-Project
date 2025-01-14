import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/payment.dart';

class ProductConfirm extends StatelessWidget {
  ProductConfirm({super.key});
  final List<Map<String, dynamic>> proDetail = [
    {'image': 'images/catPaintings/paint1.jpg', 'name': ' "Her Eyes" ', 'price': '\$4,000', 'artist': 'Simon'},
    {'image': 'images/catPhotography/pho1.jpg', 'name': ' "Scooter" ', 'price': '\$110', 'artist': 'Cade'}
  ];
  
  final List<Map<String, dynamic>> personAdd = [
    {'name': 'Augnes Rose', 'phone': '9778217946', 'address': 'Srambickal ', 'pincode': '688008', 'locality': 'Kommady', 'district': 'Alappuzha', 'state': 'Kerala'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'ORDER CONFIRMATION',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductCard(),
                SizedBox(height: 20.h),
                _buildDeliveryAddressCard(),
                SizedBox(height: 20.h),
                _buildPriceDetailsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      decoration: _buildCardDecoration(),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                proDetail[0]['image'],
                width: 100.h,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proDetail[0]['name'],
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Artist: ${proDetail[0]['artist']}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Price: ${proDetail[0]['price']}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 212, 85, 108),
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

  Widget _buildDeliveryAddressCard() {
    return Container(
      decoration: _buildCardDecoration(),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 212, 85, 108),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 212, 85, 108),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    personAdd[0]['name'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    personAdd[0]['phone'],
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${personAdd[0]['address']}, ${personAdd[0]['locality']},\n${personAdd[0]['district']}, ${personAdd[0]['state']}\nPIN: ${personAdd[0]['pincode']}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      height: 1.5,
                      color: Colors.grey[700],
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

  Widget _buildPriceDetailsCard() {
    return Container(
      decoration: _buildCardDecoration(),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 212, 85, 108),
              ),
            ),
            SizedBox(height: 16.h),
            _buildPriceRow('Total Quantity', '2'),
            _buildPriceRow('Shipping Charge', 'Free', isHighlighted: true),
            Divider(height: 24.h),
            _buildPriceRow('Total Amount', '\$4,110', isBold: true),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.local_shipping_outlined, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Delivery by 17th January 2024',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isHighlighted = false, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: isHighlighted ? Color.fromARGB(255, 212, 85, 108) : null,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(0, 4),
        )
      ],
    );
  }
}