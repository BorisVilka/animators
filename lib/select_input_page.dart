
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SelectState();
  }

}
class SelectState extends State<SelectInputPage> {
  bool ch = false;
  void check() {
    if(FirebaseAuth.instance.currentUser!=null) {
      Future.delayed(const Duration(milliseconds: 50), () {
        Navigator.of(context).popAndPushNamed("/main");
      });
    } else {
      setState(() {
        ch = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build\
    check();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: !ch ? Center(child: CircularProgressIndicator(),)
      : Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150,),
            CircleAvatar(
              radius: 75,
              child:
              Container(
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(75), // Image radius
                    child: Image.asset("images/icon.JPEG", width: 150,height: 150,fit: BoxFit.cover,),
                  ),
                ),
              )
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Все что нужно для отличного праздника - здесь!",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.white),textAlign: TextAlign.center,),
            ),
            SizedBox(height: 50,),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton.icon(
                  //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/login');
                  }, icon: Icon(Icons.mail_outline,color: Colors.black,), label: Text('Вход',style: TextStyle(color: Colors.limeAccent))),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.limeAccent)
                  ),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/register');
                  }, icon: Icon(Icons.app_registration,color: Colors.black), label: Text('Регистрация',style: TextStyle(color: Colors.purple[200]),)),
            ),
            SizedBox(height: 70,),
            Container(
              width: double.infinity,
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton.icon(
                //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/help');
                  }, icon: Icon(Icons.help_outline,color: Colors.black,), label: Text('Поддержка',style: TextStyle(color: Colors.limeAccent))),
            ),
            SizedBox(height: 25,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Регистрируясь, входя или продолжая, я соглашаюсь с Условиями использования Праздникids и принимаю Политику конфиденциальности Праздникids. Я согласен с тем, что Праздникids может использовать мой адрес электронной почты в маркетинговых целях. Я могу отказаться от этого в любое время через мои настройки.",
              style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
            )
          ],
        ),
      )
    );
  }

}