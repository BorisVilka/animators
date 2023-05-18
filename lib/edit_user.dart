

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditUserState();
  }

}
class EditUserState extends State<EditUserPage> {

  var user = FirebaseAuth.instance.currentUser;
  var url = null;
  var path = null;
  var first = true;
  var ch = false;
  var load = true;
  var count = 0;
  var map = {};
  TextEditingController _name = TextEditingController();
  TextEditingController _sur = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _phone = TextEditingController();
  var cities = ["Москва","Санкт-Петербург","Екатеринбург","Нижний Новгород","Ростов-на-Дону","Уфа","Казань","Пермь","Волгоград","Омск","Самара","Новосибирск","Сочи","Грозный","Ярославль","Владимир","Тула","Краснодар","Воронеж","Анапа","Красноярск","Тверь","Владивосток",
    "Астрахань","Вологда","Тюмень","Калуга","Смоленск","Великий Новгород","Новороссийск","Рязань","Саратов","Волгоград","Чебоксары","Иваново","Кострома","Иркутск","Тольятти","Оренбург","Киров","Севастополь","Липецк","Калининград","Курск","Белгород","Орёл"
    ,"Пенза","Рыбинск","Ижевск","Барнаул","Ульяновск","Новокузнецк","Балашиха","Ставрополь","Улан-удэ","Магнитогорск","Брянск","Сургут","Чита","Симферополь","Якутск","Волжский","Саранск","Череповец","Курган","Подольск","Владикавказ","Тамбов","Мурманск","Химки"
    ,"Нижневартовск","Петрозаводск","Йошкар-Ола","Стерлитамак","Таганрог","Сыктывкар","Нальчик","Комсомольск-на-Амуре","Нижнекамск","Энгельс","Дзержинск","Королёв","Абакан","Благовещенск","Норильск","Сызрань","Керчь","Дербент","Каспийск"];
  var city = "Москва";


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(first) {
      first = false;
      getDate();
      setState(() {
        url = user?.photoURL;
        _name.text = user!.displayName!.trim().split(" ").first;
        _sur.text = user!.displayName!.trim().split(" ").last;
      });
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColor,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () async {
              if(_name.text.isEmpty || _sur.text.isEmpty || !(_phone.text.length==12 && _phone.text.startsWith("+7")) && _phone.text.isNotEmpty) return;
              setState(() {
                load = true;
              });
                if(path!=null) {
                  var res = await FirebaseStorage.instance.ref().child("users/${user!.email}.png").putFile(File(path));
                  var url = await res.ref.getDownloadURL();
                  await user!.updatePhotoURL(url);
                }
                await user!.updateDisplayName("${_name.text} ${_sur.text}");
                await FirebaseFirestore.instance.collection("main").doc("${user!.email}").set(
                    {
                      "desc": _desc.text,
                      "phone":_phone.text,
                      "city": city,
                      "isAnimator": map["isAnimator"],
                      "count": count,
                      "name": user!.displayName,
                      "reviews_sum": map["reviews"] ?? 0,
                      "reviews_count": map["reviews_count"] ?? 0,
                      "enableLogin": map["enableLogin"]
                     }
                    );
                var map1 = {
                  "desc": _desc.text,
                  "phone":_phone.text,
                  "city":city,
                  "isAnimator": map["isAnimator"],
                  "count": count,
                  "name": user!.displayName,
                  "reviews_sum": map["reviews"] ?? 0,
                  "reviews_count": map["reviews_count"] ?? 0,
                  "enableLogin": map["enableLogin"]
                };
                Navigator.of(context).pop(map1);
            },
            child: Text("Сохранить",textAlign: TextAlign.center,),
          ),
        )
      ],),
      body: load ? Center(
        child: CircularProgressIndicator(),
      ) :
      SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                var res = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.image
                );
                if(res!=null) {
                  setState(() {
                    path = res.paths[0];
                  });
                }
              },
              child: Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.only(top: 5,bottom: 20),
                decoration: (path==null && url==null) ? BoxDecoration(
                    color: Colors.grey
                ) : null,
                padding: EdgeInsets.all(5),
                child: (url==null && path==null) ? Icon(Icons.person, size: 65,color: Colors.white,) :
                (path!=null ? Image.file(File(path),fit: BoxFit.fill,) : Image.network(url)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text("Данные профиля"),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Введите имя",
                    labelText: "Имя",
                    fillColor: Colors.black12,
                    filled: true,
                    errorText: _name.text.isNotEmpty ? null : "Введите имя"
                ),
                controller: _name,
                keyboardType: TextInputType.text,
                onChanged: (s) {setState(() {});},
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 35),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Введите фамилию",
                    labelText: "Фамилия",
                    fillColor: Colors.black12,
                    filled: true,
                    errorText: _sur.text.isNotEmpty ? null : "Введите фамилию"
                ),
                controller: _sur,
                keyboardType: TextInputType.text,
                onChanged: (s) {setState(() {});},
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 10),
              child: Text("Город",style: TextStyle(
                  color: Colors.purple
              ),),
            ),
            Container(
              width: double.infinity,

              margin: EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: city,
                items: getList(),
                onChanged: (s) {
                  setState(() {
                    city = s!;
                  });
                },
                isExpanded: true,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 45),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Введите телефон",
                    labelText: "Телефон",
                    fillColor: Colors.black12,
                    filled: true,
                    errorText: _phone.text.isNotEmpty ? (
                      (_phone.text.length==12 && _phone.text.startsWith("+7")) ? null : "Неверный номер"
                    ) : "Введите телефон"
                ),
                controller: _phone,
                keyboardType: TextInputType.number,
                onChanged: (s) {setState(() {});},
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
              child: TextField(
                maxLines: 100000,
                minLines: 2,
                decoration: InputDecoration(
                  labelText: "О нас",
                  fillColor: Colors.black12,
                  filled: true,
                ),
                controller: _desc,
                onChanged: (s) {setState(() {});},
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getDate() async {
    var res = await FirebaseFirestore.instance.collection("main").doc("${user!.email}").get();
    if(res.data()!=null) {
      setState(() {
        load = false;
        map = res.data()!;
        city = res.data()!["city"];
        _desc.text = res.data()!["desc"];
        _phone.text = res.data()!["phone"];
        ch = res.data()!["isAnimator"];
        count = res.data()!["count"];
      });
    } else {
      setState(() {
        map = {};
        load = false;
        city = "Москва";
        _desc.text = "";
        _phone.text = "";
        ch = false;
        count = 0;
      });
    }
  }

  List<DropdownMenuItem<String>> getList() {
    var ans = <DropdownMenuItem<String>>[];
    for(String i in cities) {
      ans.add(DropdownMenuItem(child: Text(i),value: i,));
    }
    return ans;
  }
}