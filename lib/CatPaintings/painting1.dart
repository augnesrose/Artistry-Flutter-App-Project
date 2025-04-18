import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/bottomnav/addtocart.dart';
import 'package:artistry_app/home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:artistry_app/Category/painting.dart';

class Product1 extends StatefulWidget {
  final String productId;
  Product1(this.productId,{super.key});

  @override
  State<Product1> createState() => _Product1State();

}

class _Product1State extends State<Product1> {

  @override
  void initState() {
    super.initState();
    fetchProduct().then((_){
      if(product!=null){
        checkWishlistStatus();
      }
    });
    
  }
  // State variable to track if the item is in wishlist
  bool isInWishlist = false;
  Map<String,dynamic>?product;
  bool isLoading = true;
  List<dynamic> cartDetail = [];
  // List<dynamic> wishListDetail=[];  

  // to get the product details


  Future<void> fetchProduct() async {
    try {
      var url = Uri.parse(
          "http://192.168.67.52:3000/admin/getProduct/${widget.productId}");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedProduct = jsonDecode(response.body);
        print('Decoded Product: $decodedProduct');

        setState(() {
          product = decodedProduct['product']; // Access the nested product map
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print('Error fetching product: $e');
      setState(() {
        isLoading = false; // Ensure UI updates even on error
      });
    }
  }
  
  //To adding product to the cart
  Future<void> addtocart(String productId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ? token = prefs.getString('token');

    if(token==null){
      print("No token found! User is not authenticated.");
      return ;
    }

    var url = Uri.parse("http://192.168.67.52:3000/cart/addToCart");
    var response = await http.post(url,
    headers: {
      "Authorization":"Bearer $token",
      "Content-Type":"application/json"
    },
    body: jsonEncode({"productId": productId}),
    );
      if (response.statusCode == 200) {
      fetchCart();
      print("Product added to cart successfully");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to cart"),duration:Duration(seconds: 1)));
     
    } else {
      print("Error: ${response.body}");
    }
  }

  //To fetch the cart products

  Future<void> fetchCart() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String ? token = prefs.getString('token');

    if(token==null){
      print("No token found! User is not authenticated.");
      return ;
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
      print('Error fetching products: $e');
    }
  }

// To add product to wishlist

  Future <void> addToWishlist(String productId) async{

  try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ? token = prefs.getString('token');

    if(token==null){
      print("No token found! User is not authenticated.");
      return ;
    }

    var url = Uri.parse("http://192.168.67.52:3000/wishlist/addToWishlist");
    var header={
      "Authorization" : "Bearer $token",
      "Content-Type":"application/json"
    };
    var body = jsonEncode({"productId":productId});
    var response = await http.post(url,headers:header,body:body);
    if (response.statusCode==200){
      print("product added to wishlist");
      
    }
    else{
      print("Error : ${response.body}");
      
    }
  }
  catch(e){
    print("Product no added to wishlist");
  }
}

// to fremove product from wishlist

Future<void> removeFromWishlist(String productId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No token found! User is not authenticated.");
      throw Exception("No token found");
    }

    var url = Uri.parse("http://192.168.67.52:3000/wishlist/removeWishlistProduct");
    var header = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    var body = jsonEncode({"productId": productId});
    var response = await http.delete(url, headers: header, body: body);
    if (response.statusCode == 200) {
      print("Product removed from wishlist");
    } else {
      print("Error: ${response.body}");
      
    }
  } catch (e) {
    print("Error removing product from wishlist: $e");
   
  }
}
  // To check gthe product is in wishlist or not

  Future<void> checkWishlistStatus() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String ? token = pref.getString('token');
    try{
      var url = Uri.parse("http://192.168.67.52:3000/wishlist/getWishlistProducts");
      var header ={
        "Authorization":"Bearer $token",
        "Content-Type":"application/json"
      };
      var response = await http.get(url,headers:header);
      if(response.statusCode==200){
        var jsonResponse = json.decode(response.body);
        List<dynamic> wishlist= jsonResponse['wishlist'];
        setState(() {
        isInWishlist = wishlist.any((item) => item['productId'] == product?['_id']);
      });
      print("Is product in wishlist: $isInWishlist");
      }
      else {
      print("Error fetching wishlist: ${response.body}");
    }
    }
    catch(e){
      print("Error Occured:$e");
    }
  }
   
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: isLoading
            ? Center(child: CircularProgressIndicator())
            : product == null
                ? Center(child: Text('Product Not Found'))
                :SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    // Product image
                    Container(
                      child: Image.network(
                        product?['productImage'] != null
                                ? 'http://192.168.67.52:3000/uploads/${product?['productImage']}'
                                : 'http://default_image_url_here.jpg',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Wishlist button positioned at the top right of the image
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isInWishlist ? Icons.favorite : Icons.favorite_border,
                            color: isInWishlist ? Colors.red : Colors.black,
                            size: 30,
                          ),
                          // Update your IconButton's onPressed callback like this
      onPressed: () {
        if (product != null) {
      // Store original state
      bool wasInWishlist = isInWishlist;
      
      // Update UI immediately
      setState(() {
        isInWishlist = !isInWishlist;
      });
      
      // Call the appropriate API function
      if (isInWishlist) {
        // Adding to wishlist
        addToWishlist(product!['_id']).then((_) {
          // Success already handled in UI update
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added to wishlist'),
              duration: Duration(seconds: 2),
            ),
          );
        }).catchError((error) {
          // Revert on error
          setState(() {
            isInWishlist = wasInWishlist;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add to wishlist'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      } else {
        // Removing from wishlist
        removeFromWishlist(product!['_id']).then((_) {
          // Success already handled in UI update
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Removed from wishlist'),
              duration: Duration(seconds: 2),
            ),
          );
        }).catchError((error) {
          // Revert on error
          setState(() {
            isInWishlist = wasInWishlist;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove from wishlist'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
        }
      },
                          
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    '${product?['name'] ?? 'Unknown Product'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    '${product?['artistName'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'About the Painting',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontFamily: 'PlayFair',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    '${product?['productDescription'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'About the Artist',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontFamily: 'PlayFair',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                                    'http://192.168.67.52:3000/uploads/${product?['artistImage'] ?? 'default_artist_image.jpg'}',
                                  ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    '${product?['artistDescription'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontFamily: 'PlayFair',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Material: ${product?['material'] ?? 'N/A'}', 
                           style: TextStyle(fontSize: 16.sp)),
                      Text('Medium: ${product?['medium'] ?? 'N/A'}', 
                           style: TextStyle(fontSize: 16.sp)),
                      Text('Height:  ${product?['height'] ?? 'N/A '} inches', 
                           style: TextStyle(fontSize: 16.sp)),
                      Text('Width: ${product?['width'] ?? 'N/A '} inches', 
                           style: TextStyle(fontSize: 16.sp)),
                    ]
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text('Shipping Fee :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: const Color.fromARGB(215, 227, 9, 9)),),
                      SizedBox(width:10.w),
                      Text('\u20B9${product?['shippingFee'] ?? 'N/A'}',style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ),
                
                SizedBox(height: 30.h),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            elevation: 10,
            
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '\u20B9${product?['price'] ?? 'N/A'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PlayFair'
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                ElevatedButton.icon(
                  onPressed: () async {
                    await addtocart(product?['_id']);
                    await fetchCart();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(initialIndex: 3)));
                    
                  }, 
                  icon: Icon(Icons.shopping_cart_rounded), 
                  label: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}