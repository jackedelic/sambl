import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sambl/async_action/google_authentication.dart';
import 'package:sambl/async_action/sign_out.dart';
import 'package:sambl/main.dart';
import 'package:sambl/state/app_state.dart';

import 'package:sambl/utility/firebase_reader.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SignInPage extends StatelessWidget {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState,AppStatusFlags> (
    converter: (store) => store.state.currentAppStatus,
    builder: (context,status) {
      if (false ) {
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
                  alignment: new FractionalOffset(0.0, 0.0),
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
                          converter: (store) => () {
                            orderReader(Firestore.instance.collection('orders').document('dq5exJKI75fJJuIyPYt3'));
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