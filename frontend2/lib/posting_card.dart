import 'package:flutter/material.dart';
import 'common.dart';
//import 'package:flutter/material.dart';
import 'post_page.dart';
import 'DemoValue.dart';

class PostCard extends StatelessWidget {
  late String data;
  PostCard({Key? key}) : super(key: key);
  //final string data;
  @override
  Widget build(BuildContext context) {
    final double aspectRatio = isLandscape(context) ? 6 / 2 : 6 / 3;
    return AspectRatio(
      aspectRatio: 5 / 2,
      child: Card(
        child: Column(
          children: <Widget>[_Post(), _PostDetails()],
        ),
      ),
    );
  }
}
/*
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return PostPage(data: data);
          }));
        },
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Card(
            elevation: 2,
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(4.0),
              post_data: data,
              child: Column(
                children: <Widget>[
                  _Post(),
                  Divider(color: Colors.grey),
                  _PostDetail(),
                ],
              ),
            ),
          ),
        ));


  }
}
*/

class _Post extends StatelessWidget {
  const _Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        children: <Widget>[_PostImage(), _PostSummary()],
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 2, child: Image.asset(DemoValue.postImage));
  }
}

class _PostSummary extends StatelessWidget {
  const _PostSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final TextStyle t
    final String title = DemoValue.postTitle;
    final String summary = DemoValue.postSummary;

    return Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
    return Expanded(
      flex: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text(DemoValue.userName), Text(DemoValue.Email)],
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
