import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend2/posting_card.dart';
//import 'package:flutter/gestures.dart';
import 'message.dart';
import 'user.dart';
//import 'User.dart';
//import 'message.dart';
import './client.dart';
import 'dart:convert';

const duration = Duration(seconds: 1);

const bool DEBUG = false;

class Store with ChangeNotifier {
  late List<String> _users;
  Map<String, List<Message>>? _messages;
  //Map<String, List<PostResult>>? _posts;
  List<PostResult>? _posts_;
  PostResult? _post;
  List<UserData>? _udata_;

  late int _joinStatus;
  late int _loggedStatus;
  late TextEditingController _searchPattern;
  late TextEditingController _currMessage;
  TextEditingController? _user;
  TextEditingController? _pass;

  static API api = API();
  Store() {
    _posts_ = [];
    //_udata_ = [];
    //_searchPattern = TextEditingController();

    _periodicUpdate();
  }

  initialize() async {
    //_post = PostResult(id: id, username: _post.username, title: title, imgUrl: imgUrl, location: location, description: description, time: time)
    _posts_ = [];
    _udata_ = [];
    //_posts = {};
    _messages = {};
    _messages![_user!.text] = [];
    _currMessage = TextEditingController();
    _searchPattern = TextEditingController();
    await fetchUsers();
    await fetchMessages();
    await fetchPosts();
  }

  setPost(String username, String title, String imgUrl, String description,
      String location) {
    _post = PostResult(
        id: "%1",
        username: username,
        title: title,
        imgUrl: imgUrl,
        location: location,
        description: description,
        time: " ");
  }

  List<UserData> getUsers() {
    List<UserData> usrs = [];
    if (_udata_ == null) {
      return usrs;
    }
    for (int i = 0; i < _udata_!.length; i++) {
      if (_udata_![i].name != _user!.text) {
        usrs.add(_udata_![i]);
      }
    }

    usrs.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    if (_searchPattern.text.length > 0) {
      List<UserData> searchResult = [];
      usrs.forEach((usr) => {
            if (usr.name
                .toLowerCase()
                .contains(_searchPattern.text.toLowerCase()))
              {searchResult.add(usr)}
          });
      return searchResult;
    }
    return usrs;
  }

/*
for (int i = 0; i < _users.length; i++) {
      if (_users[i] != _user!.text) {
        usrs.add(_users[i]);
      }
    }

    usrs.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    if (_searchPattern.text.length > 0) {
      List<String> searchResult = [];
      usrs.forEach((usr) => {
            if (usr.toLowerCase().contains(_searchPattern.text.toLowerCase()))
              {searchResult.add(usr)}
          });
      return searchResult;
    }
    return usrs;
  }
*/
  List<Message> getMessages(String name) {
    List<Message> msgs = [];
    if (_messages == null ||
        _messages![_user!.text] == null ||
        _messages![_user!.text]!.length == 0) {
      return msgs;
    }
    for (int i = 0; i < _messages![_user!.text]!.length; i++) {
      if (_messages![_user!.text]![i].from == name ||
          _messages![_user!.text]![i].to == name) {
        msgs.add(_messages![_user!.text]![i]);
      }
    }

    return msgs;
  }

  List<PostResult> getPosts() {
    List<PostResult> k = [..._posts_!];

    return k;
  }

  getCurMessage() {
    return _currMessage;
  }

  UpdateCurMessage(String msg) {
    _currMessage.text = msg;
    notifyListeners();
  }

  sendMessage(String to) async {
    try {
      final Response response =
          await api.sendmessage(_user!.text, to, _currMessage.text);
      if (response.status == 200) {
        _messages![_user!.text]?.add(Message.fromJson(response.payload));
        UpdateCurMessage("");
        notifyListeners();
        print({"Message : ", Message.fromJson(response.payload)});
      } else {
        print(response.msg);
      }
    } catch (e) {
      debug("send messages ", e);
    }
  }

  updateSearchPattern(String new_pattern) {
    _searchPattern.text = new_pattern;
    notifyListeners();
  }

  TextEditingController getSearchPattern() {
    return _searchPattern;
  }

  updateusers(List<String> usrs) {
    _users = usrs;
    notifyListeners();
  }

  getuserController() {
    return _user;
  }

  getpasswordController() {
    return _pass;
  }

  getuser() {
    return _user == null ? null : _user!.text;
  }

  getuser1() {
    return _user;
  }

//##################################

  void updateUser(String newuser) {
    if (_user == null) {
      _user = TextEditingController();
    }
    _user!.text = newuser;
    notifyListeners();
  }

  void updatePassword(String new_password) {
    if (_pass == null) {
      _pass = TextEditingController();
    }
    _pass!.text = new_password;
    notifyListeners();
  }

  int getRegistrationStatus() {
    return _joinStatus == null ? 0 : _joinStatus;
  }

  setStatus(String type, int val) {
    if (type == "join") {
      _joinStatus = val;
    } else {
      _loggedStatus;
    }

    notifyListeners();
  }

  int getloginstatus() {
    return _loggedStatus == null ? 0 : _loggedStatus;
  }

  fetchUsers() async {
    try {
      final Response response = await api.getusers();
      if (response.status == 200) {
        var data = response.payload as List;
        _udata_ =
            data != null ? data.map((i) => UserData.fromJson(i)).toList() : [];
      } else {
        print(response.msg);
      }
    } catch (e) {
      debug("fetch usere", e);
    } finally {
      notifyListeners();
    }
  }

  fetchMessages() async {
    try {
      final Response response = await api.getmessages(_user!.text);
      if (response.status == 200) {
        if (response.payload != null) {
          var data = response.payload as List;
          debug("fetchMessages", data);
          _messages![_user!.text] =
              data != null ? data.map((i) => Message.fromJson(i)).toList() : [];
        }
      } else {
        print(response.msg);
      }
    } catch (e) {
      debug("fetch message", e);
    }
  }

  fetchPosts() async {
    try {
      //_user!.text
      final Response response = await api.getposts('ahmed');
      if (response.status == 200) {
        if (response.payload != null) {
          var pdata = response.payload as List;
          debug("fetchPosts", pdata);

          _posts_ = pdata != null
              ? pdata.map((i) => PostResult.fromJson(i)).toList()
              : [];
          //_posts![_user!.text] = pdata != null
          // ? pdata.map((i) => PostResult.fromJson(i)).toList()
          //: [];
        } else {
          print(response.msg);
        }
      }
    } catch (e) {
      debug("fetch post ", e);
    }
  }

  Future register() async {
    try {
      final Response response = await api.Register(_user!.text, _pass!.text);
      if (response.status == 200) {
        _joinStatus = 200;
        initialize();
      } else {
        _joinStatus = response.status;
        debug("join", response.msg);
      }
    } catch (e) {
      debug("join", e);
    } finally {
      notifyListeners();
    }
    return _joinStatus;
  }

  Future login(String uname, String upass) async {
    try {
      print('username $uname  passowrd $upass');
      final Response response = await api.Login(uname, upass);
      if (response.status == 200) {
        _loggedStatus = 200;
        initialize();
        //var udata = response.payload as List;
        //print('############## Login ########################');
        //print(udata);
        //print('#############################################');
        var udata = response.payload;
        //print('this is the value of udata : ');
        //print(udata);
        //_udata_ = udata != null
        //  ? udata.map((i) => UserData.fromJson(i)).toList()
        //: [];
        //initialize();
      } else {
        _loggedStatus = response.status;
        debug("login", response.msg);
      }
    } catch (e) {
      debug("login", e);
    } finally {
      notifyListeners();
    }
    return _loggedStatus;
  }

  Future updatepost(
    String title,
    String imgUrl,
    String description,
    String location,
  ) async {
    try {
      print('I am calling api update_post');
      final Response response = await api.updateposts(
          _user!.text, title, imgUrl, description, location);
      if (response.status == 200) {
        print('data has been loaded correctly');
        //_update();
        await fetchPosts();
      } else {
        print('something went wrong !');
        debug("update_post", response.status);
      }
    } catch (e) {
      print('not clear what happend at upload post !!!!!!');
      debug("update_post", e);
    } finally {
      notifyListeners();
    }
  }

  _update() async {
    try {
      if (_user != null &&
          _user!.text != "" &&
          (_joinStatus == 200 || _loggedStatus == 200)) {
        await fetchMessages();
        await fetchUsers();
        await fetchPosts();
        notifyListeners();
      }
    } catch (e) {
      debug("_update", e);
    }
  }

  _periodicUpdate() {
    Timer.periodic(duration, (Timer t) => _update());
  }
}

debug(String source, dynamic msg) {
  if (DEBUG) {
    print('${source} : ${msg}');
  }
}
