

import 'package:cloud_firestore/cloud_firestore.dart';

class SubsList {

  String name;
  List<String> list;

  SubsList({required this.list, required this.name});

  factory SubsList.fromFirestore(
      DocumentSnapshot<Map<String,dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    var data = snapshot.data();
    return SubsList(list: List<String>.from((data?["list"] ?? []).map((e) => e.toString()).toList()),
      name: data?["name"]);
  }

  Map<String,dynamic> toFirestore() => {
    "list": list,
    "name": name,
  };
}