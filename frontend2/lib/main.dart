import 'package:flutter/material.dart';
import 'package:frontend2/ModelViews/post_view_model.dart';
import 'package:frontend2/feed.dart';
import 'package:frontend2/sidebar.dart';
import 'package:frontend2/splash_screen.dart';
import 'package:frontend2/store.dart';
import 'package:frontend2/Login.dart';
import 'package:provider/provider.dart';
import 'sidebar.dart';
import 'Users.dart';
import 'splash_screen.dart';
import 'feed.dart';
import 'package:frontend2/pages/edit_profile_page.dart';
import 'package:frontend2/ModelViews/profile/edit_profile.dart';
import 'package:frontend2/ModelViews/post_view_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Store>(create: (_) => Store()),
      ChangeNotifierProvider<EditProfileViewModel>(
          create: (_) => EditProfileViewModel()),
      ChangeNotifierProvider(create: (_) => PostsViewModel())
    ],
    child: MyProviderApp(),
  ));
}

class MyApp extends StatelessWidget {
  //Key key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Store()),
        ChangeNotifierProvider<EditProfileViewModel>.value(
            value: EditProfileViewModel())
      ],
      child: MaterialApp(
        home: SplashScreen(),
        routes: {
          '/users_page': (context) => Users(),
          '/Feed': (context) => FeedPage(),
          './EdProfile': (context) => const EditProfile(),
        },
      ),
    );
  }
}

class MyProviderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      //home: SideBar.users_page,
      initialRoute: SideBar.login,
      onGenerateRoute: (RouteSettings settings) =>
          SideBar.generateRoute(settings),
    );
  }
}
