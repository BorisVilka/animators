

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }

}
class HomeState extends State<HomePage> {

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('');
  TextEditingController search = TextEditingController();
  var userData = {};
  List<Map<String,dynamic>> data = [];
  var user = FirebaseAuth.instance.currentUser;
  bool first = true;
  var load = true;
  var cat = [
    "Агентство детских праздников ",
    "Аквагрим",
    "Аниматоры",
    "Детские квесты",
    "Детские центры",
    "Детский фотограф",
    "Другое",
    "Пространства для проведения детских праздников",
    "Ростовые куклы",
    "Тесла шоу",
    "Фокусы",
    "Шоу Мыльных Пузырей",
    "Шоу программы",
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(first) {
      setState(() {
        first = false;
      });
      getUser(user!.email!);
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed("/search",
                          arguments: {
                            'search': search.text,
                            'city':userData[user!.email!]["city"]
                          }
                        );
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    title: TextField(
                      onSubmitted: (s) {
                        Navigator.of(context).pushNamed("/search",
                            arguments: {
                              'search': search.text,
                              'city':userData[user!.email!]["city"]
                            }
                        );
                      },
                      controller: search,
                      decoration: InputDecoration(
                        hintText: 'Поиск',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  search.text = "";
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('');
                }
              });
            },
            icon: customIcon,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Row(
                children: [
                  Text("Найти аниматоров"),
                  Spacer(),
                  GestureDetector(
                      child: Text("СМОТРЕТЬ ВСЁ", style: TextStyle(
                          color: Colors.teal
                      ),),
                      onTap: (){
                        Navigator.of(context).pushNamed("/categories",arguments: {
                        'city':userData[user!.email!]["city"]
                        });
                      }
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: 240,
              child: ListView.builder(itemBuilder: (c,ind) {
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed("/search",arguments: {
                      "category": cat[ind],
                      'city':userData[user!.email!]["city"]
                    });
                  },
                  child: Container(
                    height: 240,
                    width: 240,
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Image.asset("images/t${ind+1}.jpg", height: 180,fit: BoxFit.fitHeight,),
                        SizedBox(height: 10,),
                        Text(cat[ind],textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                );
              },itemCount: 13,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,bottom: 15),
              child: Text("Популярные", textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
            ),
            load ? CircularProgressIndicator() : getViews()
          ],
        ),
      ),
    );
  }
  var photos = {};
  void getData() async {
    var res = await FirebaseFirestore.instance.collection("ads").get();
    var f = [];
    f.addAll(res.docs);
    f.shuffle();
    for(int i = 0;i<min(10, res.docs.length);i++) {
      setState(() {
        data.add(f[i].data());
      });
    }
    setState(() {
      load = false;
    });
  }
  Widget getViews() {
    var list = <Widget>[];
    for(Map<String,dynamic> i in data) {
      list.add(getListItem(i));
    }
    return Column(
      children: list,
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
  Widget getListItem(Map<String,dynamic> map) {
    var load = false;
    if(photos[map['author']]==null) {
      getPhoto(map['author']);
      load = true;
    }
    if(userData[map['author']]==null) {
      getUser(map['author']);
      load = true;
    }
    return load ? Container(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed("/ads",arguments: {
          "user": userData[map['author']],
          "photo": photos[map["author"]],
          "data": map
        });
      },
      child: Container(
          margin: EdgeInsets.only(left: 5,right: 5,bottom: 10),
          child: Card(
            elevation: 5,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.network((map["photos"] as String).split(" ")[0],height: 200,fit: BoxFit.fitWidth,width: double.infinity,filterQuality: FilterQuality.high,),
                    Container(
                      margin: EdgeInsets.only(left: 5, bottom: 5),
                      alignment: Alignment.bottomLeft,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 35,
                          child: photos[map["author"]]=="" ? Icon(Icons.person, size: 40,color: Colors.grey,) :
                          Container(
                            padding: EdgeInsets.all(2), // Border width
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(48), // Image radius
                                child: Image.network(photos[map["author"]], fit: BoxFit.cover),
                              ),
                            ),
                          )
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10,right: 10),
                  child: Text("${userData[map["author"]]?["name"] ?? ""} | ${map["title"]}",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500
                    ),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10,right: 10),
                  child: Row(
                    children: [
                      Icon(Icons.star,color: Colors.amber,),
                      SizedBox(width: 5,),
                      Text(userData[map["author"]]?["reviews_count"]==0 ? "0" :(userData[map["author"]]?["reviews_sum"]/userData[map["author"]]?["reviews_count"] as double).toStringAsPrecision(2),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text("(Отзывов: ${userData[map["author"]]?["reviews_count"]})",
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
                      Text(userData[map["author"]]["city"],
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () {
                      Navigator.of(context).pushNamed("/chat",arguments: {
                        "data": map,
                        "user": userData[map["author"]],
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.mail_outline_rounded, color: Colors.black,),
                        SizedBox(width: 5,),
                        Text("Отправить сообщение",style: TextStyle(color: Colors.limeAccent))
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}