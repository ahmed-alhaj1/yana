//import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:frontend2/app_drawer.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:frontend2/user.dart';
import 'package:frontend2/ModelViews/profile/edit_profile.dart';
import 'package:frontend2/components/text_form_builder.dart';
import 'package:frontend2/widgets/indicators.dart';
import 'package:frontend2/store.dart';
import 'package:frontend2/DemoValue.dart';

class EditProfile extends StatefulWidget {
  final User? user;

  const EditProfile({this.user}); // : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user;
  String? phot_url;

  /*
  String get_uid() {
    //int x = string.substring(user
    return user!.name;
  }
  */

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    EditProfileViewModel view_model =
        Provider.of<EditProfileViewModel>(context);

    user = User(name: store.getuser());
    String? photo_url = DemoValue.userImage;

    var gestureDetector = GestureDetector(
      onTap: () => view_model.editProfile(context),
      child: Text(
        'Save',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15.0,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
    return LoadingOverlay(
      progressIndicator: circularProgress(context),
      isLoading: view_model.loading,
      child: Scaffold(
        key: view_model.scaffoldKey,
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: GestureDetector(
                  onTap: () => view_model.editProfile(context),
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: () => view_model.pickImage(),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: view_model.imgLink != null
                        ? Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 65.0,
                              backgroundImage:
                                  NetworkImage(view_model.imgLink!),
                            ),
                          )
                        //iew_model.image == null
                        : Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 65.0,
                              backgroundImage: AssetImage(photo_url),
                            ),
                          )
                    /*: Padding(
                                padding: const EdgeInsets.all(1),
                                child: CircleAvatar(
                                  radius: 65.0,
                                  backgroundImage: FileImage(view_model.image!),
                                ),
                              )*/
                    ),
              ),
            ),
            SizedBox(height: 10.0),
            buildForm(view_model, context)
          ],
        ),
      ),
    );
  }

  buildForm(EditProfileViewModel view_model, BuildContext context) {
    print("I am at #build form#");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: view_model.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormBuilder(
              enabled: !view_model.loading,
              initialValue: user!.name,
              prefix: Ionicons.person_outline,
              hintText: "Username",
              textInputAction: TextInputAction.next,
              //validateFunction: Validations.validateName,
              onSaved: (String val) {
                view_model.setUserName(val);
              },
            ),
            const SizedBox(height: 10.0),
            const SizedBox(height: 10.0),
            const Text(
              "Bio",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              maxLines: null,
              initialValue: DemoValue.user_bio,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                if (value!.length > 1000) {
                  return 'Bio must be short';
                }
                return null;
              },
              onSaved: (String? val) {
                view_model.setBio(val!);
              },
              onChanged: (String val) {
                view_model.setBio(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
