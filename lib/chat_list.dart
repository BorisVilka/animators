
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fb/message_list.dart';

class ChatListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatListState();
  }

}
class ChatListState extends State<ChatListPage> {

  var user = FirebaseAuth.instance.currentUser;
  List<MessageList> data = [];
  var load = true;
  var first = true;
  var months = [
    "янв.",
    "фев.",
    "мар.",
    "апр.",
    "мая",
    "июн.",
    "июл.",
    "авг.",
    "сен.",
    "окт.",
    "ноя.",
    "дек.",
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(first) {
      first = false;
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: load ? Center(child: CircularProgressIndicator(),)
      : (data.isEmpty ? Center(child: Text("Пока нет сообщений",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w500,fontSize: 24,color: Colors.purple[200]),),) : ListView.builder(itemBuilder: (c,ind) {
        return GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed("/chat",arguments: {
              "list": data[ind]
            });
          },
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 35,
                          child:
                          Container(
                            padding: EdgeInsets.all(2), // Border width
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(48), // Image radius
                                child: Image.network(data[ind].ind==null ? (data[ind].pers1!=user!.email ? data[ind].photo1! : data[ind].photo2!) : data[ind].photo2!, fit: BoxFit.cover,
                                  errorBuilder: (context,d,_) {
                                    return Icon(Icons.person, size: 40,color: Colors.grey,);
                                  },
                                ),
                              ),
                            ),
                          )
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data[ind].pers1==user!.email ? data[ind].label2 ?? "" : data[ind].label1 ?? "", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                          if(data[ind].title!=null) Text(data[ind].title!),
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: 200,
                            child: Text(data[ind].list[data[ind].list.length-1].message, style: TextStyle(
                                overflow: TextOverflow.ellipsis
                            ),
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Center(
                        child: Text(getDate(data[ind])),
                      )
                    ],
                  ),
                ),
                Divider(height: 2,),
              ],
            ),
          ),
        );
      },
        itemCount: data.length,
      )),
    );
  }

  void getData() async {
    var res = await FirebaseFirestore.instance.collection("chats").withConverter(fromFirestore: MessageList.fromFirsetore, toFirestore: (MessageList d,_)=>d.toFirestore()).get();
    for(int i = 0;i<res.docs.length;i++) {
      if(res.docs[i].data().pers1==user!.email || res.docs[i].data().pers2==user!.email) {
        setState(() {
          data.add(res.docs[i].data());
        });
      }
    }
    setState(() {
      data.sort((a,b){
        DateTime time1 = DateFormat("dd.MM.yyyy HH:mm").parse(a.list[a.list.length-1].date),
            time2 = DateFormat("dd.MM.yyyy HH:mm").parse(b.list[b.list.length-1].date);
        return -time1.compareTo(time2);
      });
    });
    setState(() {
      load = false;
    });

  }
  String getDate(MessageList list) {
    print(list.list[list.list.length-1].date);
    DateTime time = DateFormat("dd.MM.yyyy HH:mm").parse(list.list[list.list.length-1].date);
    DateTime now = DateTime.now();
    if(time.year-now.year==0 && time.month-now.month==0 && time.day-now.day==0) return DateFormat("HH:mm").format(time);
    else if(time.year==now.year) return "${time.day} ${months[time.month]}";
    return "";
  }
}