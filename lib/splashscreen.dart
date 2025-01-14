import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:artistry_app/get_started.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold( body:Stack(
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
                Column(
                  children:[
                    SizedBox(height: 250.h),
                    Padding(
                      padding:EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                      child: Center(
                        child: Text('WELCOME !',style:TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontFamily: 'PlayFair',
                         ) ,),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                      child: Center(
                        child: Text('"Find art as unique as you"',style:TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'PlayFair',
                         ) ,),
                      ),
                    ),
                   // SizedBox(height: 220.h),
                   
            
                  ],
                ),
                 Center(
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(bottom: 50),
                         child: TextButton(onPressed: (){
                              Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                                         );
                            }, 
                            style:TextButton.styleFrom(
                              backgroundColor: Colors.white, 
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              )
                            ), 
                            child:Padding(
                              padding: EdgeInsets.symmetric(vertical: 14,horizontal: 70),
                              child: Text('Get Started',
                                      style: TextStyle(
                                        fontSize: 22,
                                        
                                      ),
                                      ),
                            ),
                            
                            ),
                       ),
                     ],
                   ),
                 )
            ],
        
          ));
  }
}