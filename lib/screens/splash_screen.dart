import 'dart:async';

import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/services/file_services.dart';
import 'package:flutter/material.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _width = 200;
  double _height = 200;

  final String _id = '';

  // @override
  void updateState() {
    setState(() {
      _width = 400;
      _height = 400;
    });
  }

  @override
  void initState() {
    super.initState();
    FileUtilsUser.readFromFile().then((content) {
      updateState();
      if (content == "") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MasukScreen())));
      } else {
        final split = content.split(';');
        if (split.length == 1) {
          Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MasukScreen(),
              ),
            ),
          );
        }
        if (split[1] == 'L') {
          Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            ),
          );
        } else {
          Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MasukScreen(),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _width,
                  height: _height,
                  curve: Curves.bounceIn,
                  child: Image.asset(
                    "assets/images/sp_logo_splash.png",
                    height: 300.0,
                    width: 300.0,
                  ),
                ),
              ],
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mYellowPu),
            ),
          ],
        ),
      ),
    );
  }
}
