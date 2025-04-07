// import 'package:flutter/material.dart';
// import 'order_confirmation_screen.dart'; 
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late Razorpay _razorpay;
//   List<dynamic> cartDetail = [];
//   Map<String, dynamic> addressDetails = {};
//   String? razorpayOrderId;
//   bool isLoading = true;
//   bool isCreatingOrder = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchCart();
//     fetchAddress();
//     _razorpay = Razorpay();

//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   Future<void> fetchCart() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       print("Token not received");
//       return;
//     }
//     try {
//       var url = Uri.parse("http://192.168.67.52:3000/cart/getfromCart");
//       final header = {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token"
//       };
//       final response = await http.get(url, headers: header);
//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(response.body);
//         if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('cart')) {
//           setState(() {
//             cartDetail = jsonResponse['cart'];
//             isLoading = false;
//           });
//         }
//       } else {
//         throw Exception('Failed to load products');
//       }
//     } catch (e) {
//       print("Error Occurred: $e");
//     }
//   }

//   Future<void> fetchAddress() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       print("No token found address part");
//       return;
//     }
//     try {
//       var url = Uri.parse("http://192.168.67.52:3000/checkout/getAddress");
//       final header = {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token"
//       };
//       final response = await http.get(url, headers: header);

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(response.body);
//         if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('address')) {
//           setState(() {
//             addressDetails = jsonResponse['address'];
//           });
//         }
//       }
//     } catch (e) {
//       print("Error Occurred address part: $e");
//     }
//   }

//   double grandTotal() {
//     double total = 0.0;
//     for (var item in cartDetail) {
//       total += item['price'];
//       total+=item['shippingFee'];
//     }
//     return total;
//   }

//   Future<void> createOrder() async {
//     setState(() {
//       isCreatingOrder = true;
//     });
    
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
      
//       if (token == null) {
//         throw Exception("Authentication token not found");
//       }
      
//       // Prepare order data
//       List<Map<String, dynamic>> products = cartDetail.map((item) => {
//         "productId": item['productId'],
//       }).toList();
      
//       final orderData = {
//         "products": products,
//         "addressId": addressDetails['_id'],
//       };
      
//       // Create order
//       var url = Uri.parse("http://192.168.67.52:3000/order/createOrder");
//       final header = {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token"
//       };
      
//       final response = await http.post(
//         url, 
//         headers: header,
//         body: json.encode(orderData)
//       );
      
//       if (response.statusCode == 201) {
//         var jsonResponse = json.decode(response.body);
//         // Store the Razorpay order ID
//         razorpayOrderId = jsonResponse['razorpayOrderId'];
        
//         // Open Razorpay checkout
//         openCheckout(
//           orderId: razorpayOrderId!,
//           amount: jsonResponse['amount']
//         );
//       } else {
//         throw Exception('Failed to create order: ${response.body}');
//       }
//     } catch (e) {
//       print("Error creating order: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to create order: $e")),
//       );
//     } finally {
//       setState(() {
//         isCreatingOrder = false;
//       });
//     }
//   }

//   void openCheckout({required String orderId, required int amount}) {
//     var options = {
//       'key': 'rzp_test_GX9D2YiiLyW3u3',
//       'amount': amount, // Amount from backend in paise
//       'order_id': orderId, // Order ID from backend
//       'name': 'Artistry App',
//       'description': 'Payment for Order',
//       'prefill': {
//         'contact': addressDetails['phone'] ?? '9876543210',
//         'email': addressDetails['email'] ?? 'customer@example.com',
//       },
//       'theme': {'color': '#3399cc'},
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print("Error opening Razorpay: $e");
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async{
//     print("Payment Successful: \${response.paymentId}");
//     try{
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String ? token=prefs.getString('token');
//       if(token == null){
//         throw Exception("Authentication token not found");
//       }

//       var url =Uri.parse("http://192.168.67.52:3000/order/verifyPayment");
//       final header ={
//         "Authorization":"Bearer $token",
//         "Content-Type":"application/json"
//       };
//       final verifyData ={
//         "razorpayOrderId":razorpayOrderId,
//         "razorpayPaymentId":response.paymentId,
//         "razorpaySignature":response.signature
//       };
//       var verifyResponse = await http.post(url,headers:header,body:json.encode(verifyData));
//       if(verifyResponse.statusCode == 200){
//         await clearCart();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Payment Successful!")),
//         );
//         Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => OrderConfirmationScreen(
//             orderId:razorpayOrderId!,
//           )),
//         ); // Navigate back to the previous screen
//       }
//       else{
//         throw Exception("Payment verification failed: \${verifyResponse.body}");
//       }
//   }
//   catch(e){
//     print("Error verifying payment: $e");
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   SnackBar(content: Text("Payment verification failed: $e")),
//     // );
//   }
// }

// Future<void> clearCart() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString('token');
//   if (token == null) {
//     print("Token not found for clearing cart");
//   }

//   try{
//     var url = Uri.parse("http://192.168.67.52:3000/cart/remove");
//     final header = {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token"
//       };
      
//       await http.delete(url, headers: header);
//   }
//   catch(e){
//     print("Error clearing cart: $e");
//   }
// }
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("Payment Error: \${response.code} - \${response.message}");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment Failed! Try again.")),
//     );
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("External Wallet Used: \${response.walletName}");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("External Wallet: \${response.walletName}")),
//     );
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Razorpay Payment")),
//       body: Center(
//         child: isLoading
//             ? CircularProgressIndicator()
//             : ElevatedButton(
//                 onPressed: openCheckout,
//                 child: Text("Proceed to Pay"),
//               ),
//       ),
//     );
//   }
// }
