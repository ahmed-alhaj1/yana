import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'common.dart';
//import 'package:flutter/material.dart';
//import 'post_page.dart';
import 'DemoValue.dart';
import 'store.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final PostResult pdata;
  PostCard({Key? key, required this.pdata}) : super(key: key);
  //final string data;
  //var date = pdata.time.split('.');
  @override
  Widget build(BuildContext context) {
    //final store = Provider.of<Store>(context);
    final double aspectRatioL = isLandscape(context) ? 6 / 2 : 2;
    final tdate = pdata.time.split('.')[0];
    //return Expanded(
    //    child: AspectRatio(
    //  aspectRatio: aspectRatioL,
    //SizedBox(height: 10,)
    return Card(
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          //height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          //const _PostDetails(),
          //const Divider(color: Colors.grey),
          //_Post(
          //  summary: pdata.location,
          //   imgUrl: pdata.imgUrl,
          //   title: pdata.title),
          ListTile(
            title: Text(pdata.title),
            subtitle: Text(pdata.description),
            trailing: Text(tdate),
          ),

          pdata.imgUrl.contains('assets') == false
              ? Container(
                  height: 200.0,
                  child: Image.file(
                    File(pdata.imgUrl),
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 200,
                  child: Image(
                    image: AssetImage(DemoValue.postImage),
                    fit: BoxFit.fill,
                  ),
                ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(pdata.location),
          ),
        ],
      ),
    );
  }

//  factory PostCard.fromJson(dynamic res) {
  //  return PostCard(
  //    summary: res.description, location: res.location, time: res.time);
  //}
}

class _Post extends StatelessWidget {
  final String summary;
  final String imgUrl;
  final String title;
  const _Post(
      {Key? key,
      required this.summary,
      required this.imgUrl,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //String image;
    return Expanded(
      //flex: 3,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        //runAlignment: WrapAlignment.spaceBetween,
        children: <Widget>[
          _PostSummary(summary: summary, title: title),
          const Divider(
            height: 10,
          ),
          _PostImage(imgUrl: imgUrl),
        ],
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  final String imgUrl;
  const _PostImage({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final path = Directory(imgUrl);

    final status = Permission.storage.request().isGranted;
    if (imgUrl.contains('assets') == false) {
      return Image.file(
        File(imgUrl),
        fit: BoxFit.cover,
        height: 200,
        width: 200,
      );
    } else {
      return Image(
        image: AssetImage(DemoValue.postImage),
        fit: BoxFit.fill,
        height: 200,
        width: 200,
      );
    }
  }
}

class _PostSummary extends StatelessWidget {
  final String summary;
  final String title;
  const _PostSummary({Key? key, required this.summary, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final TextStyle t

    //final String title = title ;
    //final String summary = DemoValue.postSummary;

    return Expanded(
        flex: 3,
        child: Column(
          //fit:3
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title),
            Text(summary),
          ],
        ));
  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[_UserImage(), _UserData()]);
  }
}

class _UserData extends StatelessWidget {
  const _UserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    return Expanded(
      flex: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text(store.getuser()), Text(DemoValue.Email)],
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: CircleAvatar(
        backgroundImage: AssetImage(DemoValue.userImage),
      ),
    );
  }
}

class PostResult {
  final String id;
  final String username;
  final String title;
  final String imgUrl;
  final String location;
  final String description;
  final String time;
  PostResult(
      {Key? key,
      required this.id,
      required this.username,
      required this.title,
      required this.imgUrl,
      required this.location,
      required this.description,
      required this.time});
  factory PostResult.fromJson(dynamic res) {
    return PostResult(
        id: res.id.toString(),
        username: res.name,
        title: res.title,
        imgUrl: res.mediaUrl,
        description: res.description,
        location: res.location,
        time: res.time);
  }
}
