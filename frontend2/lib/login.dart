import 'package:frontend2/store.dart';
import 'package:frontend2/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Login({Key? key}) : super(key: key);
  final TextEditingController userController =
      TextEditingController(); //= store.getuserController();
  final TextEditingController passController =
      TextEditingController(); //= store.getpasswordController();
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    //final userController = store.getuserController();
    //final passController = store.getpasswordController();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Material(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextField(
                      controller: userController,
                      //enableInteractiveSelection: false,
                      //autofocus: true,
                      decoration: InputDecoration(
                          hintText: " username ",
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.blue)),
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10)),
                      onChanged: (new_text) {
                        store.updateUser(new_text);
                        //_controller.text = modifytext();
                      }
                      /*
                      var text = formatString(new_text);
                      store.updateUser(text);
                      userController!.value = userController!.value!.copyWith(
                        text: text,
                        selection: TextSelection.collapsed(
                          offset: text.length,
                        ),
                      );
                      //userController.selection = TextSelection.fromPosition(
                      //TextPosition(offset: userController!.text!.length));
                    },*/
                      )),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                      controller: passController,
                      decoration: InputDecoration(
                          hintText: 'password',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue)),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 20, 10, 10)),
                      onChanged: (text) {
                        store.updatePassword(text);
                      }
                      /* //passController.text = modifytext();
                      passController.selection = TextSelection.fromPosition(
                          TextPosition(offset: passController.text.length));
                    },*/
                      )),
              Container(
                alignment: const Alignment(-1, 0),
                margin: const EdgeInsets.only(left: 20),
                child: ElevatedButton(
                  onPressed: () => _submit(store, context),
                  child: const Text('Login'),
                ),
              ),

              //Container(alignment: Alignment(-1,0),
              //)
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Register()));
            },
            child: RichText(
              text: const TextSpan(
                  text: 'New User ?',
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Register Now',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xff4321f5)),
                    )
                  ]),
            )),
      ),
    );
  }

  _submit(Store store, BuildContext context) async {
    print('--->');
    print(userController.text);
    print('--->');
    print(passController.text);
    //if (store.getuser() != null && store.getuser().length > 0) {
    var status = await store.login(userController.text, passController.text);
    print(status);

    if (status == 400) {
      return _createAlert(context, "user does not exists");
    } else if (status == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Users()));
    } else {
      return _createAlert(context, "something went wrong. ");
    }

    //} else {
    //  return _createAlert(context, "name can not be empty ! ");
    //}
  }

  _createAlert(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  String formatString(String newText) {
    return newText.replaceAll(',', '').split('').join('');
  }
}
