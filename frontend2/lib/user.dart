import 'package:frontend2/chat.dart';
import 'package:flutter/material.dart';

class User extends StatelessWidget {
  final String name;
  UserData? udata;
  User({required this.name, this.udata});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chat(user: name)));
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          name,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    ));
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String mediaUrl;
  final String bio;
  final String location;

  UserData(
      {Key? key,
      required this.id,
      required this.name,
      required this.email,
      required this.mediaUrl,
      required this.bio,
      required this.location});

  factory UserData.fromJson(dynamic res) {
    return UserData(
        id: res.id.toString(),
        name: res.name,
        email: res.email,
        mediaUrl: res.mediaUrl,
        bio: res.bio,
        location: res.location);
  }
}
