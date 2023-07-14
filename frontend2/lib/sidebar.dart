import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:frontend2/Users.dart';
import 'package:frontend2/pages/edit_profile_page.dart';
import 'package:frontend2/pages/profile.dart';
import 'login.dart';
import 'feed.dart';
import 'yanan.dart';

class SideBar {
  static const String login = './Login';
  static const String users_page = './users_page';
  static const String sign_out = './signout';
  static const String feed = './Feed';
  static const String edProfile = './edit_profile';
  static const String profile = './profile';
  static const String match = './match';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case users_page:
        return PageTransition(
          child: Users(),
          type: PageTransitionType.fade,
          settings: settings,
        );
      case login:
        return PageTransition(
          child: Login(),
          type: PageTransitionType.fade,
          settings: settings,
        );

      case feed:
        return PageTransition(
          child: FeedPage(),
          type: PageTransitionType.fade,
          settings: settings,
        );

      case edProfile:
        return PageTransition(
          child: EditProfile(),
          type: PageTransitionType.fade,
          settings: settings,
        );

      case profile:
        return PageTransition(
            child: Profile(),
            type: PageTransitionType.fade,
            settings: settings);

      case match:
        return PageTransition(
            child: Yanan(), type: PageTransitionType.fade, settings: settings);

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Container(),
          ),
        );
    }
  }
}
