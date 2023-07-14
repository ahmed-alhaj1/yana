import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend2/store.dart';
import 'package:frontend2/servcies/post_service.dart';
import 'package:frontend2/servcies/user_services.dart';
import 'package:frontend2/posting_card.dart';
import 'package:provider/provider.dart';

class PostsViewModel extends ChangeNotifier {
  //Services
  //UserService userService = UserService();
  PostService postService = PostService();
  //final store = Provider.of<Store>;

  //Keys
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Variables
  bool loading = false;
  String? username;
  File? mediaUrl;
  final picker = ImagePicker();
  String? location;
  Position? position;
  Placemark? placemark;
  String? bio;
  String? description;
  String? email;
  //String? commentData;
  String? title = '';
  String? userId;
  String? type;
  File? userDp;
  String? imgLink;
  bool edit = false;
  //String? id;

  TextEditingController locationTEC = TextEditingController();

  PostsViewModel() {
    //PostService postService = PostService();

    initialize();
  }
  initialize() async {
    //postService = PostService();

    location;
    description;
    title;
    imgLink;
  }

  setEdit(bool val) {
    edit = val;
    notifyListeners();
  }

  // setPost(PostResult p) {
  // if (p != null) {}

  setUsername(String val) {
    print('SetName $val');
    username = val;
    notifyListeners();
  }

  setDescription(String val) {
    print('SetDescription $val');
    description = val;
    notifyListeners();
  }

  setLocation(String val) {
    print('SetCountry $val');
    location = val;
    notifyListeners();
  }

  setBio(String val) {
    print('SetBio $val');
    bio = val;
    notifyListeners();
  }

  pickImage(Store store, {bool camera = false, BuildContext? context}) async {
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
      print('I am at pick images and I am about to save images');
      print(store.getuser());
      imgLink = await postService.SavePost(pickedFile, store.getuser());
      print('&&&&&&&---->$imgLink!');
      notifyListeners();
      final image = pickedFile; //XFile(croppedFile!.path);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Cancellled', context);
    }
  }

  getLocation() async {
    loading = true;
    notifyListeners();
    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission rPermission = await Geolocator.requestPermission();
      print(rPermission);
      await getLocation();
    } else {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);
      placemark = placemarks[0];
      location = " ${placemarks[0].locality}, ${placemarks[0].country}";
      locationTEC.text = location!;
      print(location);
    }
    loading = false;
    notifyListeners();
  }

  uploadPosts(BuildContext conetxt, Store store) async {
    //final store = Provider.of<Store>(context);
    try {
      print("I am going to trying to load these images");
      loading = true;
      notifyListeners();
      //notifyListeners();
      title = 'Taj Mahel';
      print('----- ' + title!);
      //print('-----' + imgLink!);
      print('--------' + description!);
      print('----' + location!);
      store.updatepost(title!, imgLink!, description!, location!);
      loading = false;
      print('uploading went fine!');
      //resetPost();
      notifyListeners();
    } catch (e) {
      print(e);
      loading = false;
      //resetPost();
      //showInSnackBar('Uploaded successfully!');
      //notifyListeners();
    }
  }

  resetPost() {
    mediaUrl = null;
    description = null;
    location = null;
    edit = false;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
