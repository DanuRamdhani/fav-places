import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fav_places/widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _loginWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCridential = await firebase.signInWithCredential(credential);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCridential.user!.uid)
        .set({
      'email': userCridential.user!.email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Login(),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    fixedSize: const Size(50, 63),
                    padding: const EdgeInsets.all(0),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                  onPressed: _loginWithGoogle,
                  child: Image.asset(
                    'assets/images/google.png',
                    height: 54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
