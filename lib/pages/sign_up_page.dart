import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/additional/member_model.dart';
import 'package:instaclone/main.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/sign_in_page.dart';
import 'package:instaclone/pages/vital_pages/mymainpage.dart';
import 'package:instaclone/servise/dbs_service.dart';
import 'package:instaclone/servise/firebase_servise.dart'; // Changed 'servise' to 'service'

class SignUpPage extends StatefulWidget {
  static final String id = '1';
  const SignUpPage({Key? key}) : super(key: key); // Added 'Key? key'

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cpasswordController = TextEditingController();
  var phoneNumberContoller = TextEditingController();

  _doSignUp() async {
    String fullname = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String phoneNumber = phoneNumberContoller.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = cpasswordController.text.toString().trim();

    if (fullname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phoneNumber.isEmpty) return;

    if (cpassword != password) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var response =
        await FireBaseService.signUpUser(fullname, email, password, cpassword);
    Member member = Member(fullname, email, isCustomer, phoneNumber);
    dialog(member);
  }

  void storeMemberToDB(Member member) {
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _callSignInPage() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  void dialog(Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Purpose of using'),
          content: Text('Want to use app as vendor or customer?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    DBService.storeMember(member, true).then((value) => {
                          storeMemberToDB(member),
                        });
                  },
                  child: Text('Customer'),
                ),
                TextButton(
                  onPressed: () {
                    DBService.storeMember(member, false).then((value) => {
                          storeMemberToDB(member),
                        });
                  },
                  child: Text('Vendor'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash.jpg'),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: fullnameController,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 17, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 17, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: phoneNumberContoller,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 17, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 17, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: cpasswordController,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 17, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: _doSignUp,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Allaqachon hisobingiz bormi : ",
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: _callSignInPage,
                      child: Text(
                        "Kirish",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
