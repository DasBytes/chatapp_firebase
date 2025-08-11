import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Login
  Future<String?> loginWithUserNameAndPassword(String email, String password) async {
    try {
      User? user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        // Save user info locally
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        return null; // null means success
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return "Unknown error occurred";
  }

  // Register
  Future<String?> registerUserWithEmailAndPassword(String fullName, String email, String password) async {
    try {
      User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserNameSF(fullName);
        await HelperFunctions.saveUserEmailSF(email);
        return null; // success
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return "Unknown error occurred";
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await _firebaseAuth.signOut();
    } catch (_) {}
  }
}
