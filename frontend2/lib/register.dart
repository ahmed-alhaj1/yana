import 'package:frontend2/login.dart';
import 'package:frontend2/store.dart';
import 'package:frontend2/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    final userController = store.getuserController();
    final passController = store.getpasswordController();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          key: _scaffoldstate,
          appBar: AppBar(
            title: Text("register"),
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
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: passController,
                    decoration: InputDecoration(
                        hintText: 'password',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue)),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10)),
                    onChanged: (text) {
                      store.updatePassword(text);
                      passController.selection = TextSelection.fromPosition(
                          TextPosition(offset: passController.text.length));
                    },
                  )),
              Container(
                alignment: Alignment(-1, 0),
                margin: EdgeInsets.only(left: 20),
                child: ElevatedButton(
                  onPressed: () => _submit(store, context),
                  child: Text("register"),
                ),
              ),
              ElevatedButton(
                child: Text("Login"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              )
            ],
          ))),
    );
  }

  _submit(Store store, BuildContext context) async {
    if (store.getuser() != null && store.getuser().length > 0) {
      var status = await store.register();
      if (status == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text("name already exitst try different name, "),
          ),
        );
      } else if (status == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Users()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(),
            content: Text('name  can not be empty. '),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('name can not be empty '),
        ),
      );
    }
  }
}
