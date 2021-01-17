import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_to_office/util/repository.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key key, this.title, this.repository}) : super(key: key);

  final String title;
  final Repository repository;

  @override
  _UserProfilePageState createState() => _UserProfilePageState(repository);
}

class _UserProfilePageState extends State<UserProfilePage> {
  _UserProfilePageState(this.repository);

  final Repository repository;
  final picker = ImagePicker();
  String _path;
  String _imageURL;

  @override
  void initState() {
    downloadProfilePic();
    super.initState();
  }

  Future<void> downloadProfilePic() async {
    String downloadURL = await repository.getProfileImageUrl();

    setState(() {
      _imageURL = downloadURL;
    });

  }

  void _showPhotoLibrary() async {
    final file = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _path = file.path;
      repository.uploadProfileImage(File(_path)).then((value) =>
          downloadProfilePic()
      );
    });
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile == null) {
      return;
    }

    setState(() {
      _path = pickedFile.path;
      repository.uploadProfileImage(File(_path)).then((value) =>
          downloadProfilePic()
      );
    });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _takePicture();
                    },
                    leading: Icon(Icons.photo_camera),
                    title: Text("Take a picture from camera")),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showPhotoLibrary();
                    },
                    leading: Icon(Icons.photo_library),
                    title: Text("Choose from photo library"))
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    color: Colors.blue,
                    child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 200.0,
                                child:  _imageURL != null
                                    ? Image.network(_imageURL, fit: BoxFit.contain)
                                    : Image.asset("assets/user_48.png", fit: BoxFit.contain)
                              ),
                              FlatButton(
                                child: Text("Change profile pic",
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.green,
                                onPressed: () {
                                  _showOptions(context);
                                },
                              )
                            ]))))));
  }
}
