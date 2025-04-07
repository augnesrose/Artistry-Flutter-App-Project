import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/CatPaintings/painting1.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class Paintings extends StatefulWidget {
  final String category;
  const Paintings(this.category,{super.key});

  @override
  State<Paintings> createState() => _PaintingsState();
}

class _PaintingsState extends State<Paintings> {
 List<dynamic> products=[];
 List<dynamic> wishlistDetails=[];
 bool isLoading=true;

 @override

 void initState(){
  super.initState();
  fetchProducts();
 }
 Future<void> fetchProducts() async {
  try {
    var url = Uri.parse("http://192.168.67.52:3000/category/getProductsByCategory/${widget.category}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print("Response Body: ${response.body}");
      var jsonResponse = json.decode(response.body);

      // Update this condition to check for 'products' instead of 'data'
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('products')) {
        setState(() {
          products = jsonResponse['products'];
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


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${widget.category}'),
      ),
      body:isLoading?
      Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.65,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
  var product = products[index];

  // Provide a default value of 'false' if 'isWishlisted' is null
  bool isWishlisted = product['isWishlisted'] ?? false;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Product1(product['_id']),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Image.network(
                      "http://192.168.67.52:3000/uploads/${product['productImage']}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product['price'].toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[800],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
},

              ),
            )
          ],
        ),
      ),
    );
  }
}