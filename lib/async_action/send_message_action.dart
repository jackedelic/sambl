import 'package:cloud_functions/cloud_functions.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';

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
    } else if (store.state.currentAppStatus == AppStatusFlags.ordering) {
      CloudFunctions.instance.call(functionName: 'sendMessageAsOrderer', 
        parameters: {"message": message});
    }
  }
}
