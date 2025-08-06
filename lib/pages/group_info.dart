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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0,1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,

                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),

                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${widget.adminName}")
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}