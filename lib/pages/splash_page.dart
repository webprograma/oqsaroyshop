import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/sign_in_page.dart';
import 'package:instaclone/pages/vital_pages/mymainpage.dart';
import 'package:instaclone/servise/firebase_servise.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      callNextPage();
    });
  }

  void callNextPage() async {
    // Ensure that initState is called and Firebase authentication is initialized
    print("InitState called");
    if (FireBaseService.isLoggedIn()) {
      print("User is logged in");
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      print("User is not logged in");
      Navigator.pushReplacementNamed(context, SignInPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Text(
                'OqsaroyShop',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 45,
                    fontFamily: "Powerpunchy"),
              ),
            )),
            Text(
              'All rights are reserved',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
