
class Message {

  String message, author, date;

  Message({required this.message, required this.author, required this.date});

  factory Message.fromFirestore(Map<String,dynamic> data) => Message(message: data["message"], author: data["author"], date: data["date"]);

  Map<String,dynamic> toFirestore() => {
    "message": message,
    "author":author,
    "date":date
  };

}