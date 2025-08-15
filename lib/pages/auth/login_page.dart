import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  StreamSubscription? internetSubscription;

  @override
  void initState() {
    super.initState();
    // Listen for internet connection changes
    internetSubscription = Connectivity().onConnectivityChanged.listen((result) {
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

  // Snackbar helper
  void showSnackBar(BuildContext context, Color color, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Check internet
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  // Email/Password login
  Future<void> login() async {
    if (!await hasInternetConnection()) {
      showSnackBar(context, Colors.red, "You are offline. Please connect to the internet.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      showSnackBar(context, Colors.green, "Login Successful");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, Colors.red, e.message ?? "Login failed");
    }

    setState(() => _isLoading = false);
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    if (!await hasInternetConnection()) {
      showSnackBar(context, Colors.red, "No internet connection. Try again later.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // User cancelled sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      showSnackBar(context, Colors.green, "Google Sign-In Successful");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, Colors.red, e.message ?? "Google Sign-In failed");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("Sign in with Google"),
              onPressed: signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
