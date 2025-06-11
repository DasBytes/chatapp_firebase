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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}