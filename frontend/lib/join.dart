import 'package:frontend/login.dart';
import 'package:frontend/store.dart';
import 'package:frontend/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Join extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    final userController = store.getuserController();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldstate,
        appBar: AppBar(
          title: Text("Join"),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: userController,
                  decoration: InputDecoration.collapsed(
                    hintText: "Type your username",
                  ),
                  onChanged: (text) {
                    store.updateUser(text);
                    userController.selection = TextSelection.fromPosition(
                        TextPosition(offset: userController.text.length));
                  },
                )),
            Container(
              alignment: Alignment(-1, 0),
              margin: EdgeInsets.only(left: 20),
              child: ElevatedButton(
                onPressed: () => _submit(store, context),
                child: Text('Join'),
              ),
            ),
            ElevatedButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            )
          ],
        )),
      ),
    );
  }

  _submit(Store store, BuildContext context) async {
    if (store.getuser() != null && store.getuser().length > 0) {
      var status = await store.join();
      if (status == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text('name already exist try different name. '),
          ),
        );
      } else if (status == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Users()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text('something went wrong. '),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('name can not be empty. '),
        ),
      );
    }
  }
}
