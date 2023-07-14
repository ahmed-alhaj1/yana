import 'package:flutter/material.dart';
import 'posting_card.dart';
import 'app_drawer.dart';
import 'store.dart';
import 'package:provider/provider.dart';
import 'package:frontend2/pages/create_post.dart';

class FeedPage extends StatelessWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("I am at feeds ");
    final store = Provider.of<Store>(context);

    List<PostResult> pdata = List.from(store.getPosts());
    // List.from(store.getPosts());
    //print(pdata);
    //print('still in feed');
    //print(pdata[0].location);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  'create post'.toUpperCase(),
                  style: TextStyle(fontSize: 22.0),
                ),
                onPressed: () {
                  _navigateToNextScreen(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            //Container(
            //height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pdata.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    //print("this pdata[0] value");
                    return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: PostCard(
                          pdata: pdata[index],
                        ));
                  },
                ),
              ],
            )));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreatePost()));
  }
}
