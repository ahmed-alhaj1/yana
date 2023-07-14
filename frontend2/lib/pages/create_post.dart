//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend2/feed.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:frontend2/widgets/indicators.dart';
import 'package:frontend2/ModelViews/post_view_model.dart';
import 'package:frontend2/store.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostsViewModel>(context);
    final store = Provider.of<Store>(context);
    print(store.getuser1());

    //PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        await viewModel.resetPost();
        return true;
      },
      child: LoadingOverlay(
        progressIndicator: circularProgress(context),
        isLoading: viewModel.loading,
        child: Scaffold(
            key: viewModel.scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Ionicons.close_outline),
                onPressed: () {
                  //viewModel.resetPost();
                  Navigator.pop(context);
                },
              ),
              title: Text('yana'.toUpperCase()),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    //viewModel.resetPost();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Post'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                SizedBox(height: 15.0),
                InkWell(
                    onTap: () => showImageChoices(context, viewModel),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),

                      //izedBox(height: 20),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Post Title'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                  initialValue: viewModel.description,
                  decoration: const InputDecoration(
                    hintText: 'Eg. This is very unique pic!',
                    focusedBorder: UnderlineInputBorder(),
                  ),
                  maxLines: null,
                  onChanged: (val) => viewModel.setDescription(val),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Location'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  title: Container(
                    width: 250.0,
                    child: TextFormField(
                      controller: viewModel.locationTEC,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(0.0),
                        hintText: 'United States,Los Angeles!',
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      maxLines: null,
                      onChanged: (val) => viewModel.setLocation(val),
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: "Use your current location",
                    icon: const Icon(
                      CupertinoIcons.map_pin_ellipse,
                      size: 25.0,
                    ),
                    iconSize: 30.0,
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () => viewModel.getLocation(),
                  ),

                  //contentPadding :  EdgeInsets.fromLTRB(10.0, 0.0, 250.0, 0.0),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    viewModel.uploadPosts(context, store);
                    _navigateToNextScreen(context);
                  },
                  child: const Text('back to feed'),
                ),
              ],
            )),
        //viewModel.uploadPosts(store, context);
      ),
      //viewModel.uploadPosts(store, context);
    );
  }

  showImageChoices(BuildContext context, PostsViewModel viewModel) {
    final store = Provider.of<Store>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Select Image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Ionicons.camera_outline),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(store, camera: true);
                },
              ),
              ListTile(
                leading: const Icon(Ionicons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(store);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FeedPage()));
  }
}
