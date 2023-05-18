

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }

}

class LoginState extends State<LoginPage> {

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Вход"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: !isLoading ? Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
              child: TextField(
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                    focusColor: Theme.of(context).primaryColor,
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
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/help");
              },
              child: Container(
                child: Text("Забыли пароль?",style: TextStyle(
                    color: Colors.blue
                ),),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 15),
              width: double.infinity,
              child: ElevatedButton(onPressed: () async {
                if(_email.text.isNotEmpty && _pass.text.isNotEmpty) {
                  var res = await FirebaseFirestore.instance.collection("main").doc(_email.text).get();
                  if(res.exists) {
                    if(res.data()!["enableLogin"]) {
                      try {
                        var res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _pass.text);
                        if(res.user!=null) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/main");
                        }
                      } on FirebaseAuthException catch(e) {
                        setState(() {
                          isLoading = false;
                        });
                        print(e.code);
                        if (e.code == 'user-not-found') {
                          Fluttertoast.showToast(
                              msg: "Пользователь не найден",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0
                          );
                        } else if (e.code == 'wrong-password') {
                          Fluttertoast.showToast(
                              msg: "Неверный пароль",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0
                          );
                        }
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Регистрация не одобрена. Напишите в поддержку или подождите некоторое время.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16.0
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Пользователь не найден",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0
                    );
                  }
                }

              }, child: Text("Вход",style: TextStyle(color: Colors.limeAccent))),
            )
          ],
        ) : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

}