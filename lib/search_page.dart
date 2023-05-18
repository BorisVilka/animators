
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchState();
  }

}
class SearchState extends State<SearchPage> {


  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('');
  TextEditingController search = TextEditingController();
  var auto = false;

  var addSearch = false;
  var filt = "";

  var user = FirebaseAuth.instance.currentUser;
  bool first = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedCat = [];
  var sort = 0;
  List<Map<String,dynamic>> data = [];
  var userData = {};
  String? email = "";
  var sorting = [
    "По умолчанию",
    "По количеству отзывов",
    "По рейтингу"
  ];
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

  var cities = ["Москва","Санкт-Петербург","Екатеринбург","Нижний Новгород","Ростов-на-Дону","Уфа","Казань","Пермь","Волгоград","Омск","Самара","Новосибирск","Сочи","Грозный","Ярославль","Владимир","Тула","Краснодар","Воронеж","Анапа","Красноярск","Тверь","Владивосток",
    "Астрахань","Вологда","Тюмень","Калуга","Смоленск","Великий Новгород","Новороссийск","Рязань","Саратов","Волгоград","Чебоксары","Иваново","Кострома","Иркутск","Тольятти","Оренбург","Киров","Севастополь","Липецк","Калининград","Курск","Белгород","Орёл"
    ,"Пенза","Рыбинск","Ижевск","Барнаул","Ульяновск","Новокузнецк","Балашиха","Ставрополь","Улан-удэ","Магнитогорск","Брянск","Сургут","Чита","Симферополь","Якутск","Волжский","Саранск","Череповец","Курган","Подольск","Владикавказ","Тамбов","Мурманск","Химки"
    ,"Нижневартовск","Петрозаводск","Йошкар-Ола","Стерлитамак","Таганрог","Сыктывкар","Нальчик","Комсомольск-на-Амуре","Нижнекамск","Энгельс","Дзержинск","Королёв","Абакан","Благовещенск","Норильск","Сызрань","Керчь","Дербент","Каспийск"];
  var selC = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(first) {
      final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
      if(arguments["category"]!=null) {
        setState(() {
          auto = true;
          selectedCat.add(all.indexOf(arguments["category"]));
        });
      }
      if(arguments['city']!=null) selC.add(arguments['city']);
      email = arguments["email"];
      if(arguments["search"]!=null) {
        setState(() {
          filt = arguments["search"];
          addSearch = true;
          search.text = arguments["search"];
          customIcon = const Icon(Icons.cancel);
          customSearchBar = ListTile(
            leading: GestureDetector(
              onTap: () {
                print(search.text);
                  setState(() {
                    if(search.text.isNotEmpty) {
                      addSearch = true;
                      filt = search.text;
                    }
                });
              },
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 28,
              ),
            ),
            title: TextField(
              onSubmitted: (s) {
                print(s);
                if(search.text.isNotEmpty) {
                 setState(() {
                   addSearch = true;
                   filt = search.text;
                 });
                }
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
          auto = false;
        });
      }
      first = false;
      getData();
    }
    return Scaffold(
      key: scaffoldKey,
        appBar: AppBar(
          title: customSearchBar,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: auto,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          setState(() {
                            if(search.text.isNotEmpty) {
                              addSearch = true;
                              filt = search.text;
                            }
                          });
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: TextField(
                        onSubmitted: (s) {
                          setState(() {
                            if(search.text.isNotEmpty) {
                              addSearch = true;
                              filt = search.text;
                            }
                          });
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
                    auto = false;
                  } else {
                    auto = true;
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
      body: ListView(
          children: getViews(),
      ),
    );
  }

  var photos = {};
  void getData() async {
    var res = await FirebaseFirestore.instance.collection("ads").get();
    for(QueryDocumentSnapshot<Map<String,dynamic>> i in res.docs) {
        setState(() {
          data.add(i.data());
        });
        print(i.data());
    }

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
  TrackingScrollController controller = TrackingScrollController();
  List<Widget> getViews() {
    var ans = <Widget>[
      Container(
        margin: EdgeInsets.only(bottom: 10,top: 5),
        width: double.infinity,
        color: Colors.white10,
        height: 40,
        child: ListView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: 10,),
            ElevatedButton(
              onPressed: (){
                scaffoldKey.currentState?.showBottomSheet((c) => citySheet());
              }, child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: Row(
                children: [
                  Text("Город", style: TextStyle(color: selC.isEmpty ? Colors.black : Theme.of(context).primaryColor)),
                  SizedBox(width: 5,),
                  Icon(Icons.keyboard_arrow_down_rounded, color: selC.isEmpty ? Colors.black : Theme.of(context).primaryColor,),
                ],
              ),
            ),
              style: ElevatedButton.styleFrom( //<-- SEE HERE
                  side: BorderSide(
                      width: 1.5,
                      color: Colors.grey[400]!
                  ),
                  backgroundColor: Colors.white
              ),
            ),
            SizedBox(width: 10,),
            ElevatedButton(
              onPressed: (){
                scaffoldKey.currentState?.showBottomSheet((c) => sortingSheet());
              }, child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: Row(
                children: [
                  Text("Сортировка", style: TextStyle(color: sort==0 ? Colors.black : Theme.of(context).primaryColor)),
                  SizedBox(width: 5,),
                  Icon(Icons.keyboard_arrow_down_rounded, color: sort==0 ? Colors.black : Theme.of(context).primaryColor,),
                ],
              ),
            ),
              style: ElevatedButton.styleFrom( //<-- SEE HERE
                  side: BorderSide(
                      width: 1.5,
                      color: Colors.grey[400]!
                  ),
                  backgroundColor: Colors.white
              ),
            ),
            SizedBox(width: 10,),
            Container(
              child:  ElevatedButton(
                onPressed: (){
                  scaffoldKey.currentState?.showBottomSheet((c) => categorySheet());
                }, child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: Row(
                  children: [
                    Text("Категория аниматора", style: TextStyle(color: selectedCat.isEmpty ? Colors.black : Theme.of(context).primaryColor),),
                    SizedBox(width: 5,),
                    Icon(Icons.keyboard_arrow_down_rounded, color: selectedCat.isEmpty ? Colors.black : Theme.of(context).primaryColor,),
                  ],
                ),
              ),
                style: ElevatedButton.styleFrom( //<-- SEE HERE
                    side: BorderSide(
                        width: 1.5,
                        color: Colors.grey[400]!
                    ),
                    backgroundColor: Colors.white
                ),
              ),
            ),
            SizedBox(width: 10,),
          ],
        ),
      ),
      if(selectedCat.isNotEmpty || sort!=0 || filt.isNotEmpty || selC.isNotEmpty) Container(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: getChips()
        ),
      )
    ];
    var tmp = data
        .where((element) => (element["author"] as String)!=(user!.email ?? ""))
        .where((element) {
      var filters = (element["filters"] as String).trim().split("|");
      var ans = true;
      for(int i in selectedCat) {
        if(!filters.contains(all[i])) {
          ans = false;
          break;
        }
      }
      return ans;
    }).where((element) {
      var ans = false;
      if(element["desc"].contains(filt) || element["title"].contains(filt) || (userData[element["author"]]!=null && (
          userData[element["author"]]["desc"].contains(filt) || userData[element["author"]]["name"].contains(filt)
          || userData[element["author"]]["city"].contains(filt)
        ))) ans = true;
      return ans;
    }).toList();
    if(selC.isNotEmpty) {
      tmp = tmp.where((element) => userData[element["author"]]==null || selC.contains(userData[element["author"]]["city"])).toList();
    }
    if(sort==0) {
      tmp.shuffle();
    } else {
      tmp.sort((s1,s2){
      if(userData[s1["author"]]==null) return -1;
      if(userData[s2["author"]]==null) return 1;
      if(sort==1) {
        return userData[s1["author"]]["reviews_count"]-userData[s2["author"]]["reviews_count"];
      } else {
        return (userData[s1["author"]]["reviews_count"]==0 ? 0 :
        userData[s1["author"]]["reviews"]/userData[s1["author"]]["reviews_count"])-(userData[s2["author"]]["reviews_count"]==0 ? 0 :
        userData[s2["author"]]["reviews"]/userData[s2["author"]]["reviews_count"]);
      }
      });
    }
    if(email!=null) {
      tmp = tmp.where((element) => element["author"]==email).toList();
    }
     for(Map<String,dynamic> i in tmp) {
      ans.add(getListItem(i));
    }
    return ans;
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
  Widget categorySheet() {
    return Container(
        height: 450,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.close)),
                Text("Категория аниматора",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Готово",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                SizedBox(width: 5,)
              ],
            ),
            Divider(
              color: Colors.black54,
              height: 1.5,
            ),
            Container(
              height: selectedCat.isNotEmpty ? 350 : 400,
              child: ListView.builder(
                shrinkWrap: true,
                  itemCount: all.length,
                  itemBuilder: (c,ind){
                    return ListTile(
                      title: Text(all[ind]),
                      trailing: selectedCat.contains(ind) ? Icon(Icons.done,color: Theme.of(context).primaryColor,) : null,
                      onTap: (){
                        setState(() {
                          if(!selectedCat.contains(ind)) {
                            selectedCat.add(ind);
                          } else {
                            selectedCat.remove(ind);
                          }
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  }
              ),
            ),
            if(selectedCat.isNotEmpty) GestureDetector(
              onTap: (){
                setState(() {
                  selectedCat.clear();
                });
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.grey[300],
                height: 50,
                child: Center(
                  child: Text("Сбросить",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
  List<Widget> getChips() {
    var ans = <Widget>[];
    if(sort!=0) ans.add(
      Container(
        margin: EdgeInsets.only(left: 10),
        child: Chip(label: Text(sorting[sort],
          style: TextStyle(color: Colors.white),
        ),
          backgroundColor: Theme.of(context).primaryColor,
          deleteIcon: Container(
            padding: EdgeInsets.all(2),
            child: Icon(Icons.close,size: 15,),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
            ),
          ),
          onDeleted: (){
            setState(() {
              sort = 0;
            });
          },
        ),
      )
    );
    if(filt.isNotEmpty) ans.add(
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Chip(label: Text(filt,
            style: TextStyle(color: Colors.white),
          ),
            backgroundColor: Theme.of(context).primaryColor,
            deleteIcon: Container(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close,size: 15,),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
            ),
            onDeleted: (){
              setState(() {
                filt = "";
              });
            },
          ),
        )
    );
    for(int i in selectedCat) {
      ans.add(
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Chip(label: Text(all[i],
            style: TextStyle(color: Colors.white),
          ),
            backgroundColor: Theme.of(context).primaryColor,
            deleteIcon: Container(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close,size: 15,),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
            ),
            onDeleted: (){
              setState(() {
                selectedCat.remove(i);
              });
            },
          ),
        )
      );
    }
    for(String i in selC) {
      ans.add(
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Chip(label: Text(i,
              style: TextStyle(color: Colors.white),
            ),
              backgroundColor: Theme.of(context).primaryColor,
              deleteIcon: Container(
                padding: EdgeInsets.all(2),
                child: Icon(Icons.close,size: 15,),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                ),
              ),
              onDeleted: (){
                setState(() {
                  selC.remove(i);
                });
              },
            ),
          )
      );
    }
    return ans;
  }

  Widget sortingSheet() {
    return Container(
      height: 450,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.close)),
              Text("Сортировка",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Text("Готово",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
              SizedBox(width: 5,)
            ],
          ),
          Divider(
            color: Colors.black54,
            height: 1.5,
          ),
          Container(
            height: 350,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: sorting.length,
                itemBuilder: (c,ind){
                  return ListTile(
                    title: Text(sorting[ind]),
                    trailing: sort == ind ? Icon(Icons.done,color: Theme.of(context).primaryColor,) : null,
                    onTap: (){
                      setState(() {
                        sort = ind;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }
            ),
          ),
          if(sort!=0) GestureDetector(
            onTap: (){
              setState(() {
                sort = 0;
              });
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.grey[300],
              height: 50,
              child: Center(
                child: Text("Сбросить",
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget citySheet() {
    return Container(
      height: 450,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.close)),
              Text("Город",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Text("Готово",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
              SizedBox(width: 5,)
            ],
          ),
          Divider(
            color: Colors.black54,
            height: 1.5,
          ),
          Container(
            height: 350,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: cities.length,
                itemBuilder: (c,ind){
                  return ListTile(
                    title: Text(cities[ind]),
                    trailing: selC.contains(cities[ind]) ? Icon(Icons.done,color: Theme.of(context).primaryColor,) : null,
                    onTap: (){
                      setState(() {
                        if(!selC.contains(cities[ind])) selC.add(cities[ind]);
                        else selC.remove(cities[ind]);
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }
            ),
          ),
          if(selC.isNotEmpty) GestureDetector(
            onTap: (){
              setState(() {
                selC.clear();
              });
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.grey[300],
              height: 50,
              child: Center(
                child: Text("Сбросить",
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}