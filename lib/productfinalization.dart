import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:artistry_app/orderConfirmation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductConfirm extends StatefulWidget {
  ProductConfirm({super.key});

  @override
  State<ProductConfirm> createState() => _ProductConfirmState();
}

class _ProductConfirmState extends State<ProductConfirm> {
  List<dynamic> cartDetail = [];
  Map<String, dynamic> addressDetails = {};
  bool isLoading = true;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    fetchCart();
    fetchAddress();
    
    // Initialize Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Token not received");
      return;
    }
    try {
      var url = Uri.parse("http://192.168.67.52:3000/cart/getfromCart");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        print("Response Body : ${response.body}");
        var jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('cart')) {
          setState(() {
            cartDetail = jsonResponse['cart'];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error Occurred : $e");
    }
  }

  Future<void> fetchAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No token found address part");
      return;
    }
    try {
      var url = Uri.parse("http://192.168.67.52:3000/checkout/getAddress");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await http.get(url, headers: header);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('address')) {
          setState(() {
            addressDetails = jsonResponse['address'];
          });
        }
      }
    } catch (e) {
      print("Error Occurred address part:$e");
    }
  }


 Future<void> createOrder() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    print("No token received");
    return;
  }

  try {
    List<Map<String, dynamic>> products = cartDetail.map((item) => {
      "productId": item['productId'],
      "quantity": 1,
    }).toList();
    String addressId = addressDetails['_id'];
    var url = Uri.parse("http://192.168.67.52:3000/order/createOrder");
    final header = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "products": products,
      "addressId": addressId,
    });

    final response = await http.post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      String razorPayOrderId = jsonResponse['razorpayOrderId'];
      int amount = jsonResponse['amount'];
      openCheckout(razorPayOrderId, amount);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  } catch (e) {
    print("Error Occurred while creating order: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to create order. Please try again.")),
    );
  }
}


  // Razorpay payment functions
void openCheckout(String orderId, int amount) {
  var options = {
    'key': 'rzp_test_3MJ0cPqPZC9AWJ', // Replace with your Razorpay API Key
    'amount': amount, // Amount in paise from backend
    'currency': 'INR',
    'name': 'Artistry App',
    'description': 'Payment for Order',
    'order_id': orderId, // Razorpay order ID
    'prefill': {
      'contact': addressDetails['phone'] ?? '9876543210',
      'email': addressDetails['email'] ?? 'customer@example.com',
    },
    'theme': {'color': '#3399cc'},
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    print("Error: $e");
  }
}


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
  print("Payment Successful: ${response.paymentId}");
  
  // Verify payment on the backend
  verifyPayment(
    response.orderId ?? "",
    response.paymentId ?? "",
    response.signature ?? ""
  );
}

Future<void> verifyPayment(String razorpayOrderId, String razorpayPaymentId, String razorpaySignature) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  
  if (token == null) {
    print("No token found");
    return;
  }
  
  try {
    var url = Uri.parse("http://192.168.67.52:3000/order/verifyPayment");
    final header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    
    final body = jsonEncode({
      "razorpayOrderId": razorpayOrderId,
      "razorpayPaymentId": razorpayPaymentId,
      "razorpaySignature": razorpaySignature
    });
    
    final response = await http.post(url, headers: header, body: body);
    
    if (response.statusCode == 200) {
      // Payment verified successfully
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Payment verified successfully!")),
      // );
      
      // Navigate to order success page
     //Navigator.pushReplacementNamed(context, '/OrderConfirmationScreen');
    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationScreen(orderId: razorpayOrderId)));
    } else if (response.statusCode == 400) {
      // Payment verification failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment verification failed. Please try again.")),
      );
    } else {
      throw Exception('Failed to verify payment: ${response.body}');
    }
  } catch (e) {
    print("Error verifying payment: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment verification failed. Please contact support.")),
    );
  }
}

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code} - ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed! Try again.")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Used: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

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
              onPressed: createOrder, // Direct call to open Razorpay
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductList(),
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

  Widget _buildProductList() {
    if (cartDetail.isEmpty) {
      return Center(
        child: Text("No products in the cart", style: TextStyle(fontSize: 16.sp)),
      );
    }

    return Column(
      children: List.generate(
        cartDetail.length,
        (index) => _buildProductCard(index),
      ),
    );
  }

  Widget _buildProductCard(int index) {
    var item = cartDetail[index];
    return Container(
      decoration: _buildCardDecoration(),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "http://192.168.67.52:3000/uploads/${item['image']}" ??
                    'https://placeholder.com/100',
                width: 100.h,
                height: 100.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100.h,
                    height: 100.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, color: Colors.grey[500]),
                  );
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['productName'] ?? 'Unknown Product',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Artist: ${item['artistName'] ?? 'Unknown'}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Price: \u20B9 ${item['price'] ?? '0'}',
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
    if (addressDetails.isEmpty) {
      return Container(
          decoration: _buildCardDecoration(),
          padding: EdgeInsets.all(16.w),
          child: Center(
            child: Text("No address information available",
                style: TextStyle(fontSize: 16.sp)),
          ));
    }
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
                  color: Colors.black,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
                    addressDetails['name'] ?? 'No Name',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    addressDetails['phone'] ?? 'No phone',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${addressDetails['houseName'] ?? ''}, ${addressDetails['locality'] ?? ' '},\n${addressDetails['district'] ?? ""}, ${addressDetails['state'] ?? ''}\nPIN: ${addressDetails['pinCode'] ?? ''}',
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
    if (cartDetail.isEmpty) return SizedBox();

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
            _buildPriceRow('Total Quantity : ', '${cartDetail.length}'),
            _buildPriceRow('Subtotal : ', '\u20B9${calculateSubtotal().toStringAsFixed(2)}'),
            _buildPriceRow('Shipping Charge : ',
                '\u20B9 ${calculateShippingCharge().toStringAsFixed(2)}',
                isHighlighted: true),
            Divider(
              height: 24.h,
              thickness: 1,
            ),
            _buildPriceRow('Amount Payable ',
                '\u20B9${grandTotal().toStringAsFixed(2)}', isBold: true),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.local_shipping_outlined, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Estimated delivery in 20-30 business days',
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

  Widget _buildPriceRow(String label, String value,
      {bool isHighlighted = false, bool isBold = false}) {
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

  // Price calculation methods (from _buildPriceDetailsCard)
  double calculateSubtotal() {
    double total = 0;
    for (var item in cartDetail) {
      total += double.parse(item['price'].toString());
    }
    return total;
  }

  double calculateShippingCharge() {
    double total = 0;
    for (var item in cartDetail) {
      total += double.parse(item['shippingFee'].toString());
    }
    return total;
  }

  double grandTotal() {
    return calculateSubtotal() + calculateShippingCharge();
  }
}