

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fb/subs_list.dart';

class SubsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SubsState();
  }

}
class SubsState extends State<SubsPage> {

  bool first = true;
  bool load = true;
  User user = FirebaseAuth.instance.currentUser!;
  SubsList data = SubsList(list: [], name: "");
  var userData = {};
  var photos = {};

  @override
  Widget build(BuildContext context) {
    if(first) {
      first = false;
      getData();

    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
        body: load ? Center(child: CircularProgressIndicator(),)
      : ListView.builder(itemBuilder: (c,ind){
          return getListItem(data.list[ind]);
        },
        itemCount: data.list.length,
        ),
    );
  }

  void getPhoto(String author) async {
    try {
      var res = await FirebaseStorage.instance.ref("users/${author}.png").getDownloadURL();
      print(res);
      setState(() {
        photos[author] = res;
      });
    } on Exception catch(e) {
      setState(() {
        photos[author] = "";
      });
    }
  }
  void getUser(String user) async {
    var res = await FirebaseFirestore.instance.collection("main").doc(user).get();
    if(res.data()!=null) {
      setState(() {
        userData[user] = res.data()!;
      });
    }
  }

  Widget getListItem(String aut) {
    var load1 = false;
    if(photos[aut]==null) {
      getPhoto(aut);
      load1 = true;
    }
    if(userData[aut]==null) {
      getUser(aut);
      load1 = true;
    }
    return load1 ? Container(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed("/profile",arguments: {
          "data": userData[aut],
          "email": aut,
          "photo": photos[aut],
        });
      },
      child: Container(
          margin: EdgeInsets.only(left: 5,right: 5,bottom: 10),
          child: Card(
            elevation: 5,
            child:  Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 5),
                        alignment: Alignment.bottomLeft,
                        child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 55,
                            child: photos[aut]=="" ? Icon(Icons.person, size: 40,color: Colors.grey,) :
                            Container(
                              padding: EdgeInsets.all(2), // Border width
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(58), // Image radius
                                  child: Image.network(photos[aut], fit: BoxFit.cover),
                                ),
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10,right: 10),
                        child: Text("${userData[aut]?["name"] ?? ""}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10,right: 10),
                        child: Row(
                          children: [
                            Icon(Icons.star,color: Colors.amber,),
                            SizedBox(width: 5,),
                            Text(userData[aut]?["reviews_count"]==0 ? "0" :(userData[aut]?["reviews_sum"]/userData[aut]?["reviews_count"] as double).toStringAsPrecision(2),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text("(Отзывов: ${userData[aut]?["reviews_count"]})",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10,right: 10),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,color: Colors.black,),
                            SizedBox(width: 5,),
                            Text(userData[aut]["city"],
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
  
  void getData() async {
    var res = await FirebaseFirestore.instance.collection("subs").doc(user.email!).withConverter(fromFirestore: SubsList.fromFirestore, toFirestore: (SubsList d,_)=>d.toFirestore()).get();
    if(res.exists) {
      setState(() {
        data = res.data()!;
        load = false;
      });
    } else {
      setState(() {
        data = SubsList(list: [], name: user.email!);
        load = false;
      });
    }
  }

}