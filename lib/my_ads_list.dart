
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AdsListState();
  }

}
class AdsListState extends State<AdsList> {

  List<Map<String,dynamic>> data = [];
  var user = FirebaseAuth.instance.currentUser;
  var userData = {};
  var first = true;
  var loaded = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(first) {
      first = false;
      getData();
    }
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    userData = arguments["map"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Мои объявления"),
      ),
      body: loaded ? Center(child: CircularProgressIndicator(),) : ListView(
        children: getViews(),
      ),
    );
  }
  void getData() async {
    var res = await FirebaseFirestore.instance.collection("ads").get();
    for(QueryDocumentSnapshot<Map<String,dynamic>> i in res.docs) {
      setState(() {
        if(i.data()["author"]==user!.email) data.add(i.data());
        loaded = false;
      });
      //print(i.data());
    }

  }
  List<Widget> getViews() {
    var ans = <Widget>[SizedBox(height: 10,)];
    for(int i = 0;i<data.length;i++) {
      ans.add(getListItem(data[i], i));
    }
    return ans;
  }
  Widget getListItem(Map<String,dynamic> map, int ind) {
    return GestureDetector(
      onTap: () async {
        var res = await Navigator.of(context).pushNamed("/add",arguments: {
          "map": userData,
          "count": map["ind"],
          "edit": true,
          "data": map
        });
        if(res!=null) {
          setState(() {
            data[ind] = (res as Map<String,dynamic>)["map"];
          });
        }
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
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10,right: 10),
                  child: Text("${user!.displayName ?? ""} | ${map["title"]}",
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
                      Text(userData["reviews_count"]==0 ? "0" : (userData["reviews_sum"]/userData["reviews_count"] as double).toStringAsPrecision(2),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text("(Отзывов: ${userData["reviews_count"]})",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Spacer(),
                      PopupMenuButton(itemBuilder: (c) {
                        return [
                          PopupMenuItem(child: Text("Удалить"),value: 12,)
                        ];
                      },
                        onOpened: (){
                          print("open");
                        },
                        onSelected: (d) {
                          print("delete");
                          showCupertinoDialog(context: context, builder: (c)=>
                              CupertinoAlertDialog(
                                title: Text("Вы действительно хотите удалить объявление?"),
                                actions: [
                                  CupertinoDialogAction(onPressed: () async {
                                    Navigator.of(context).pop();
                                  }, child: Text("Отмена")),
                                  CupertinoDialogAction(onPressed: () async {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      data.remove(map);
                                    });
                                    FirebaseFirestore.instance.collection("ads").doc("${user!.email}_${map["ind"]}").delete();
                                    var res = await FirebaseStorage.instance.ref("ads/${user!.email}/ad${map["ind"]}").listAll();
                                    for(Reference i in res.items) {
                                      i.delete();
                                      print(i.name);
                                    }
                                  }, child: Text("Да")),
                                ],
                              )
                          );
                        },
                        child: Icon(Icons.more_vert),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10,right: 10),
                  child: Row(
                    children: [
                      Icon(Icons.location_on,color: Colors.black,),
                      SizedBox(width: 5,),
                      Text(userData["city"],
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
                    onPressed: () async {
                      var res = await Navigator.of(context).pushNamed("/add",arguments: {
                        "map": userData,
                        "count": map["ind"],
                        "edit": true,
                        "data": map
                      });
                      if(res!=null) {
                        setState(() {
                          data[ind] = (res as Map<String,dynamic>)["map"];
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.edit,color: Colors.black,),
                        SizedBox(width: 5,),
                        Text("Редактировать",style: TextStyle(color: Colors.limeAccent))
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