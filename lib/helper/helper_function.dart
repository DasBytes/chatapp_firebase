import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

// keys
     static String userLoggedInKey= "LOGGEDINKEY";
     static String userNameKey= "USERNAMEKEY";
     static String userEmailKey="USEREMAILKEY";


  // saving the data to share preferences




// getting the data from share preferences
   
   static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf= await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
   }


}