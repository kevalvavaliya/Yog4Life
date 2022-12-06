import 'dart:convert';
import '../util/ipfs.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../provider/authprovider.dart';
import 'package:yog4life/util/utility.dart';
import 'package:http/http.dart' as http;

class FeedAddprovider with ChangeNotifier {
  File? pickedImaged;
  bool _isVisible = true;

  void setImagepath(File? image) {
    pickedImaged = image;
    notifyListeners();
  }

  File? getImagepath() {
    return pickedImaged;
  }

  void toogleVisiblity() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  bool getVisiblityStatus() {
    return _isVisible;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      // files.sublist(1, 8);
      return true;
    } else if (status == PermissionStatus.denied) {
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to save post as draft?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  pickedImaged = null;
                  Navigator.of(context).pop(true);
                  _isVisible = true;
                  notifyListeners();
                },
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void getImageFromCamera() async {
    XFile pickedFile = await ImagePicker().pickImage(
      imageQuality: 50,
      source: ImageSource.camera,
    ) as XFile;
    setImagepath(File(pickedFile.path));
    toogleVisiblity();
  }

  void getImageFromGallery() async {
    XFile pickedFile = await ImagePicker().pickImage(
      imageQuality: 50,
      source: ImageSource.gallery,
    ) as XFile;
    setImagepath(File(pickedFile.path));
    toogleVisiblity();
  }

  Future<String> checkPostData(TextEditingController postText) async {
    if (postText.text.isNotEmpty) {
      if (pickedImaged != null) {
        final res = await addPost(postText.text, pickedImaged as File);
        return res;
      } else {
        return "image";
      }
    } else {
      return "text";
    }
  }

  Future<String> addPost(String text, File image) async {

    final imageData = await IpfsUtil.uplodeImageToIPFS(image);
    if (imageData.getStatusCode == 200) {
      final resp = await http.post(Uri.parse('${Utility.URL}/feed/post/create'),
          headers: {
            "Authorization": "Bearer ${AuthProvider.authUser.gettoken}",
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "description": text,
            "image": imageData.getCid,
          }));
      // print("Node api called" + resp.body);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['message'] == "Post created successfully") {
          return "success";
        } else {
          return "fail";
        }
      } else {
        return "fail";
      }
    } else {
      return "fail";
    }
  }
}
