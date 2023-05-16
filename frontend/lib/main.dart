import 'package:flutter/material.dart';
import 'package:frontend/join.dart';
import 'package:frontend/store.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Store>(
        create: (_) => Store(),
        child: MaterialApp(
          home: Join(),
        ));
  }
}
