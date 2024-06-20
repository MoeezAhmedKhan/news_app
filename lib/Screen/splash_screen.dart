import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/Routing/routes_name.dart';
import 'package:newsapp/Screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3),
        () => Navigator.pushReplacementNamed(context, RoutesName.HomeScreen));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "image/logo.png",
              // fit: BoxFit.cover,
              width: mediaQuery.width * 1,
              /*100% of the screen*/
              height: mediaQuery.height * 0.5, /*50% of the screen*/
            ),
            SizedBox(height: mediaQuery.height * 0.04),
            /*4% of the screen*/
            SpinKitChasingDots(
              color: const Color(0xffbd1524),
              size: mediaQuery.height * 0.04, /*4% of the screen */
            )
          ],
        ),
      ),
    );
  }
}
