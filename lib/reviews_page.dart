
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ReviewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReviewsState();
  }

}
class ReviewsState extends State<ReviewsPage> {

  var data = {};
  var email = "";
  List<Map<String,dynamic>> revs = [];
  var first = true;
  var arr = [0,0,0,0,0,0];
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    data = arguments["data"];
    email = arguments["email"];
    if(first) {
      first = false;
      getData();
    }
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Theme.of(context).primaryColor,
     ),
     body: SingleChildScrollView(
       child: Column(
         children: [
           Container(
             margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
             child: Column(
               children:getList()
             )
           )
         ],
       ),
     ),
   );
  }

  List<Widget> getList() {
    var d = data["reviews_count"]==0 ? 0 : (data["reviews_sum"]/data["reviews_count"] as double);
    var ans = <Widget>[
      Row(
        children: [
          Text((data["reviews_count"]==0 ? "0.0" :(data["reviews_sum"]/data["reviews_count"] as double).toStringAsPrecision(2)),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 40),),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star,color: d>=1 ? Colors.amber : Colors.grey,size: 20,),
                  Icon(Icons.star,color: d>=2 ? Colors.amber : Colors.grey,size: 20,),
                  Icon(Icons.star,color: d>=3 ? Colors.amber : Colors.grey,size: 20,),
                  Icon(Icons.star,color: d>=4 ? Colors.amber : Colors.grey,size: 20,),
                  Icon(Icons.star,color: d>=5 ? Colors.amber : Colors.grey,size: 20,),
                ],
              ),
              SizedBox(height: 5,),
              Text("На основании ${data["reviews_count"]} оценок")
            ],
          )
        ],
      ),
      SizedBox(height: 10,),
      Row(
        children: [
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          SizedBox(width: 10,),
          Expanded(child: GFProgressBar(
            progressBarColor: Theme.of(context).primaryColor,
            percentage: arr[5]/(data["reviews_count"]==0 ? 1 : data["reviews_count"]),
          )),
          SizedBox(width: 10,),
          Text("${arr[5]}")
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          SizedBox(width: 10,),
          Expanded(child: GFProgressBar(
            progressBarColor: Theme.of(context).primaryColor,
            percentage: arr[4]/(data["reviews_count"]==0 ? 1 : data["reviews_count"]),
          )),
          SizedBox(width: 10,),
          Text("${arr[4]}")
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          SizedBox(width: 10,),
          Expanded(child: GFProgressBar(
            progressBarColor: Theme.of(context).primaryColor,
            percentage: arr[3]/(data["reviews_count"]==0 ? 1 : data["reviews_count"]),
          )),
          SizedBox(width: 10,),
          Text("${arr[3]}")
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          SizedBox(width: 10,),
          Expanded(child: GFProgressBar(
            progressBarColor: Theme.of(context).primaryColor,
            percentage: arr[2]/(data["reviews_count"]==0 ? 1 : data["reviews_count"]),
          )),
          SizedBox(width: 10,),
          Text("${arr[2]}")
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          Icon(Icons.star,color: Colors.amber,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          Icon(Icons.star,color: Colors.grey,size: 20,),
          SizedBox(width: 10,),
          Expanded(child: GFProgressBar(
            progressBarColor: Theme.of(context).primaryColor,
            percentage: arr[1]/(data["reviews_count"]==0 ? 1 : data["reviews_count"]),
          )),
          SizedBox(width: 10,),
          Text("${arr[1]}")
        ],
      ),
      SizedBox(height: 10,),
      Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (){
            Navigator.of(context).pushNamed("/add_review",arguments: {
              "email": email,
              "data":data
            });
          },
          child: Text("Оставить отзыв"),
        ),
      )
    ];
    for(int i = 0;i<revs.length;i++) {
      ans.add(Container(
        margin: EdgeInsets.only(top: 10),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(revs[i]["label_author"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(Icons.star,color: revs[i]["count"]>=1 ? Colors.amber : Colors.grey,size: 20,),
                    Icon(Icons.star,color: revs[i]["count"]>=2 ? Colors.amber : Colors.grey,size: 20,),
                    Icon(Icons.star,color: revs[i]["count"]>=3 ? Colors.amber : Colors.grey,size: 20,),
                    Icon(Icons.star,color: revs[i]["count"]>=4 ? Colors.amber : Colors.grey,size: 20,),
                    Icon(Icons.star,color: revs[i]["count"]>=5 ? Colors.amber : Colors.grey,size: 20,),
                  ],
                ),
                SizedBox(height: 5,),
                Text(revs[i]["desc"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),)
              ],
            ),
          ),
        ),
      ));
    }
    return ans;
  }

  void getData() async {
    var res = await FirebaseFirestore.instance.collection("reviews").get();
    print("${res.docs.length}");
    for(QueryDocumentSnapshot<Map<String,dynamic>> i in res.docs) {
      var doc = i.data();
      if(doc["to"]==email) {
        setState(() {
          arr[doc["count"]]++;
          revs.add(doc);
          print(revs.length);
        });
      }
    }
  }

}