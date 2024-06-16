import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wareg_app/Controller/PrefController.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  

  var prefController = Get.put(PrefController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Profile"),
          ElevatedButton(
            onPressed: (){
              prefController.clearData().then((value){
                Navigator.pushReplacementNamed(context, "/login");
              });
            },
            child: Text("Logout"))
        ],
      ),
    );
  }
}