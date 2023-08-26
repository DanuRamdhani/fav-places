import 'package:fav_places/screen/auth.dart';
import 'package:fav_places/screen/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;
  bool isCantSeePw = true;

  Future<void> _login() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      await firebase.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isAuthenticating = false;
      });
      if (error.code == 'email-already-in-use') {
        //
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Addres',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty ||
                  !value.contains('@')) {
                return 'Please enter a valid email addres.';
              }

              return null;
            },
            onSaved: (newValue) {
              _enteredEmail = newValue!;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              isDense: true,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isCantSeePw = !isCantSeePw;
                  });
                },
                icon: const Icon(Icons.remove_red_eye_rounded),
              ),
            ),
            obscureText: isCantSeePw,
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return 'Password must be at least 6 characters long.';
              }

              return null;
            },
            onSaved: (newValue) {
              _enteredPassword = newValue!;
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              elevation: 8,
              padding: const EdgeInsets.all(0),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: _isAuthenticating
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Log in'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Dont have an account!'),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUp(),
                  ));
                },
                child: Text(
                  'Signup',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
