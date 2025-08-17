import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/home_page.dart';
import 'package:chatapp_firebase/pages/auth/register_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  StreamSubscription? internetSubscription;

  // Create GoogleSignIn instance globally
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    super.initState();

    // Listen to connectivity changes
    internetSubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        showSnackBar(context, Colors.red, "You are offline");
      } else {
        showSnackBar(context, Colors.green, "You are back online");
      }
    });
  }

  @override
  void dispose() {
    internetSubscription?.cancel();
    super.dispose();
  }

  // Check internet connection
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Vibric",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Log in and catch up on the chat!",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Image.asset("assets/login.png"),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+-=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : 'Please enter a valid email';
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least six characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: login,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/google-logo.png',
                            height: 24,
                          ),
                          label: const Text(
                            "Sign in with Google",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: signInWithGoogle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          showForgotPasswordDialog();
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Register here",
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const RegisterPage());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Email/Password Login
  login() async {
    if (!await hasInternetConnection()) {
      showSnackBar(
          context, Colors.red, "You are offline. Please connect to the internet.");
      return;
    }

    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var value =
            await authService.loginWithUserNameandPassword(email, password);

        if (value == true) {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null && !user.emailVerified) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text("Email not verified"),
                content: Text(
                    "Please verify your email ($email) before logging in. Check your inbox."),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await user.sendEmailVerification();
                      Navigator.of(context).pop();
                      showSnackBar(context, Colors.green,
                          "Verification email resent to $email");
                    },
                    child: const Text("Resend Email"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }

          QuerySnapshot snapshot = await DatabaseService(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        showSnackBar(context, Colors.red, e.toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Google Sign-In
signInWithGoogle() async {
  if (!await hasInternetConnection()) {
    showSnackBar(
        context, Colors.red, "You are offline. Please connect to the internet.");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    // Sign out previous Google session if any
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      setState(() => _isLoading = false);
      return; // User canceled
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    if (googleAuth.idToken == null) {
      showSnackBar(context, Colors.red, "Google sign-in failed. Try again.");
      setState(() => _isLoading = false);
      return;
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken!,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    User? user = userCredential.user;
    if (user != null) {
      QuerySnapshot snapshot =
          await DatabaseService(uid: user.uid).gettingUserData(user.email!);

      if (snapshot.docs.isEmpty) {
        await DatabaseService(uid: user.uid)
            .savingUserData(user.displayName!, user.email!);
        await HelperFunctions.saveUserNameSF(user.displayName!);
      } else {
        await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
      }

      await HelperFunctions.saveUserLoggedInStatus(true);
      await HelperFunctions.saveUserEmailSF(user.email!);

      nextScreenReplace(context, const HomePage());
    }
  } catch (e) {
    showSnackBar(context, Colors.red, e.toString());
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  // Forgot Password
  void showForgotPasswordDialog() {
    String resetEmail = "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "Enter your registered email",
            hintText: "example@email.com",
          ),
          onChanged: (val) {
            resetEmail = val;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (resetEmail.isNotEmpty &&
                  RegExp(r"^[a-zA-Z0-9.!#$%&'*+-=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(resetEmail)) {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: resetEmail);
                  Navigator.of(context).pop();
                  showSnackBar(context, Colors.green,
                      "Password reset link sent to $resetEmail");
                } catch (e) {
                  showSnackBar(context, Colors.red, e.toString());
                }
              } else {
                showSnackBar(
                    context, Colors.red, "Please enter a valid email");
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }
}
