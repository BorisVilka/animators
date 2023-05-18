
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class HelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HelpState();
  }
  
}
class HelpState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Поддержка"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("О службе поддержки",style: TextStyle(fontSize: 20, color: Colors.red[900],fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),),
            SizedBox(height: 15,),
            Text("Обращения обрабатываются по рабочим дням, с 9 до 19 по московскому времени.\n\nМы стараемся отвечать в течение 24 часов, но время может увеличиться, в зависимости от количества и сложности поступивших обращений. Если ответа долго нет, проверьте папку со спамом.\n\nИзлагайте суть обращения максимально осмысленно и подробно — это сократит количество уточняющих вопросов и поможет быстрее получить ответ.",
            style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            SizedBox(height: 15,),
            Text("Телефон",style: TextStyle(fontSize: 18,decoration: TextDecoration.underline,fontWeight: FontWeight.w700),),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                UrlLauncher.launchUrl(Uri.parse("tel://+79886780262"));
              },
              child: Text("8 (988) 678 02 62", style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18
              ),),
            ),
            SizedBox(height: 15,),
            Text("Email",style: TextStyle(fontSize: 18,decoration: TextDecoration.underline,fontWeight: FontWeight.w700),),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                UrlLauncher.launchUrl(Uri.parse("mailto:prazdnikids@gmail.com"));
              },
              child: Text("prazdnikids@gmail.com", style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18
              ),),
            )
          ],
        ),
      ),
    );
  }
  
}