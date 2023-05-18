
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryListState();
  }

}
class CategoryListState extends State<CategoryListPage> {

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColor,
        title: Text("Все категории"),
      ),
      body: ListView(
        children: ListTile.divideTiles(context: context, tiles: all.map((e) => ListTile(title: Text(e), onTap: (){
          Navigator.of(context).pushNamed("/search",arguments: {
            "category": e,
            'city': arguments['city']
          });
        },))).toList(),
      ),
    );
  }

}