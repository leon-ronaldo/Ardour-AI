import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/authentication_controller.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  const AuthenticationView({super.key});

  Widget signInButton({
    required String iconName,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: InkResponse(
        onTap: onTap,
        child:
            FTContainer()
              ..px = 24
              ..py = 12
              ..borderRadius = BorderRadius.circular(5)
              ..border = Border.all(
                color: Colors.black.withOpacity(0.2),
                width: 1.2,
              )
              ..bgColor = Colors.white
              ..child = Row(
                children: [
                  SVGIcon(iconName)..height = 18,
                  SizedBox(width: 12),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MainController.size = context;
    MainController.padding = context;
    return Scaffold(
      backgroundColor: AppColors.primaryBG,
      resizeToAvoidBottomInset: false,
      body:
          FTContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Ardourgram",
                    style: TextStyle(fontSize: 24, fontFamily: "InstaSans"),
                  ),

                  Column(
                    children: [
                      Text(
                        'Welcome back',
                        style: GoogleFonts.poppins(fontSize: 28),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(fontSize: 13), // Input text size
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(
                            fontSize: 13,
                          ), // Label text size
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(fontSize: 13),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.statusBorder,
                              width: 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkResponse(
                        child:
                            FTContainer(
                                child: Text(
                                  "Continue",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              ..px = 24
                              ..py = 13
                              ..boxDecoration = BoxDecoration(
                                gradient: AppColors.baseGradient,
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              )
                              ..width = MainController.size.width,
                      ),
                      SizedBox(height: 20),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child:
                                FTContainer()
                                  ..height = 1
                                  ..bgColor = Colors.black54
                                  ..mr = 5,
                          ),
                          Text("OR", style: GoogleFonts.lato(fontSize: 12)),
                          Expanded(
                            child:
                                FTContainer()
                                  ..height = 1
                                  ..bgColor = Colors.black54
                                  ..ml = 5,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      signInButton(
                        iconName: 'google',
                        label: 'Sign in with Google',
                        onTap: controller.signInWithGoogle,
                      ),

                      SizedBox(height: 10),

                      signInButton(
                        iconName: 'facebook',
                        label: 'Sign in with Facebook',
                        onTap: () {
                          // Facebook sign-in logic here
                        },
                      ),

                      SizedBox(height: 10),

                      signInButton(
                        iconName: 'apple',
                        label: 'Sign in with Apple',
                        onTap: () {
                          // apple sign-in logic here
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
            ..px = MainController.size.width * 0.15
            ..width = MainController.size.width
            ..height = MainController.size.height,
    );
  }
}
