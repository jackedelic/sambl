import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sambl/async_action/google_authentication.dart';
import 'package:sambl/main.dart';
import 'package:sambl/widgets/pages/home_page/home_page.dart';

import 'package:sambl/state/app_state.dart';

class StartPage extends StatefulWidget {

  @override
  _StartPageState createState() {
    return new _StartPageState();
  }
}


class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) => StoreConnector<AppState, AppStatusFlags>(
    converter: (Store<AppState> store) => store.state.currentAppStatus,
    builder: (BuildContext context, AppStatusFlags flag) => defaultPage(flag)
  );
}
