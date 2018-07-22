enum SenderRole {
  orderer,
  deliverer
}

class Message {
  final SenderRole senderRole;
  final String message;

  Message.fromDeliverer(String msg): this.message = msg, this.senderRole = SenderRole.deliverer;

  Message.fromOrderer(String msg): this.message = msg, this.senderRole = SenderRole.orderer;

  @override
  String toString() {
    return {
      "sender": this.senderRole,
      "message": this.message,
    }.toString();
  }
}

class Conversation {
  List<Message> list;

  Conversation._internal(List<Message> list): this.list = list;

  Conversation.empty(): this.list = [];

  Conversation append (Message msg) {
    return new Conversation._internal(this.list + [msg]);
  }
  
  @override 
  String toString() {
    return {
      "messages": this.list
    }.toString();
  }
}