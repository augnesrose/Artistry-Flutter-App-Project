import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:artistry_app/myOrders.dart';
import 'package:artistry_app/get_started.dart';
import 'dart:io';
import 'package:artistry_app/editProfile.dart';
import 'package:artistry_app/myWishlist.dart';


class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? _image;
  File? selectedImage;

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              SizedBox(height: 30.h),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: selectedImage != null 
                          ? FileImage(selectedImage!) as ImageProvider
                          : AssetImage('images/others/blankprofile.webp'),
                    ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          showImagePickerOption(context);
                        },
                        icon: Icon(Icons.add_a_photo,size: 30,),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h,),
              Padding(
                padding: const EdgeInsets.only(left: 135),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    Text(
                      'Hey ',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 3.h),
                    Text(
                      'Augnes !',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 73, 19, 19),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 180.h, 
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), 
                      topRight: Radius.circular(40), 
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [ 
                        ListTile(
                          leading: Icon(Icons.shopping_bag,size: 16,),
                          title: Text('My Orders',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  Orders()),);     
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading:Icon(Icons.favorite,size: 16) ,
                          title:Text('My Wishlist',
                          style:TextStyle(
                            fontSize: 14.sp,
                            fontWeight:FontWeight.w500,
                          ),
                          ),
                          trailing:Icon(Icons.arrow_forward_ios),
                          onTap:(){
                            Navigator.push(context,MaterialPageRoute(builder:(context)=>Mywishlist()),);
                          }
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.edit,size: 16,),
                          title:Text('Edit profile',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditProfile()),);
                          },
                        ),
                        Divider(),
                        
                        ListTile(
                          leading: Icon(Icons.delete_forever,size: 16,),
                          title:Text('Remove Account',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) =>  Login()),);
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.logout,size: 16,),
                          title:Text('Log out',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  Login()),);
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),   
            ],
          ),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context, 
      builder: (builder) {
        return Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [ 
              InkWell(
                onTap: () {
                  pickImageFromGallery();
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image, size: 70),
                    Text('Gallery'),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  pickImageFromCamera();
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 70),
                    Text('Camera'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}