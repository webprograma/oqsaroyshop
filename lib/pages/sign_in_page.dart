import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/sign_up_page.dart';
import 'package:instaclone/pages/vital_pages/mymainpage.dart';
import 'package:instaclone/pages/vital_pages/upload_page.dart';
import 'package:instaclone/servise/firebase_servise.dart';

class SignInPage extends StatefulWidget {
  static final String id = '2';
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if (email.isEmpty || password.isEmpty) return;

    FireBaseService.signInUser(email, password).then((User? firebaseUser) {
      isLoading = true;
      if (firebaseUser != null) {
        responseSignIn(firebaseUser);
      } else {
        print('Sign-in failed');
      }
    });
  }

  void responseSignIn(User firebaseUser) {
    isLoading = false;
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  callNextSignUp() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash.jpg'),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //email
                Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white54.withOpacity(0.2)),
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 17, color: Colors.blue)),
                  ),
                ),

                SizedBox(
                  height: 12,
                ),
                //password
                Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white54.withOpacity(0.2)),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                        hintText: "Parol",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 17, color: Colors.blue)),
                  ),
                ),

                SizedBox(
                  height: 12,
                ),
                //button
                InkWell(
                  onTap: () {
                    _doSignIn();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white54.withOpacity(0.2)),
                    child: Center(
                      child: Text(
                        "Kirish",
                        style: TextStyle(color: Colors.blue, fontSize: 17),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                //text

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Hisobingiz yoqmi : ",
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                    TextButton(
                        onPressed: callNextSignUp,
                        child: Text(
                          "Ro'yhatdan otish",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
    ;
  }
}
