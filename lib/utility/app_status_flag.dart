import 'package:flutter/material.dart';

import 'package:sambl/widgets/pages/home_page/home_page.dart';
import 'package:sambl/widgets/pages/sign_in_page.dart';
import 'package:sambl/widgets/pages/placed_order_summary_page/placed_order_summary_page.dart';
import 'package:sambl/widgets/pages/sign_up_page.dart';
import 'package:sambl/widgets/pages/orderer_list_page/orderer_list_page.dart';

Widget defaultPage(AppStatusFlags flag) {
  switch (flag) {
    case AppStatusFlags.delivering:
      return new OrdererListPage();
      break;
    case AppStatusFlags.ordering:
      return new PlacedOrderSummaryPage();
      break;
    case AppStatusFlags.unauthenticated:
      return new SignInPage();
      break;
    case AppStatusFlags.authenticated:
      return new HomePage();
      break;
    case AppStatusFlags.awaitingSignup:
      return new SignUpPage();
      break;

  }
}


/// Status flags of the application
enum AppStatusFlags {
  /// State of the application when no user has been signed in
  unauthenticated,
  /// State of the application while waiting for the user to complete signup
  awaitingSignup,
  /// State of the application when a user is signed in but has neither started nor joined an order
  authenticated,
  /// State of the application when a user is currently ordering food
  ordering,
  /// State of the application when a user is currently delivering food
  delivering
}