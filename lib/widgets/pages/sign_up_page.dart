import 'package:flutter/material.dart';

import 'package:sambl/widgets/shared/my_button.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sambl/main.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/async_action/register_user_action.dart';
/**
 * This class creates sign up page.
 */
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {


  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
   return new StoreProvider<AppState>(
     store: store,
     child: new Scaffold(
          body: new Form(
            key: _formKey,
            child: new Container(
              padding: new EdgeInsets.all(20.0),
              child: new Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  new Padding(padding: new EdgeInsets.all(10.0)),
                  // Name Field
                  new TextFormField(
                    autofocus: true,
                    decoration: new InputDecoration(
                      hintText: "Name",
                      icon: new Icon(Icons.person),
                    ),
                    validator: (String input) {
                      if (input.isEmpty) {
                        return "You've got no name?";
                      }
                    },
                  ),


                  // Phone Field
                  // Phone

                  new TextFormField(
                    autofocus: true,
                    decoration: new InputDecoration(
                      icon: new Icon(Icons.phone),
                      hintText: "Phone",
                    ),
                    validator: (String input) {
                      if (input.isEmpty) {
                        return "You've got no phone?";
                      }
                    },
                    //focusNode: _focusNode,
                  ),


                  // Email Field
                  new TextFormField(

                    autofocus: true,
                    decoration: new InputDecoration(
                      hintText: "Email",
                      icon: new Icon(Icons.email),
                    ),
                    validator: (String input) {
                      if (input.isEmpty) {
                        return "You've got no email?";
                      }
                    },

                  ),
                  new Padding(padding: new EdgeInsets.all(10.0)),

                  // Confirm button
                   new StoreConnector<AppState, Store<AppState>>(
                      builder: (_, store){
                        return new RaisedButton(
                          child: new Text("sign me up"),
                          onPressed: () {
                            store.dispatch(registerUserAction);
                            if (store.state.currentAppStatus == AppStatusFlags.authenticated) {
                              Navigator.popAndPushNamed(context, '/HomePage');
                            } else {
                              print("inside signuppage, app status is ${store.state.currentAppStatus}");
                            }
                          },
                        );
                      },
                      converter: (store) {
                        return store;
                      },
                    ),




                ],
              ),
            )

          ),
        ),
   );




  }
}
