import 'package:animators/RegisterPage.dart';
import 'package:animators/SubsPage.dart';
import 'package:animators/add_ads.dart';
import 'package:animators/ads_page.dart';
import 'package:animators/category_list.dart';
import 'package:animators/chat_list.dart';
import 'package:animators/chat_page.dart';
import 'package:animators/edit_user.dart';
import 'package:animators/help_page.dart';
import 'package:animators/login_page.dart';
import 'package:animators/main_page.dart';
import 'package:animators/my_ads_list.dart';
import 'package:animators/profile_page.dart';
import 'package:animators/reviews_page.dart';
import 'package:animators/search_page.dart';
import 'package:animators/select_input_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';

import 'add_review.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // if(FirebaseAuth.instance.currentUser==null) await FirebaseAuth.instance.signInAnonymously();
  Firestore.initialize("animators-918eb");
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (BuildContext)=>SelectInputPage(),
        '/register': (BuildContext)=>RegisterPage(),
        '/login': (BuildContext)=>LoginPage(),
        "/main": (BuildContext)=>MainPage(),
        '/editUser':(BuildContext)=>EditUserPage(),
        '/categories':(BuildContext)=>CategoryListPage(),
        "/add":(BuildContext)=>AddAdsPage(),
        "/search":(BuildContext)=>SearchPage(),
        "/ads_list":(BuildContext)=>AdsList(),
        "/ads": (BuildContext)=>AdsPage(),
        "/profile":(BuildContext)=>ProfilePage(),
        "/reviews":(BuildContext)=>ReviewsPage(),
        "/add_review": (BuildContext)=>AddReviewPage(),
        "/chat_list": (BuildContext)=>ChatListPage(),
        "/chat":(BuildContext)=>ChatPage(),
        "/help":(BuildContext)=>HelpPage(),
        "/subs": (BuildContext)=>SubsPage()
      },
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.deepPurple[300],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:  ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.purple[200]),
          textStyle: MaterialStateProperty.all(TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600,fontSize: 18))
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.black12,
        filled: true,
        labelStyle: TextStyle(
          color: Colors.purple,
        ),
        activeIndicatorBorder: BorderSide(
          color: Colors.purple
        )
      )
    ),
  ));
}
