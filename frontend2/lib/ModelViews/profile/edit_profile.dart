import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:frontend2/user.dart';
import 'package:frontend2/servcies/user_services.dart';
import 'package:frontend2/store.dart';
import 'package:provider/provider.dart';

class EditProfileViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //print("I just assign form key to global key ");

  bool validate = false;
  bool loading = false;
  final picker = ImagePicker();
  User? user;
  String? user_name;
  String? country;
  String? bio;
  XFile? image;
  String? imgLink;

  setUser(User curr) {
    user = curr;
    notifyListeners();
  }

  setImage(String img_link) {
    imgLink = img_link;
    notifyListeners();
  }

  setCountry(String val) {
    country = val;
    notifyListeners();
  }

  setUserName(String name) {
    user_name = name;
    notifyListeners();
  }

  setBio(String val) {
    print('SetBio$val');
    bio = val;
    notifyListeners();
  }

  editProfile(BuildContext context) async {
    print("I am at edit_view_model profile #editProfile# ");
    //final store = Provider.of<Store>(context);
    //setUser(store.getuser1());
    //bool success = false;
    //setUserName(store.getuser());

    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'please fix the errors in red before submitting.', context);
    } else {
      try {
        loading = true;
        notifyListeners();
        bool success = false;

        success = await UserServices().updateProfile(
          image: image,
          username: user_name,
        );

        //print(success);

        if (success) {
          clear();
          Navigator.pop(context);
        }
      } catch (e) {
        loading = false;
        notifyListeners();
        print(e);
      }
      loading = false;
      notifyListeners();
    }
  }

  pickImage({bool camera = false, BuildContext? context}) async {
    print("I am at edit_view_model #pickImage#");
    loading = true;
    notifyListeners();

    try {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      /*CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: const Color(0xff886EE4),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );*/
      image = pickedFile; //XFile(croppedFile!.path);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Cancellled', context);
    }
  }

  clear() {
    image = null;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
