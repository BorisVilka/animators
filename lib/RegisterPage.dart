import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }

}

class RegisterState extends State<RegisterPage> {

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _sur = TextEditingController();
  TextEditingController _pass = TextEditingController();
  var type = "null";
  var cities = ["Москва","Санкт-Петербург","Екатеринбург","Нижний Новгород","Ростов-на-Дону","Уфа","Казань","Пермь","Волгоград","Омск","Самара","Новосибирск","Сочи","Грозный","Ярославль","Владимир","Тула","Краснодар","Воронеж","Анапа","Красноярск","Тверь","Владивосток",
    "Астрахань","Вологда","Тюмень","Калуга","Смоленск","Великий Новгород","Новороссийск","Рязань","Саратов","Волгоград","Чебоксары","Иваново","Кострома","Иркутск","Тольятти","Оренбург","Киров","Севастополь","Липецк","Калининград","Курск","Белгород","Орёл"
    ,"Пенза","Рыбинск","Ижевск","Барнаул","Ульяновск","Новокузнецк","Балашиха","Ставрополь","Улан-удэ","Магнитогорск","Брянск","Сургут","Чита","Симферополь","Якутск","Волжский","Саранск","Череповец","Курган","Подольск","Владикавказ","Тамбов","Мурманск","Химки"
    ,"Нижневартовск","Петрозаводск","Йошкар-Ола","Стерлитамак","Таганрог","Сыктывкар","Нальчик","Комсомольск-на-Амуре","Нижнекамск","Энгельс","Дзержинск","Королёв","Абакан","Благовещенск","Норильск","Сызрань","Керчь","Дербент","Каспийск"];
  var city = "Москва";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }
  void init() async {

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return Scaffold(
      appBar: AppBar(title: Text("Регистрация"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: !isLoading ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Введите email",
                    labelText: "Email",
                    fillColor: Colors.black12,
                    filled: true,
                    errorText: _email.text.isNotEmpty ? null : "Введите email"
                ),
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: true,
                autocorrect: true,
                onChanged: (s) {setState(() {});},
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Введите имя",
                    labelText: "Имя",
                    fillColor: Colors.black12,
                    filled: true,
                    errorText: _name.text.isNotEmpty ? null : "Введите имя"
                ),
                controller: _name,
                keyboardType: TextInputType.name,
                enableSuggestions: true,
                autocorrect: true,
                onChanged: (s) {setState(() {});},
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Введите фамилию",
                    labelText: "Фамилия",
                    fillColor: Colors.black12,
                    filled: true,
                    errorText: _sur.text.isNotEmpty ? null : "Введите фамилию"
                ),
                controller: _sur,
                keyboardType: TextInputType.name,
                enableSuggestions: true,
                autocorrect: true,
                onChanged: (s) {setState(() {});},
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Введите пароль",
                    labelText: "Пароль",
                    fillColor: Colors.black12,
                    filled: true,
                    errorText: _email.text.isNotEmpty ? null : "Введите пароль"
                ),
                controller: _pass,
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (s) {setState(() {});},
              ),
            ),
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 50),
              child: Text("Выберите город",style: TextStyle(
                  color: Colors.purple
              ),),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 50),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: const Text('Я аниматор (Для входа вам нужно подождать, когда регистрация будет одобрена)'),
                leading: Radio<String>(
                  fillColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  focusColor: Theme.of(context).primaryColor,
                  value: "anim",
                  groupValue: type,
                  onChanged: (String? value) {
                    setState(() {
                      type = value!;
                    });
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: const Text('Я клиент'),
                leading: Radio<String>(
                  fillColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  focusColor: Theme.of(context).primaryColor,
                  value: "client",
                  groupValue: type,
                  onChanged: (String? value) {
                    setState(() {
                      type = value!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 40,),
            ElevatedButton(onPressed: () async {
              if(_email.text.isNotEmpty && _pass.text.isNotEmpty && _name.text.isNotEmpty && _sur.text.isNotEmpty && type!="null") {
                try {
                  var res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text, password: _pass.text);
                  if(res.user!=null) {
                    await res.user!.updateDisplayName("${_name.text} ${_sur.text}");

                    await FirebaseFirestore.instance.collection("main").doc("${res.user!.email!}").set(
                        {
                          "desc": "",
                          "phone":"",
                          "city": city,
                          "isAnimator": type=="anim",
                          "count": 0,
                          "name": res.user!.displayName,
                          "reviews_sum":  0,
                          "reviews_count": 0,
                          "enableLogin": type!="anim"
                        });
                    Navigator.pop(context);
                    if(type!="anim") {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/main");
                    } else {
                      FirebaseAuth.instance.signOut();
                    }
                  }
                }  on FirebaseAuthException catch(e) {
                  setState(() {
                    isLoading = false;
                  });
                  if(e.code=="weak-password") {
                    Fluttertoast.showToast(
                        msg: "Пароль должен быть длиннее 6 символов",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0
                    );
                  }  else if(e.code=="email-already-in-use") {
                    Fluttertoast.showToast(
                        msg: "Такой email существует",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0
                    );
                  }
                }
              }
            },
              child: Text("Зарегистрироваться",style: TextStyle(color: Colors.limeAccent)),
              style: Theme.of(context).elevatedButtonTheme.style,
            ),
            SizedBox(height: 15,)
          ],
        ) : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getList() {
    var ans = <DropdownMenuItem<String>>[];
    for(String i in cities) {
      ans.add(DropdownMenuItem(child: Text(i),value: i,));
    }
    return ans;
  }
}