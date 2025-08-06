import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
    {Key?key,
    required this.groupId,
    required this.groupName,
    required this.adminName
    }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async
  {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
    .getGroupsMembers(widget.groupId)
    .then((val){
      setState(() {
        members = val;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Groups Info"),
        actions: [
          IconButton(onPressed: (){

          },
           icon: const Icon(Icons.exit_to_app))
        ],
      ),
      
    );
  }
}