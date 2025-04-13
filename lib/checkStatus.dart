import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:artistry_app/CatPaintings/painting1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class OrderStatusPage extends StatefulWidget {
  final String orderId;
  const OrderStatusPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> with TickerProviderStateMixin {
  // Status options: "Pending", "Approved", "Packed", "Shipped", "Cancelled"
  String currentStatus = "Pending";
  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic> orderDetails = {};
  Timer? statusCheckTimer;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn)
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    
    fetchOrderDetails();
    
 
    statusCheckTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      fetchOrderDetails(silent: true);
    });
  }

  @override
  void dispose() {
    statusCheckTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
  void  navigatetoHome(){
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  Future<void> fetchOrderDetails({bool silent = false}) async {
    if (!silent) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        print("Token not found in SharedPreferences");
        return;
      }
      
      final url = Uri.parse("http://192.168.67.52:3000/order/orderDetails/${widget.orderId}");
      final headers = {
        "Authorization":"Bearer $token",
        "Content-Type": "application/json"
        };
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('order')) {
          final order = jsonResponse['order'];
          final oldStatus = currentStatus;
          final newStatus = order['status'] ?? 'Pending';
          
          setState(() {
            orderDetails = order;
            currentStatus = newStatus;
            isLoading = false;
          });
          
          
          if (oldStatus != newStatus && !silent) {
            _playStatusChangeAnimation();
          } else if (oldStatus != newStatus) {
            
            _playStatusChangeAnimation();
          
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Order status updated to: $newStatus"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          setState(() {
            errorMessage = "Order details not found";
            isLoading = false;
          });
        }
      } else {
        if (!silent) {
          setState(() {
            errorMessage = "Failed to fetch order details. Status code: ${response.statusCode}";
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (!silent) {
        setState(() {
          errorMessage = 'Failed to fetch order details: $e';
          isLoading = false;
        });
      }
    }
  }
  
  void _playStatusChangeAnimation() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigatetoHome();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Order Details",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => fetchOrderDetails(),
              tooltip: "Refresh Order Status",
            ),
          ],
          leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => navigatetoHome(),
        ),
        ),
        body: isLoading 
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Order #${truncateOrderId(orderDetails['orderId'] ?? 'Unknown')}",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _formatDate(orderDetails['createdAt']),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Expected Delivery: ${_getExpectedDeliveryDate()}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          
                          Text(
                            "Your Order",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                              
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: Image.network(
                                    "http://192.168.67.52:3000/uploads/${orderDetails['productId']['productImage']}",
                                    width: 80.w,
                                    height: 80.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80.w,
                                        height: 80.w,
                                        color: Colors.grey[200],
                                        child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 12.w),
                          
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderDetails['productId']?['name'] ?? 'Unknown Product',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        orderDetails['productId']?['category'] ?? 'Unknown Category',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "₹${orderDetails['productId']?['price'].toString() ?? '0'}",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PlayFair',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                            
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.sp,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 32.h),
                          
                          
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: _getPaymentStatusColor(orderDetails['paymentDetails']?['paymentStatus'] ?? 'Pending').withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: _getPaymentStatusColor(orderDetails['paymentDetails']?['paymentStatus'] ?? 'Pending').withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getPaymentStatusIcon(orderDetails['paymentDetails']?['paymentStatus'] ?? 'Pending'),
                                  color: _getPaymentStatusColor(orderDetails['paymentDetails']?['paymentStatus'] ?? 'Pending'),
                                ),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment Status",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      orderDetails['paymentDetails']?['paymentStatus'] ?? 'Pending',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: _getPaymentStatusColor(orderDetails['paymentDetails']?['paymentStatus'] ?? 'Pending'),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 32.h),
                      
                          Text(
                            "Order Status",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          
                        
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: buildOrderStatusTimeline(),
                            ),
                          ),
                          
                          SizedBox(height: 40.h),
                          
                          
                          if (currentStatus != "Cancelled" && currentStatus != "Shipped")
  Center(
    child: orderDetails['cancellation'] == true
      ? SizedBox(
          width: 200.w,
          child: ElevatedButton(
            onPressed: null, // Disabled
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.grey[600],
              disabledForegroundColor: Colors.grey[600],
              disabledBackgroundColor: Colors.grey[300],
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Cancellation Requested",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      : SizedBox(
          width: 200.w,
          child: ElevatedButton(
            onPressed: () {
              _showCancelDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Cancel Order",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
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
  String truncateOrderId(String orderId, {int length = 10}) {
  if (orderId == null || orderId.isEmpty) return 'Unknown';
  return orderId.length > length ? orderId.substring(0, length) + '...' : orderId;
}
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }
  
  String _getExpectedDeliveryDate() {
    try {
      
      if (currentStatus == "Cancelled") {
        return "Order Cancelled";
      }
      
      final createdAt = orderDetails['createdAt'] != null 
          ? DateTime.parse(orderDetails['createdAt']) 
          : DateTime.now();
      
      int additionalDays = 7; 
      
      switch (currentStatus) {
        case "Approved":
          additionalDays = 5;
          break;
        case "Packed":
          additionalDays = 3;
          break;
        case "Shipped":
          additionalDays = 10;
          break;
      }
      
      final expectedDelivery = createdAt.add(Duration(days: additionalDays));
      return '${expectedDelivery.day}/${expectedDelivery.month}/${expectedDelivery.year}';
    } catch (e) {
      return 'Date Unavailable';
    }
  }
  
  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getPaymentStatusIcon(String status) {
    switch (status) {
      case 'Success':
        return Icons.check_circle;
      case 'Failed':
        return Icons.cancel;
      case 'Pending':
        return Icons.pending;
      default:
        return Icons.help;
    }
  }

  Widget buildOrderStatusTimeline() {
    List<String> statuses = ["Pending", "Approved", "Packed", "Shipped"];
    int currentIndex = statuses.indexOf(currentStatus);
    if (currentIndex == -1) currentIndex = 0;
    
    
    if (currentStatus == "Cancelled") {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Cancelled",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Your order has been cancelled",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
    //Order status timeline


    if (orderDetails['cancellation'] == true && currentStatus != "Cancelled") {
    return Column(
      children: [
        Column(
          children : List.generate(statuses.length,(index){
            bool isCompleted = index <= currentIndex;
            bool isCurrent = index == currentIndex;
            
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.black : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18.sp,
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ${statuses[index]}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: isCompleted ? Colors.black : Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          getStatusDescription(statuses[index]),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isCompleted ? Colors.black87 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                if (index < statuses.length - 1)
                  Container(
              
                    margin: EdgeInsets.only(left: 15.w),
                    height: 30.h,
                    width:  1.w,
                    color: isCompleted ?  Colors.black:Colors.grey[300], 
                        
                  ),
              ],
            );
          })
        ),

        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pending_actions,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cancellation Requested",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Your request is being processed",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]
    );
    }
    return Column(
      children: List.generate(statuses.length, (index) {
        bool isCompleted = index <= currentIndex;
        bool isCurrent = index == currentIndex;
        
        return Column(
          children: [
            Row(
              children: [
                
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.black : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18.sp,
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ${statuses[index]}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? Colors.black : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      getStatusDescription(statuses[index]),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isCompleted ? Colors.black87 : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (index < statuses.length - 1)
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(left: 15.w),
                height: 30.h,
                width: isCurrent ? 3.w : 1.w,
                color: isCompleted 
                    ? (isCurrent ? Colors.blue : Colors.black) 
                    : Colors.grey[300],
              ),
          ],
        );
      }),
    );
  }
  
  String getStatusDescription(String status) {
    switch (status) {
      case "Pending":
        return "We've received your order";
      case "Approved":
        return "Your order has been approved";
      case "Packed":
        return "Your order is being packed";
      case "Shipped":
        return "Your order is on the way";
      default:
        return "";
    }
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Cancel Order",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to cancel this order?",
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _cancelOrder();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                "Yes",
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _cancelOrder() async {
    print("Cancelling order with ID: ${orderDetails['_id']}");
    try {
      
      final url = Uri.parse("http://192.168.67.52:3000/order/cancelOrder/${orderDetails['_id']}");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
      );
      
      if (response.statusCode == 200) {
        
        setState(() {
          orderDetails['cancellation'] = true;
        });
        
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cancellation request submitted"),
            backgroundColor: Colors.orange[700],
          ),
        );
        
        
        _playStatusChangeAnimation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to cancel order. Please try again."),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }
  
}