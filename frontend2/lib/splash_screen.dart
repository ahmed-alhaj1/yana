import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:frontend2/feed.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'login.dart';
import 'feed.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: Get.height * 0.5,
      duration: 3000,
      backgroundColor: Colors.black,
      splash: Image.asset('assests/logo.png'),
      nextScreen: Login(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
