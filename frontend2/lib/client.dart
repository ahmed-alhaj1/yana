import 'package:frontend2/src/yana.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import './src/yana.pb.dart';
import 'dart:io';

class Response {
  late int status;
  late String msg;
  dynamic payload;

  Response() {
    status = 500;
    msg = "something went wrong";
  }
}

class API {
  late ClientChannel _channel;
  late ChatClient _stub;

  API() {
    init();
  }

  init() {
    final host = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';

    _channel = ClientChannel(host,
        port: 50051,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    _stub = ChatClient(_channel);
  }

  Register(String name, String password) async {
    Response res = Response();
    try {
      final response = await _stub.register(RegisterRequest()
        ..username = name
        ..password = password);
      res.status = response.getField(1).status == 400 ? 200 : 400;
      res.msg = res.status == 200
          ? "sucess in register user"
          : "unable to register found !";
    } catch (e) {
      print("registration failed !");
    } finally {
      return res;
    }
  }

  Login(String name, String password) async {
    Response res = Response();
    try {
      final response = await _stub.login(LoginRequest()
        ..username = name
        ..password = password);
      res.status = response.getField(1).status == 200 ? 200 : 400;
      res.msg = res.status == 200
          ? "successful login"
          : "user not found during login";
      res.payload = response.getField(2);
    } catch (e) {
      print("login error $e");
    } finally {
      return res;
    }
  }

  getusers() async {
    //init();
    Response res = Response();
    try {
      final response = await _stub.users(GetUser());
      res.status = 200;
      res.msg = "sucess";
      res.payload = response.getField(1);
    } catch (e) {
      print('getuser error: $e');
    } finally {
      // await _channel.shutdown();
      return res;
    }
  }

  sendmessage(String from, String to, String message) async {
    //init();
    Response res = Response();
    try {
      final response = await _stub.send(SendRequest()
        ..from = from
        ..to = to
        ..message = message);
      res.status = response.getField(1).status;
      res.msg = response.getField(1).message;
      res.payload = response.getField(2);
    } catch (e) {
      print('sendmessage error: $e');
    } finally {
      //await _channel.shutdown();
      return res;
    }
  }

  getmessages(String user) async {
    // init();
    Response res = Response();
    try {
      final response = await _stub.message(GetMessages()..user = user);
      res.status = response.getField(1).status;
      res.msg = response.getField(1).message;
      res.payload = response.getField(2);
    } catch (e) {
      print('getmessage error: $e');
    } finally {
      //await _channel.shutdown();
      return res;
    }
  }

  updateposts(String user, String title, String mediaUrl, String description,
      String location) async {
    print('I am at client.updateposts and mybe here the issue');
    Response res = Response();
    try {
      final response = await _stub.post(PostRequest()
        ..username = user
        ..title = title
        ..mediaUrl = mediaUrl
        ..description = description
        ..location = location);
      res.status = response.getField(1).status == 200 ? 200 : 400;
      res.msg = res.status == 200
          ? "successful uploading post"
          : "something went wrong";
    } catch (e) {
      print('sendmessage error : $e ');
    } finally {
      return res;
    }
  }

  getposts(String user) async {
    Response res = Response();
    try {
      final response = await _stub.getPost(GetPostRequest()..user = user);
      res.status = response.getField(1).status;
      res.msg = response.getField(1).message;
      res.payload = response.getField(2);
    } catch (e) {
      print("get post error ");
    } finally {
      return res;
    }
  }
}
