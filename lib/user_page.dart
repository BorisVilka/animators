

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserState();
  }
  
}
class UserState extends State<UserPage> {
  var isAut = false;
  var first = true;
  var load = true;
  var user = FirebaseAuth.instance.currentUser;
  var count = 0;
  var map = {};

  void getDate() async {
    var res = await FirebaseFirestore.instance.collection("main").doc("${user!.email}").get();
    if(res.data()!=null) {
      setState(() {
        load = false;
        map = res.data()!;
        count = res.data()!["count"];
        isAut = res.data()!["isAnimator"];
      });
    } else {
      setState(() {
        load = false;
        map = {};
        count = 0;
        isAut = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(first) {
      first = false;
      getDate();
    }
    return Scaffold(
      body: load ? Center(
        child: CircularProgressIndicator(),
      ) :
      SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              actions: [
                GestureDetector(
                  onTap: () async {
                    var res = await Navigator.of(context).pushNamed("/editUser");
                    setState(() {
                      user = FirebaseAuth.instance.currentUser;
                      if(res!=null) map = res as Map<String,dynamic>;
                    });
                  },
                  child: Icon(Icons.edit),
                ),
                SizedBox(width: 15,),
                Icon(Icons.settings),
                SizedBox(width: 10,)
              ],
              backgroundColor: Theme.of(context).primaryColor,
            ),
            GestureDetector(
              onTap: () async {
                var res = await Navigator.of(context).pushNamed("/editUser");
                setState(() {
                  user = FirebaseAuth.instance.currentUser;
                  if(res!=null) map = res as Map<String,dynamic>;
                });
              },
              child: Container(
                width: 120,
                height: 120,
                margin: EdgeInsets.only(top: 5,bottom: 10),
                padding: EdgeInsets.all(5),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 35,
                    child: user!.photoURL==null ? Icon(Icons.person, size: 60,color: Colors.grey,) :
                    Container(
                      padding: EdgeInsets.all(2), // Border width
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(55  ), // Image radius
                          child: Image.network(user!.photoURL!, fit: BoxFit.cover),
                        ),
                      ),
                    )
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Text("${user?.displayName}"),
            ),
            Divider(
              color: Colors.grey,
              height: 2,
            ),
            if(map["isAnimator"])  GestureDetector(
              onTap:() async {
                var res =  await Navigator.of(context).pushNamed("/add",arguments: {"count": count, "map":map,"edit":false}) ;
                if(res!=null) {
                  setState(() {
                    count++;
                    map = (res as Map<String,dynamic>)["map"];
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.add_box_outlined),
                    SizedBox(width: 5,),
                    Text("Добавить объявление"),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            if(map["isAnimator"]) Divider(
              color: Colors.grey,
              height: 2,
            ),
            if(map["isAnimator"])  GestureDetector(
              onTap:() async {
                var res =  await Navigator.of(context).pushNamed("/ads_list",arguments: {"count": count, "map":map,"edit":false}) as Map<String,dynamic>;
                if(res!=null) {
                  setState(() {

                  });
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.list_alt),
                    SizedBox(width: 5,),
                    Text("Мои обявления"),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            if(map["isAnimator"]) Divider(
              color: Colors.grey,
              height: 2,
            ),
            GestureDetector(
              onTap:() async {
                Navigator.of(context).pushNamed("/subs");
              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.subscriptions_outlined),
                    SizedBox(width: 5,),
                    Text("Подписки"),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 2,
            ),
            GestureDetector(
              onTap:() async {
                  Navigator.of(context).pushNamed("/help");
              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.help_outline),
                    SizedBox(width: 5,),
                    Text("Помощь"),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 2,
            ),
            GestureDetector(
              onTap:() async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).popAndPushNamed("/");
              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 5,),
                    Text("Выйти"),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}