import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Stream? groups;

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

      // getting the list pf snapshots in our stream
  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then(sn) {
    setState(() {
      groups = snapshot;
    });
  }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          nextScreenReplace(context, const SearchPage() );
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
            Text(userName,
            textAlign: TextAlign.center,
            style:const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),

            ListTile(
              onTap: (){

              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",
              style: TextStyle(color: Colors.black),
              ),

            ),
             ListTile(
              onTap: (){
                nextScreenReplace(context,  ProfilePage(
                  userName: userName,
                  email: email,
                ));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",
              style: TextStyle(color: Colors.black),
              ),

            ),

             ListTile(
              onTap: () async {
                
                showDialog(
                  barrierDismissible: false,
                  context: context, builder: (context){
                  return AlertDialog(
                    title: const Text("Logout"),
                    content:const Text("Are you sure you want to logout?"),
                    actions: [
                      IconButton(onPressed:  () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel, color: Colors.red,),
                      ),
                       

                      IconButton(onPressed:  ()  async {
                      await authService.signOut();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginPage()),
                      (route) => false);
                       
                      },
                      icon: const Icon(Icons.done, color: Colors.green,),
                      ),

                    ],
                  );
                });
                authService.signOut().whenComplete(() {
                  nextScreenReplace(context, const LoginPage());
                });
              },
            
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout",
              style: TextStyle(color: Colors.black),
              ),

            )



           
          ],
        ),
      ),
    body: groupList(),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        popUpDialog(context);
      },
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
      
      ),
    );
  }

  popUpDialog(BuildContext context) {}
  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, snapshot),
    );

  }
}