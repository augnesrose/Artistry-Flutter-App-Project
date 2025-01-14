import 'package:artistry_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/signup.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body:Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/image1.jpg'),
                    fit: BoxFit.cover),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                        stops: [0.0,1.0],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 110.h,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(20),
                          ),
                          width:double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          padding: EdgeInsets.all(24),
                          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, // Responsive height
          ),
                          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Login',style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                              ),
                              SizedBox(
                                height:30.h
                              ),
                                TextField(
                                      decoration: InputDecoration(
                                        hintText: 'User name',
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16
                                    )
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        prefixIcon: Icon(
                                          Icons.key,
                                          color: Colors.black,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16
                                    )
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    TextButton(
                          onPressed: () {
                             Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  Home()),
                                );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: SizedBox(
                            width: double.infinity, 
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14), 
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center, 
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                                    
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            children: [
                              Text('Do not have an account?',style: TextStyle(
                                fontSize: 15,
                              ),
                              ),
                              SizedBox(
                                width: 10.r,
                              ),
                              TextButton(onPressed: (){
                                 Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SignUp()),
                                      );
                              }, child:Text('Sign Up'))
                            ],
                          )
                        
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ]
          )
    );
  }
}