
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

class MessageList {
  String? name, pers1, pers2, photo1, photo2, label1, label2;
  String? author_ads,title;
  int? ind;
  List<Message> list;
  MessageList({required this.list, required this.name, required this.author_ads,
  required this.pers1, required this.ind, required this.pers2, required this.photo1,required this.photo2, required this.title,
  required this.label1, required this.label2});

  factory MessageList.fromFirsetore(
      DocumentSnapshot<Map<String,dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    var data = snapshot.data();
    return MessageList(list: List<Message>.from((data?["list"] ?? []).map((e) => Message.fromFirestore(e as Map<String, dynamic>)).toList()),
      name: data?["name"], author_ads: data?["author_ads"], pers1: data?["pers1"], pers2: data?["pers2"],
      ind: data?["ind"], photo1: data?['photo1'],photo2: data?['photo2'], title: data?['title'], label1: data?['label1'], label2: data?['label2'],
    );
  }
  
  Map<String,dynamic> toFirestore() => {
    "list": List<Map<String,dynamic>>.from(list.map((e) => e.toFirestore())),
    "pers1": pers1,
    "pers2": pers2,
    "name": name,
    "author_ads": author_ads,
    "title": title,
    "photo1": photo1,
    "photo2": photo2,
    "ind": ind,
    "label1": label1,
    "label2": label2
  };
}