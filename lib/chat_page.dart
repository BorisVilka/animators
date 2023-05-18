
import 'package:intl/intl.dart';
import 'package:animators/fb/message.dart';
import 'package:animators/fb/message_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatState();
  }

}
class ChatState extends State<ChatPage> {

  MessageList? messageList;
  TextEditingController _message = TextEditingController();
  bool first = true;
  var data;
  var user = FirebaseAuth.instance.currentUser;
  var userData;
  var list = <Message>[];
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  _scrollListener() {
    print(_scrollController.positions.toList().indexOf(_scrollController.position));
  }

  var months = [
    "",
    "Января",
    "Февраля",
    "Марта",
    "Апреля",
    "Мая",
    "Июня",
    "Июля",
    "Августа",
    "Сентября",
    "Октября",
    "Ноября",
    "Декабря",
  ];

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    // TODO: implement build
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if(first) {
      first = false;
      if(arguments["list"]==null && arguments["userData"]==null) {
        data = arguments["data"];
        userData = arguments["user"];
      } else if(arguments["list"]!=null) {
        messageList = arguments["list"];
      } else {
        userData = arguments["userData"];
        data = {};
        data["author"] = arguments["email"];
        data["photos"] = arguments["photo"];
      }
      print(data);
      getData();
    }
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Theme.of(context).primaryColor,
     ),
     backgroundColor: Colors.grey[100],
     body: Padding(
       padding: EdgeInsets.only(bottom: 5),
       child: SafeArea(
         child: Column(
           children: [
             GestureDetector(
               onTap: () {
                  /*if(messageList==null) {

                  } else {
                      if(messageList!.ind!=null) {
                          if(messageList!.author_ads!=user!.email) {
                            Navigator.of(context).pushNamed("/ads",arguments: {
                            "ind": messageList!.ind,
                            "author": messageList!.author_ads
                          });
                          }
                      } else {

                      }
                  }*/
               },
               child: Container(
                 width: double.infinity,
                 color: Colors.white,

                 height: 50,
                 padding: EdgeInsets.all(2),
                 child: Row(
                   children: [
                     CircleAvatar(
                         backgroundColor: Colors.white,
                         radius: 23,
                         child:
                         Container(
                           padding: EdgeInsets.all(2), // Border width
                           decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                           child: ClipOval(
                             child: SizedBox.fromSize(
                               size: Size.fromRadius(48), // Image radius
                               child: Image.network(data==null ?
                               (messageList?.ind==null ? (messageList!.pers1==user!.email ? messageList!.photo2 : messageList!.photo1) : messageList!.photo2)
                                   : data["photo"] ?? data["photos"],
                                 fit: BoxFit.cover,
                                 errorBuilder: (context,d,_) {
                                   return const Icon(Icons.person, size: 30,color: Colors.grey,);
                                 },
                                 loadingBuilder: (c,d,g) {
                                   if(g==null) return d;
                                   return const CircularProgressIndicator();
                                 },
                               ),
                             ),
                           ),
                         )
                     ),
                     SizedBox(width: 10,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         SizedBox(height: 5,),
                         Text(userData==null ?  messageList!.pers1==user!.email ? messageList!.label2 : messageList!.label1
                             : userData["name"] ?? "",style: TextStyle(fontWeight: FontWeight.w500),),
                         Text(data==null ?  messageList!.title ?? ""
                             : data["title"] ?? "")
                       ],
                     )
                   ],
                 ),
               ),
             ),
             Flexible(
               child: Container(
                 child: ListView(
                   children: getViews(),
                   shrinkWrap: true,
                   controller: _scrollController,
                 ),
                 width: double.infinity,
                 height: double.infinity,
               ),
             ),
             Container(
               height: 60,
               padding: EdgeInsets.only(left: 10,right: 10),
               child: Row(
                 children: [
                   Flexible(
                     child: TextField(
                       decoration: InputDecoration(
                         fillColor: Colors.black12,
                         filled: true,
                       ),
                       controller: _message,
                       maxLines: 5,
                       minLines: 1,
                       keyboardType: TextInputType.multiline,
                       onChanged: (s) {setState(() {

                       });},
                     ),
                   ),
                   IconButton(onPressed: () {
                     if(_message.text.isNotEmpty) {
                       DateTime now = DateTime.now();
                       String format = DateFormat("dd.MM.yyyy HH:mm").format(now);
                       list.add(Message(message: _message.text, author: user!.email!, date: format));
                       if(messageList!=null) messageList!.list = list;
                       FirebaseFirestore.instance.collection("chats")
                           .doc(
                            data==null ?
                                messageList!.name
                                : (
                              data["ind"]==null ? "${data["author"]}_${user!.email!}" : "${data["author"]}_${user!.email!}_${data["ind"]}"
                            )
                          )
                           .set((data==null ?
                          messageList!
                       : MessageList(list: list,
                           pers1: user!.email!,
                           pers2: data["author"],
                           author_ads: data["author"],
                           ind: data["ind"],
                           title: data["title"],
                           label2: userData["name"],
                           label1: user!.displayName,
                           name: data["ind"]==null ? "${data["author"]}_${user!.email!}" : "${data["author"]}_${user!.email!}_${data["ind"]}",
                           photo2: (data["photos"] as String).trim().split(" ")[0] ?? "",
                           photo1: user!.photoURL ?? ""
                       )).toFirestore());
                       setState(() {
                         _message.text = "";
                       });
                     }
                   }, icon: Icon(Icons.send))
                 ],
               ),
             )
           ],
         ),
       ),
     ),
   );
  }
  void getData() async {
      var us = data==null ? messageList?.ind!=null : data["ind"]!=null;
      var res = us ? (
          data==null ?
          await FirebaseFirestore.instance.collection("chats").doc(messageList!.name).withConverter(fromFirestore: MessageList.fromFirsetore, toFirestore: (MessageList d,_)=>d.toFirestore()).get()
              : await FirebaseFirestore.instance.collection("chats").doc("${data["author"]}_${user!.email!}_${data["ind"]}").withConverter(fromFirestore: MessageList.fromFirsetore, toFirestore: (MessageList d,_)=>d.toFirestore()).get()
      ) : (
        data==null ? await FirebaseFirestore.instance.collection("chats").doc(messageList!.name).withConverter(fromFirestore: MessageList.fromFirsetore, toFirestore: (MessageList d,_)=>d.toFirestore()).get()
        : await FirebaseFirestore.instance.collection("chats").doc("${data["author"]}_${user!.email!}").withConverter(fromFirestore: MessageList.fromFirsetore, toFirestore: (MessageList d,_)=>d.toFirestore()).get()
      );
      print("${us} ${res.exists} ${res.reference.path}");
      var f = false;
      if(!res.exists && us) {
        f = true;
        res = data==null ? await FirebaseFirestore.instance.collection("chats").doc(messageList!.name).withConverter(fromFirestore: MessageList.fromFirsetore, toFirestore: (MessageList d,_)=>d.toFirestore()).get()
            : await FirebaseFirestore.instance.collection("chats").doc("${user!.email!}_${data["author"]}").withConverter(fromFirestore: MessageList.fromFirsetore, toFirestore: (MessageList d,_)=>d.toFirestore()).get();
      }
      var data1 = res.data();
      print(data1!=null && data1.list.isNotEmpty);
      if(data1!=null) {
        setState(() {
          messageList = data1;
          list.addAll(data1.list);
          list.sort((a,b){
            DateTime time1 = DateFormat("dd.MM.yyyy HH:mm").parse(a.date),
                time2 = DateFormat("dd.MM.yyyy HH:mm").parse(b.date);
            return time1.compareTo(time2);
          });
        });
      }
      if(us) {
        FirebaseFirestore.instance.collection("chats")
            .doc(
            data==null ?
            messageList!.name
                : "${data["author"]}_${user!.email!}_${data["ind"]}"
        )
            .snapshots()
            .listen((event) {
          var tmp = MessageList.fromFirsetore( event,null);
          setState(() {
            messageList = tmp;
            list.clear();
            list.addAll(tmp.list);
            list.sort((a,b){
              DateTime time1 = DateFormat("dd.MM.yyyy HH:mm").parse(a.date),
                  time2 = DateFormat("dd.MM.yyyy HH:mm").parse(b.date);
              return time1.compareTo(time2);
            });
          });
        });
      } else {
        FirebaseFirestore.instance.collection("chats")
            .doc(
            data==null ?
            messageList!.name
                : (!f ? "${data["author"]}_${user!.email!}" : "${user!.email!}_${data["author"]}")
            )
            .snapshots()
            .listen((event) {
          var tmp = MessageList.fromFirsetore( event,null);
          setState(() {
            messageList = tmp;
            list.clear();
            list.addAll(tmp.list);
            list.sort((a,b){
              DateTime time1 = DateFormat("dd.MM.yyyy HH:mm").parse(a.date),
                  time2 = DateFormat("dd.MM.yyyy HH:mm").parse(b.date);
              return time1.compareTo(time2);
            });
          });
        });
      }
  }
  List<Widget> getViews() {
    var ans = <Widget>[];
    if(list.isNotEmpty) {
      ans.add(getDateMarker(list[0].date,true));
    }
    for(int i = 0;i<list.length-1;i++) {
      ans.add(Container(
        width: double.infinity,
        alignment: list[i].author==user!.email! ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          color: list[i].author==user!.email! ? Colors.blue[200] : Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(list[i].message, textAlign: list[i].author==user!.email ? TextAlign.end : TextAlign.start,),
                SizedBox(height: 2,),
                Text(list[i].date.trim().split(" ")[1])
              ],
            ),
          ),
        ),
      ));
      DateTime time1 = DateFormat("dd.MM.yyyy HH:mm").parse(list[i].date),
        time2 = DateFormat("dd.MM.yyyy HH:mm").parse(list[i+1].date);
      if(time1.day-time2.day!=0 || time1.month-time2.month!=0 || time1.year-time2.year!=0) {
        ans.add(getDateMarker(list[i+1].date,false));
      }
    }
    if(list.isNotEmpty) {
      print(list[list.length-1].message);
      ans.add(Container(
      width: double.infinity,
      alignment: list[list.length-1].author==user!.email! ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        color: list[list.length-1].author==user!.email! ? Colors.blue[200] : Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(list[list.length-1].message,textAlign: list[list.length-1].author==user!.email ? TextAlign.end : TextAlign.start,),
              SizedBox(height: 2,),
              Text(list[list.length-1].date.trim().split(" ")[1])
            ],
          ),
        ),
      ),
    ));
    }
    print(list.length);
    return ans;
  }

  Widget getDateMarker(String date, bool first) {
    DateTime time = DateFormat("dd.MM.yyyy HH:mm").parse(date);
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: first ? EdgeInsets.only(bottom: 10) : EdgeInsets.symmetric(vertical: 10),
      child: Card(
        color: Colors.grey[400],
        child: Padding(padding: EdgeInsets.all(10),
          child: Text("${time.day} ${months[time.month]}"),
        ),
      ),
    );
  }

}