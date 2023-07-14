import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend2/store.dart';
import 'package:frontend2/user.dart';
import 'app_drawer.dart';

class Users extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    var pattern = store.getSearchPattern();
    return WillPopScope(
      onWillPop: () async {
        store.setStatus("join", 400);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: pattern,
              decoration: const InputDecoration.collapsed(
                  hintText: "search",
                  hintStyle: TextStyle(color: Colors.white)),
              onChanged: (text) {
                store.updateSearchPattern(pattern.text);
                pattern.selection = TextSelection.fromPosition(
                    TextPosition(offset: pattern.text.length));
              },
            ),
          ),
          drawer: AppDrawer(),
          body: store.getuser() != null && store.getuser().length > 0
              ? UserList(store.getUsers())
              : const Expanded(
                  child: Center(child: CircularProgressIndicator()))),
    );
  }
}

class UserList extends StatelessWidget {
  final List<dynamic> data;
  UserList(this.data);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(child: User(name: data[index].name));
        });
  }
}
