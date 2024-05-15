import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instaclone/pages/sign_in_page.dart';

class FireBaseService {
  static final _auth = FirebaseAuth.instance;

  static bool isLoggedIn() {
    final User? firebaseUser = _auth.currentUser;
    return firebaseUser != null;
  }

  static String currentId() {
    final User? firebaseUser = _auth.currentUser;
    return firebaseUser!.uid;
  }

  static Future<User?> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = _auth.currentUser;
      return firebaseUser;
    } catch (e) {
      // Handle sign in error
      print('Sign in failed: $e');
      return null;
    }
  }

  static Future<User?> signUpUser(
      String name, String email, String password, String cpassword) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      return user;
    } catch (e) {
      // Handle sign up error
      print('Sign up failed: $e');
      return null;
    }
  }

  static void signOut(BuildContext context) {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }
}
