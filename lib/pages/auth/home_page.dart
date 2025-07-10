import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String userName = "";
  String email= "";

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email= value! ;
      });
    },);
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
        
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          nextScreen(context, const SearchPage() );
        }, icon: const Icon(Icons.search))],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Groups", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(Icons.account_circle, 
            size: 150,
            color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,

            ),
            Text(userName)

           
          ],
        ),
      ),
    );
  }
}