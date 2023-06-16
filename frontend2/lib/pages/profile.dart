//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend2/app_drawer.dart';
import 'package:frontend2/users.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:frontend2/user.dart';
import 'package:frontend2/ModelViews/profile/edit_profile.dart';
import 'package:frontend2/components/text_form_builder.dart';
import 'package:frontend2/widgets/indicators.dart';
import 'package:frontend2/store.dart';
import 'package:frontend2/DemoValue.dart';
import 'package:frontend2/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  final User? user;
  //ScrollController controller = ScrollController();

  const Profile({this.user}); // : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  String? phot_url;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);

    user = User(name: store.getuser());
    String? photo_url = DemoValue.userImage;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Yana'),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => Register(),
                      ),
                    );
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        //drawer: AppDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: false,
                toolbarHeight: 5.0,
                collapsedHeight: 6.0,
                expandedHeight: 225.0,
                flexibleSpace: FlexibleSpaceBar(
                  //background: StreamBuilder(
                  //  steram: usersRef.doc(widget)
                  //)
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: DemoValue.userImage.isEmpty
                                ? CircleAvatar(
                                    radius: 40.0,
                                    backgroundColor: Colors.amberAccent,
                                    child: Center(
                                      child: Text(
                                        '${user!.name.toUpperCase()}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage:
                                        AssetImage(DemoValue.userImage),
                                  ),
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 32.0),
                              Row(
                                children: [
                                  const Visibility(
                                    visible: false,
                                    child: SizedBox(width: 10.0),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 130.0,
                                        child: Text(
                                          user!.name,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          maxLines: null,
                                        ),
                                      ),
                                      Container(
                                        width: 130,
                                        child: Text(
                                          DemoValue.user_country,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user!.name + '@gmail.com',
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (_) => Users(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(
                                          Ionicons.settings_outline,
                                          color: Color.fromARGB(
                                              255, 124, 122, 122),
                                        ),
                                        Text(
                                          'setting',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  // ##################
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                        child: Container(
                          width: 100,
                          child: Text(
                            DemoValue.user_bio,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                            maxLines: null,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              buildCount(
                                  "FOLLOWERS", DemoValue.following_count),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Container(
                                  height: 50,
                                  width: 0.3,
                                  color: Colors.grey,
                                ),
                              ),

                              buildCount("FOLLOWING", 12),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Container(
                                  height: 50.0,
                                  width: 0.3,
                                  color: Colors.grey,
                                ),
                              ),

                              buildCount("post", 6),

                              ////////////////////////
                              //),
                            ],
                          ),
                        ),
                      ),
                    ],
                    //###################################
                  ), // row
                  //],
                  //),
                )),
          ],
        ));
    ////////////////////////////////////////
    /////////////////////////////////////////////
  }

  buildCount(String label, int count) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
            fontFamily: 'Ubtuntu-Regular',
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'Ubuntu-Regular',
          ),
        ),
      ],
    );
  }
}
