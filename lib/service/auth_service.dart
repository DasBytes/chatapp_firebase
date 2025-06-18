import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // Login



  //Register
  Future registerUserWithEmailandPassword(String fullName, String email, String password ) async {
   try {
     User user= await firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password))
      .user!;

      if(user!=null)
      {

        // call our database to update the user data
        return true;
      }





   } on FirebaseAuthException catch (e) {
     print(e);
   }




  // Signout

}
