import 'package:cloud_functions/cloud_functions.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/state/app_state.dart';

final ThunkAction<AppState> registerUserAction = (Store<AppState> store) async {
  CloudFunctions.instance.call(functionName: "registerUser");
};