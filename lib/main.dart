import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/sign_in_page.dart';
import 'package:instaclone/pages/sign_up_page.dart';
import 'package:instaclone/pages/splash_page.dart';
import 'package:instaclone/pages/vital_pages/customer_profile_page.dart';
import 'package:instaclone/pages/vital_pages/myfavouritePage.dart';
import 'package:instaclone/pages/vital_pages/mymainpage.dart';
import 'package:instaclone/pages/vital_pages/myprofilepage.dart';
import 'package:instaclone/pages/vital_pages/mysearchpage.dart';
import 'package:instaclone/pages/vital_pages/upload_page.dart';

bool isCustomer = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA2IjjK7qlgCXz_dzbHg4B3rgHI7dN2CV8",
          appId: "1:141306980307:android:30cea82f52425f439bf126",
          projectId: "flutter-insta-clone-f9035",
          messagingSenderId: 'sendid'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      routes: {
        SignInPage.id: (context) => SignInPage(),
        SignUpPage.id: (context) => SignUpPage(),
        MyMainPage.id: (context) => MyMainPage(),
        UploadPage.id: (context) => UploadPage(),
        MyProfilePage.id: (context) => MyProfilePage(),
        MySearchPage.id: (context) => MySearchPage(),
        MyFavouritePage.id: (context) => MyFavouritePage(),
        HomePage.id: (context) => HomePage(),
        CustomerProfilePage.id: (context) => CustomerProfilePage()
      },
    );
  }
}
