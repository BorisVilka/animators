
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'fb/subs_list.dart';

class AdsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AdsState();
  }

}

class AdsState extends State<AdsPage> {

  var data;
  var userData;
  String? photo = "";
  var ind;
  var author;
  var first = true;
  var not_found = false;
  var load = true;
  var user = FirebaseAuth.instance.currentUser;
  SubsList subs = SubsList(list: [], name: "");


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(first) {
      first = false;
      getSubs();
    }
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    ind = arguments["ind"];
    author = arguments["author"];
    if(arguments["data"]!=null) {
      data = arguments["data"];
      userData = arguments["user"];
      photo = arguments["photo"];
    }
    var photos = (data["photos"] ?? "").trim().split(" ");
    var cats = (data["filters"] ?? "").trim().split("|");
    var cat = "";
    for(String i in cats) {
      cat += i+", ";
    }
    if(cat.isNotEmpty) cat = cat.substring(0,cat.length-2);
    else cat = "Отсутствуют";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 295,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                itemBuilder: (c,ind){
                  return GestureDetector(
                    onTap: (){
                      _showImageDialog(context, photos[ind]);
                    },
                    child: Image.network(photos[ind]),
                  );
                },
              ),
            ),
           Container(
             margin: EdgeInsets.only(left: 10,right: 10,top: 10),
             child:  Text(data['title'], style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),),
           ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child:  Text(userData['city'], style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),),
            ),
            Container(
              margin: EdgeInsets.only(left: 5,right: 5,top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(onPressed: () {
                      Navigator.of(context).pushNamed("/chat",arguments: {
                        "data": data,
                        "user": userData,
                      });
                    }, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail_outline_rounded, color: Colors.black,),
                        SizedBox(width: 5,),
                        Text("Написать",style: TextStyle(color: Colors.limeAccent))
                      ],
                    )
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                      UrlLauncher.launchUrl(Uri.parse("tel://${userData["phone"]}"));
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
              margin: EdgeInsets.only(left: 10,right: 10,top: 15),
              child:  Text("Вид услуги", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child:  Text(cat, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 20),
              child:  Text("Описание", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child:  Text((data["desc"] as String).isNotEmpty ? (data["desc"] as String) : "Отсутствует", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.of(context).pushNamed("/profile",arguments:{"data":userData,"photo":photo, "email":data["author"],"subs":subs});
                getSubs();
              },
              child: Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.only(left: 5,right: 5,top: 20,bottom: 10),
                child: Card(
                  color: Colors.grey[300],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(userData["name"]),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: getRevs(),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 35,
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
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10,right: 10,bottom: 20),
              child: ElevatedButton(
                onPressed: () async {
                  if(subs.list.contains(data["author"])) {
                    subs.list.remove(data["author"]);
                  } else {
                    subs.list.add(data["author"]);
                  }
                  setState(() {

                  });
                  FirebaseFirestore.instance.collection("subs").doc(user!.email!).set(subs.toFirestore());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(subs.list.contains(data["author"]) ? Icons.done_all : Icons.person_add_outlined,color: Theme.of(context).primaryColor,),
                    SizedBox(width: 15,),
                    Text(subs.list.contains(data["author"]) ? "Вы подписаны" : "Подписаться",style: TextStyle(color: Theme.of(context).primaryColor),)
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
          ],
        ),
      ),
    );
  }
  List<Widget> getRevs() {
    var ans = <Widget>[];
    var rev = (userData["reviews_count"]==0 ? 0.0 :(userData["reviews_sum"]/userData["reviews_count"] as double));
    ans.add(Text(rev.toStringAsPrecision(2),style: TextStyle(fontSize: 16),textAlign: TextAlign.end,));
    ans.add(SizedBox(width: 10,));
    for(int i = 1;i<=5;i++) {
      ans.add(Icon(Icons.star,color: i<=rev ? Colors.amber : Colors.grey,size: 16,));
    }
    ans.add(SizedBox(width: 5,));
    ans.add(Text("${userData["reviews_count"]} отзывов",style: TextStyle(color: Colors.grey[600]),));
    return ans;
  }
  _showImageDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      builder: (_) => Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onHorizontalDragEnd: (e){
              Navigator.of(context).pop();
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Image.network(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
  void getData() async {
    var res = await FirebaseFirestore.instance.collection("ads").doc("${author}_${ind}").get();
    if(res.exists) {
      var tmp = res.data();
      setState(() {
        data = tmp;
      });
     var res1 = await FirebaseFirestore.instance.collection("main").doc("${author}").get();
     if(res1.exists) {
       setState(() {
         userData = res1.data();
         load = false;
       });
     } else {
       setState(() {
         not_found = true;
         load = false;
       });
     }
    } else {
      setState(() {
        not_found = true;
        load = false;
      });
    }
  }
  void getSubs() async {
    var res = await FirebaseFirestore.instance.collection("subs").doc(user!.email!).withConverter(fromFirestore: SubsList.fromFirestore, toFirestore: (SubsList d,_)=>d.toFirestore()).get();
    if(res.exists) {
      setState(() {
        subs = res.data()!;
        load = false;
      });
    } else {
      setState(() {
        subs = SubsList(list: [], name: user!.email!);
        load = false;
      });
    }
  }
}