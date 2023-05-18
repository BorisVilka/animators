
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddAdsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddAdsState();
  }

}

class AddAdsState extends State<AddAdsPage> {

  var loaded = false;
  var user = FirebaseAuth.instance.currentUser;
  var _paths = [];
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  var c = false;
  var urls = [];
  var all = [
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
  var ch = [
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false, false,  false, false, false,  false,  false,
  ];
  var count = 0;
  var map = <String,dynamic> {
  };
  var edit = false;
  var first = true;
  var data = <String,dynamic>{};

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    edit = arguments["edit"];
    count = arguments["count"];
    map = arguments["map"];
    if(edit && first) {
      first = false;
      data = arguments["data"];
      setState(() {
        _desc.text = data["desc"];
        _title.text = data["title"];
        var list = (data["filters"] as String).trim().split("|");
        for(String i in list) {
          ch[all.indexOf(i)] = true;
        }
        urls = (data["photos"] as String).trim().split(" ");
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Добавить объявление"),
      ),
      body: loaded ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                margin: EdgeInsets.only(left: 10,top: 5),
                child: Text("Фото:",style: TextStyle(
                  fontSize: 20
                ),),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                height: 160,
                child: ListView(
                  children: getImages(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Название",
                    fillColor: Colors.black12,
                    filled: true,
                    errorText: _title.text.isNotEmpty ? null : "Введите Название"
                ),
                controller: _title,
                maxLines: 1,
                keyboardType: TextInputType.text,
                onChanged: (s) {setState(() {});},
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
              child: TextField(
                maxLines: 100000,
                minLines: 2,
                decoration: InputDecoration(
                  labelText: "Описание",
                  fillColor: Colors.black12,
                  filled: true,
                ),
                controller: _desc,
                onChanged: (s) {setState(() {});},
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,top: 5),
              child: Text("Категории:",style: TextStyle(
                  fontSize: 20
              ),),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children:getFilters()
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              width: double.infinity,
              child: ElevatedButton(onPressed: () async {
               if(_desc.text.isNotEmpty && _title.text.isNotEmpty && (_paths.isNotEmpty || urls.isNotEmpty)) {
                 setState(() {
                   loaded = true;
                 });
                 if(!edit) {
                   var s = "";
                   for(int i = 0;i<all.length;i++) {
                     if(ch[i]) {
                       s+=all[i]+"|";
                     }
                   }
                   if(s.isNotEmpty) s = s.substring(0,s.length-1);
                   print(s+" "+(s.trim().split("|").length.toString()));
                   var list = [];
                   var ref = FirebaseStorage.instance.ref("ads/${user!.email!}/ad$count");
                   for(int i = 0;i<_paths.length;i++) {
                     var child = ref.child("$i.png");
                     await child.putFile(File(_paths[i]));
                     list.add(await child.getDownloadURL());
                   }
                   print(list.toString());
                   var photos = "";
                   for(String i in list) {
                     photos += "$i ";
                   }
                   var ads = {
                     "ind": count,
                     "filters": s,
                     "photos": photos.trim(),
                     "title": _title.text,
                     "desc": _desc.text,
                     "author": user!.email!
                   };
                   await FirebaseFirestore.instance.collection("ads").doc("${user!.email!}_$count").set(ads);
                   count++;
                   map["count"] = count;
                   await FirebaseFirestore.instance.collection("main").doc(user!.email!).set(map);
                   Navigator.pop(context,{"map":map});
                 } else {
                   var s = "";
                   for(int i = 0;i<all.length;i++) {
                     if(ch[i]) {
                       s+=all[i]+"|";
                     }
                   }
                   if(s.isNotEmpty) s = s.substring(0,s.length-1);
                   var old = (data["photos"] as String).trim().split(" ");
                   for(String i in old) {
                     if(!urls.contains(i)) {
                       await FirebaseStorage.instance.refFromURL(i).delete();
                     }
                   }
                   var list = [];
                   var ref = FirebaseStorage.instance.ref("ads/${user!.email!}/ad$count");
                   var m = await ref.listAll();
                   var c = 0;
                   for(Reference i in m.items) {
                     c = max(c, int.parse(i.name.split(".")[0]));
                   }
                   for(int i = 0;i<_paths.length;i++) {
                     var child = ref.child("${c+i+1}.png");
                     await child.putFile(File(_paths[i]));
                     list.add(await child.getDownloadURL());
                   }
                   var photos = "";
                   for(String i in list) {
                     photos += "$i ";
                   }
                   for(String i in urls) {
                     photos += "$i ";
                   }
                   var ads = {
                     "ind": count,
                     "filters": s,
                     "photos": photos.trim(),
                     "title": _title.text,
                     "desc": _desc.text,
                     "author": user!.email!
                   };
                   await FirebaseFirestore.instance.collection("ads").doc("${user!.email!}_$count").set(ads);
                   Navigator.pop(context,{"map":ads});
                 }
               }
              }, child: Text(edit ? "Редактировать": "Добавить",style: TextStyle(color: Colors.limeAccent)),
                
              ),
            )
          ],
        ),
      ),
    );
  }
  List<Widget> getImages() {
    var ans = <Widget>[
        GestureDetector(
          onTap: () async {
            var res = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.image
            );
            if(res!=null) {
              setState(() {
               for(String? i in res.paths) {
                 if(!_paths.contains(i)) _paths.add(i);
               }
              });
            }
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.add,size: 50,),
          ),
        )
    ];
    for(String i in _paths) {
      ans.add(
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Image.file(File(i),fit: BoxFit.fill,),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                      setState(() {
                        _paths.remove(i);
                      });
                  },
                  icon: Icon(Icons.close),
                ),
              )
            ],
          ),
        )
      );
    }
    for(String i in urls) {
      ans.add(
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Image.network(i,fit: BoxFit.fill,),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        urls.remove(i);
                      });
                    },
                    icon: Icon(Icons.close),
                  ),
                )
              ],
            ),
          )
      );
    }
    return ans;
  }

  List<FilterChip> getFilters() {
    var ans = <FilterChip>[];
    for(int i = 0;i<all.length;i++) {
      ans.add(
          FilterChip(label: Text(all[i]), onSelected: (b){
            setState(() {
              ch[i] = b;
            });
          },
            selected: ch[i],
            selectedColor: Theme.of(context).primaryColor,
          )
      );
    }
    return ans;
  }
}