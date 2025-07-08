import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // Login



  //Register
  Future registerUserWithEmailandPassword(String fullName, String email, String password ) async {
   try {
     User user= (await firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password))
      .user!;

      if(user!=null)
      {
          // call our database to update the user data
       await DatabaseService(uid: user.uid).updateUserData(fullName, email);
       
      
        return true;
      }





   } on FirebaseAuthException catch (e) {
  
     return e.message;
   }




  // Signout

}
}
