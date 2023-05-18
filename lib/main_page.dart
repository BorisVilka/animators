
import 'package:animators/chat_list.dart';
import 'package:animators/home_page.dart';
import 'package:animators/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return MainState();
  }

}
class MainState extends State<MainPage> {

  var _ind = 0;
  var _pages = [
    HomePage(),
    ChatListPage(),
    UserPage()
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded),
          label: "Главная",
        ),
          BottomNavigationBarItem(icon: Icon(Icons.chat),
            label: "Сообщения",
          ),
        BottomNavigationBarItem(icon: Icon(Icons.person),
            label: "Профиль"
        ),
      ],currentIndex: _ind,
        onTap: (f){
          setState(() {
              _ind = f;
          });
        },
      ),
      body: _pages[_ind],
    );
  }

}