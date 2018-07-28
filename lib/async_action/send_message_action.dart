import 'package:cloud_functions/cloud_functions.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/middleware/runnabl_action_middleware.dart';
import 'package:sambl/state/app_state.dart';

class SendMessageAction implements RunnableAction {
  final bool reduceable = false;
  final String message;
  final Optional<String> targetUid;

  SendMessageAction(this.message,{String targetUid}): this.targetUid = Optional.fromNullable(targetUid);

  void run(Store<AppState> store) async {
    if (store.state.currentAppStatus == AppStatusFlags.delivering) {
      assert(targetUid.isPresent);
      CloudFunctions.instance.call(functionName: 'sendMessageAsDeliverer', 
        parameters: {"message": message, "targetUid": targetUid.value});
      Map<String,Conversation> modifiedChat = store.state.chats;
      Conversation conv = modifiedChat.remove(targetUid.value) ?? new Conversation.empty();
      modifiedChat.putIfAbsent(targetUid.value, () => conv.append(new Message.fromDeliverer(message)));
      store.dispatch(new WriteChatMessagesAction(modifiedChat));
      
    } else if (store.state.currentAppStatus == AppStatusFlags.ordering) {
      CloudFunctions.instance.call(functionName: 'sendMessageAsOrderer', 
        parameters: {"message": message});
      Map<String,Conversation> modifiedChat = store.state.chats;
      Conversation conv = (modifiedChat.length != 0) ? modifiedChat.values.first : new Conversation.empty();
      store.dispatch(new WriteChatMessagesAction({"id" : conv.append(new Message.fromOrderer(message))}));
    }
  }
}
