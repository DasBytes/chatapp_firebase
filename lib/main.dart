import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/home_page.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


void main() async
{ 
    WidgetsFlutterBinding.ensureInitialized();

    if(kIsWeb){

    // run the intialization for web
      await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: Constants.apiKey,
    appId: Constants.appId,
    messagingSenderId: Constants.messagingSenderId,
    projectId: Constants.projectId));
    runApp(const MyApp());

    }
    else {

         // run the intialization for web
         await Firebase.initializeApp();



    }

  
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  bool _isSignedIn = false;
    @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

   getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value){
    if(value!=null){
      setState(() {
        _isSignedIn= value;
      });

    }
    });
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor, 
        scaffoldBackgroundColor: Colors.white
      ),
        debugShowCheckedModeBanner: false,
        home: _isSignedIn? const HomePage(): const LoginPage(),
    );
  }
}