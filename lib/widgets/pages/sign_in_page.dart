import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sambl/async_action/google_sign_in.dart';
import 'package:sambl/main.dart';
import 'package:sambl/state/app_state.dart';

/**
 * This class creates sign up page.
 */

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {


  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) => StoreConnector<AppState,AppStatusFlags> (
    converter: (store) => store.state.currentAppStatus,
    builder: (context,status) {
      if (status != AppStatusFlags.unauthenticated) {
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
        return defaultPage(status);
      } else {
        return new Scaffold(
          key: _formKey,
          body: new Stack(
            children: <Widget>[
              new Container(
                color: Colors.black,  
                child: new Image(   
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black38,       
                  image: AssetImage('assets/images/sign_in_page_background.jpg'),
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  alignment: new FractionalOffset(0.5, 0.0),
                ),
              ),
              new Container (
                
                alignment: Alignment.bottomCenter,
                child: new AspectRatio(
                  aspectRatio: 2.5,
                  child: new Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new StoreConnector<AppState,VoidCallback>(
                          converter: (store) => () async {
                            await store.dispatch(authenticateWithGoogle(store));
                            print(store.state.currentAppStatus);
                          },
                          builder: (context,callback) => new FlatButton(
                            child: Container(
                              color: Colors.red,
                              height: 100.0,
                              width: double.infinity,
                            ),
                            onPressed: callback
                          )

                        )
                      ],
                    )
                  ),
                ),
              )
            ],
          ),
        );
      }
    }
  );
}