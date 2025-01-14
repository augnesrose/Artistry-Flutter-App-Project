import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('EDIT',
        style: TextStyle(),),
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
                //Navigator.push(context, MaterialPageRoute(builder: (context) => ProductConfirm()));
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
                'Save',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      
    );
  }
}