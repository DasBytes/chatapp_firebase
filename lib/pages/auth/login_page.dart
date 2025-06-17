import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey= GlobalKey<FormState>();
  String email="";
  String password="";
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar:AppBar(
      //  backgroundColor: Theme.of(context).primaryColor,
    ) ,
   

    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Form(
          key: formKey,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [
               const Text("Groupie!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
           const SizedBox(height: 10,),
           const Text("Login now to see what they are talking!", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          Image.asset("assets/login.png"),
          TextFormField(
            decoration: textInputDecoration.copyWith(
              labelText: "Email",
              prefixIcon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
              )),

              onChanged: (val){
                setState(() {
                  email= val;
                
                });
              },

              // check the validation

           validator: (val) {
  return RegExp(r"^[a-zA-Z0-9.!#$%&'*+-=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
      ? null
      : 'Please rnter a valid email';
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
              )
            ),
            validator: (val){
              if(val!.length < 6){
                return "Password must be atleast six characters";
              }
              else {
                return null;
              }
            },
            onChanged: (val){
                setState(() {
                  password= val;
              
                });

              },
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                )
              ),
              child:const Text(
                "Sign In",
                 style: TextStyle(color: Colors.white, fontSize: 16),
                 ) ,
                 onPressed: () {
                   login();
                 },
                 ),
          ),
          const SizedBox(height: 10,),
          Text.rich(TextSpan(
            text: "Don't have an account? ",
             style: const TextStyle(color: Colors.black, fontSize: 14),
            children: <TextSpan>[
            TextSpan(
              text: "Register here",
              style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
              recognizer: TabGestureRecognizer()..onTab = () {

              }

            ),
            ],
           
          )
          ),
            ],
      
          ),
        ),
      ),
    ),
   );
  }
  login() {

  }
  
}