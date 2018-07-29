import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/async_action/send_message_action.dart';


class ChatScreen extends StatefulWidget {
  final orderUid;

  ChatScreen({this.orderUid});

  @override
  _ChatScreenState createState() => _ChatScreenState(orderUid: this.orderUid);
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();
  final orderUid;

  _ChatScreenState({this.orderUid});

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: new EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new StoreConnector<AppState, Function>(
                converter: (store) {
                  return (String text) => store.dispatch(new SendMessageAction(text));
                },
                builder: (context, callback) {
                  return new TextField(
                    controller: _textController,
                    onSubmitted: (String text) {
                      if (text.length != 0) {
                        callback(text);
                      }
                    },
                    decoration: new InputDecoration.collapsed(
                        hintText: "Send a message"),
                  );

                }
              ),
            ),

            // the send button
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new StoreConnector<AppState, Store<AppState>>(
                  builder: (context, store) {
                    return Theme.of(context).platform == TargetPlatform.iOS ?
                      new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: () {
                          if (_textController.text.length != 0) {
                            store.dispatch(SendMessageAction(_textController.text));
                            _textController.clear(); // clear the textfield
                          }
                        }
                      ) :
                      new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: () {
                          if (_textController.text.length != 0) {
                            store.dispatch(SendMessageAction(_textController.text));
                            _textController.clear(); // clear the textfield
                          }
                        }
                      );
                    },
                  converter: (store) {
                    return store;
                  }
              )
            )
          ],
        )
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sambl Chat"),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              // a list of messages in chronological order
              new StoreConnector<AppState, List<ChatMessage>>(
                  builder: (_, messages){
                    print(messages.length);
                    return new Flexible(
                      fit: FlexFit.tight,
                      child: new ListView.builder(
                        itemBuilder: (_, int index) => messages[index],
                        reverse: false,
                        padding: new EdgeInsets.all(8.0),
                        itemCount: messages?.length == null ? 0 : messages.length,
                      ),

                    );
                  },
                  converter: (store) {

                    String ourName = store.state.currentUser.name;
                    print("our Name is: " + ourName);

                    String theirName = "";

                    if (store.state.currentAppStatus == AppStatusFlags.delivering) {
                      var combinedMap = new Map<String,Order>();
                      combinedMap.addAll(store.state.currentDeliveryList.approved.orders);
                      combinedMap.addAll(store.state.currentDeliveryList.paid.orders);
                      combinedMap.addAll(store.state.currentDeliveryList.pending.orders);
                      if (combinedMap.containsKey(this.orderUid)) {
                        theirName = combinedMap[this.orderUid].ordererName;
                      }
                    } else if (store.state.currentAppStatus == AppStatusFlags.ordering) {
                      theirName = store.state.currentOrder
                        .transform((order) => order.orderDetail.delivererName).or('A');
                    }

                    AnimationController controller = new AnimationController(
                      duration: new Duration(milliseconds: 1000),
                        vsync: this,);


                    Function getMapper = (SenderRole ourRole) {
                      return (Message message) {
                        if (message.senderRole != ourRole) {
                          return new ChatMessage.their(animationController: controller, text: message.message, name: theirName);
                        } else {
                          return new ChatMessage.our(animationController: controller, text: message.message, name: ourName);
                        }
                      };
                    };
                      
                    if (store.state.currentAppStatus == AppStatusFlags.ordering) {
                      if (store.state.chats.isEmpty) {
                        return new List<ChatMessage>();
                      } else {
                        return store.state.chats.entries.first.value.list
                          .map<ChatMessage>((msg) => getMapper(SenderRole.orderer).call(msg))
                          .toList();
                      }
                    } else if (store.state.currentAppStatus ==AppStatusFlags.delivering) {
                      return store.state.chats[orderUid].list
                        .map<ChatMessage>((msg) => getMapper(SenderRole.deliverer).call(msg))
                        .toList();
                    } else {
                      return new List<ChatMessage>();
                    }
                  }
              ),

              new Divider(height: 1.0,),


              // this part lies at the bottom of the screen. it consists of textfield
              // and send button.
              new Container(
                decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS ?
            new BoxDecoration(
              border: new Border(
                top: new BorderSide(color: Colors.grey[200])
              )
            ) :
            null,
        ),
    );
  }
}

class RightMessageDisplay extends StatelessWidget {
  final String messageOwnerName;
  final String text;

  RightMessageDisplay({this.messageOwnerName,this.text});
  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          child: new Column(    
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(messageOwnerName, style: Theme.of(context).textTheme.caption,),
              new Container(
                margin: new EdgeInsets.only(top: 5.0),
                  child: new Text(text),
              )
            ],
          ),
        ),
        new Container(
          alignment: Alignment.centerRight,
          margin: new EdgeInsets.only(left: 16.0),
          child: new CircleAvatar(child: new Text(messageOwnerName[0]),),
        ),
      ],
    );
  }
}

class LeftMessageDisplay extends StatelessWidget {
  final String messageOwnerName;
  final String text;

  LeftMessageDisplay({this.messageOwnerName,this.text});
  @override
  Widget build(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          child: new CircleAvatar(child: new Text(messageOwnerName[0]), backgroundColor: Colors.grey, foregroundColor: Colors.white,),
          margin: EdgeInsets.only(right: 16.0),
        ),
        new Expanded(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,    
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(messageOwnerName, style: Theme.of(context).textTheme.caption, ),
              new Container(
                margin: new EdgeInsets.only(top: 5.0),
                  child: new Text(text),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// Model
// to construct a chat message.
class ChatMessage extends StatelessWidget {
  final AnimationController animationController;
  final Widget messageDisplay;

  ChatMessage.our({this.animationController, String text = "",String name = "P"}):
    this.messageDisplay = new RightMessageDisplay(messageOwnerName: name, text: text);

  ChatMessage.their({this.animationController, String text = "", String name = "P"}): 
    this.messageDisplay = new LeftMessageDisplay(messageOwnerName: name, text: text);
  
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: messageDisplay,
    );
  }
}
