

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddReviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddReviewState();
  }

}
class AddReviewState extends State<AddReviewPage> {

  TextEditingController _desc = TextEditingController();
  var count = 0;
  var data = <String,dynamic>{};
  var email = "";
  var loading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    data = arguments["data"];
    email = arguments["email"];

   return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Оставить отзыв"),
      ),
     body: loading ?  Center(child:CircularProgressIndicator()) : SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           SizedBox(height: 20,),
           Text("Поставьте оценку",style: TextStyle(fontSize: 20),),
           SizedBox(height: 20,),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               IconButton(onPressed: (){
                 setState(() {
                   count = 1;
                 });
               }, icon: Icon(Icons.star, color: count>=1 ? Colors.amber : Colors.grey,size: 50,)),
               SizedBox(height: 5,),
               IconButton(onPressed: (){
                 setState(() {
                   count = 2;
                 });
               }, icon: Icon(Icons.star, color:  count>=2 ? Colors.amber : Colors.grey,size: 50,)),
               SizedBox(height: 5,),
               IconButton(onPressed: (){
                 setState(() {
                   count = 3;
                 });
               }, icon: Icon(Icons.star, color:  count>=3 ? Colors.amber : Colors.grey,size: 50,)),
               SizedBox(height: 5,),
               IconButton(onPressed: (){
                 setState(() {
                   count = 4;
                 });
               }, icon: Icon(Icons.star, color:  count>=4 ? Colors.amber : Colors.grey,size: 50,)),
               SizedBox(height: 5,),
               IconButton(onPressed: (){
                 setState(() {
                   count = 5;
                 });
               }, icon: Icon(Icons.star, color:  count>=5 ? Colors.amber : Colors.grey,size: 50,)),
             ],
           ),

           Container(
             margin: EdgeInsets.only(left: 10,right: 10,bottom: 15,top: 20),
             child: TextField(
               maxLines: 100000,
               minLines: 2,
               decoration: InputDecoration(
                 labelText: "Отзыв",
                 fillColor: Colors.black12,
                 filled: true,
               ),
               controller: _desc,
               onChanged: (s) {setState(() {});},
             ),
           ),
           Container(
             width: double.infinity,
             margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
             child: ElevatedButton(
               onPressed: () async {
                 if(count==0 || _desc.text.isEmpty) return;
                  var map = {
                    "from": FirebaseAuth.instance.currentUser!.email,
                    "label_author": FirebaseAuth.instance.currentUser!.displayName,
                    "to": email,
                    "count": count,
                    "desc": _desc.text
                  };
                  data["reviews_sum"] += count;
                  data["reviews_count"]++;
                  FirebaseFirestore.instance.collection("reviews").doc("${map.hashCode}").set(map);
                  FirebaseFirestore.instance.collection("main").doc(email).set(data);
                  Navigator.of(context).pop();
               },
               child: Text("Оставить отзыв"),
             ),
           )
         ],
       ),
     ),
   );
  }

}