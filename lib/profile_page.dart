
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'fb/subs_list.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }

}
class ProfileState extends State<ProfilePage> {

  var data = {};
  String? photo = "";
  var email = "";
  bool first = true;
  bool load = true;
  User user = FirebaseAuth.instance.currentUser!;
  SubsList subs = SubsList(list: [], name: "");

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if(first) {
      first = false;
     if(arguments["subs"]==null) getData();
     else {
       setState(() {
         load = false;
         subs = arguments["subs"];
       });
     }
    }
    data = arguments["data"];
    email = arguments["email"];
    photo = arguments["photo"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: load ? Center(child: CircularProgressIndicator(),)
      : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10,top: 15),
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 45,
                      child: photo=="" ? Icon(Icons.person, size: 40,color: Colors.grey,) :
                      Container(
                        padding: EdgeInsets.all(2), // Border width
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(48), // Image radius
                            child: Image.network(photo!, fit: BoxFit.cover),
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(width: 20,),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["name"],
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    SizedBox(height: 3,),
                    Text(data["city"],
                      style: TextStyle(
                          fontSize: 14
                      ),
                    ),
                    SizedBox(height: 3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: getRevs(),
                    ),
                    SizedBox(height: 5,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed("/reviews",arguments: {
                          "data":data,
                          "email": arguments["email"]
                        });
                      },
                      child: Text("${data["reviews_count"]} отзывов", style: TextStyle(color: Colors.blue),),
                    ),
                    SizedBox(height: 5,)
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 5,right: 5,top: 10),
              child: ElevatedButton(
                onPressed: () async {
                  if(subs.list.contains(arguments["email"])) {
                    subs.list.remove(arguments["email"]);
                  } else {
                    subs.list.add(arguments["email"]);
                  }
                  setState(() {

                  });
                  FirebaseFirestore.instance.collection("subs").doc(user.email!).set(subs.toFirestore());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(subs.list.contains(arguments["email"]) ? Icons.done_all : Icons.person_add_outlined,color: Theme.of(context).primaryColor,),
                    SizedBox(width: 15,),
                    Text(subs.list.contains(arguments["email"]) ? "Вы подписаны" : "Подписаться",style: TextStyle(color: Theme.of(context).primaryColor),)
                  ],
                ),
                style: ElevatedButton.styleFrom( //<-- SEE HERE
                    side: BorderSide(
                        width: 1.5,
                        color: Theme.of(context).primaryColor
                    ),
                    backgroundColor: Colors.white
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5,right: 5,top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                      Navigator.of(context).pushNamed("/chat",arguments: {
                        "userData": data,
                        "email": email,
                        "photo": photo
                      });
                    }, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail_outline_rounded, color: Colors.black,),
                        SizedBox(width: 5,),
                        Text("Написать",style: TextStyle(color: Colors.limeAccent),)
                      ],
                    )
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                      UrlLauncher.launchUrl(Uri.parse("tel://${data["phone"]}"));
                    }, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_outlined,color: Colors.black,),
                        SizedBox(width: 5,),
                        Text("Позвонить",style: TextStyle(color: Colors.purple[200]))
                      ],
                    ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.limeAccent)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,top: 10),
              child: Text("О себе",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,top: 10),
              child: Text(data["desc"],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
            ),
            if(data["isAnimator"]) Container(
              margin: EdgeInsets.only(left: 5,right: 5,top: 15),
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                Navigator.of(context).pushNamed("/search",arguments: {"email":email});
              }, child: Text("Показать объявления",style: TextStyle(color: Colors.limeAccent))),
            )
          ],
        ),
      ),
    );
  }


  List<Widget> getRevs() {
    var ans = <Widget>[];
    var rev = (data["reviews_count"]==0 ? 0.0 :(data["reviews_sum"]/data["reviews_count"] as double));
    ans.add(Text(rev.toStringAsPrecision(2),style: TextStyle(fontSize: 16),textAlign: TextAlign.end,));
    ans.add(SizedBox(width: 10,));
    for(int i = 1;i<=5;i++) {
      ans.add(Icon(Icons.star,color: i<=rev ? Colors.amber : Colors.grey,size: 16,));
    }
    ans.add(SizedBox(width: 5,));
    return ans;
  }
  void getData() async {
    var res = await FirebaseFirestore.instance.collection("subs").doc(user.email!).withConverter(fromFirestore: SubsList.fromFirestore, toFirestore: (SubsList d,_)=>d.toFirestore()).get();
    if(res.exists) {
      setState(() {
        subs = res.data()!;
        load = false;
      });
    } else {
      setState(() {
        subs = SubsList(list: [], name: user.email!);
        load = false;
      });
    }
  }
}