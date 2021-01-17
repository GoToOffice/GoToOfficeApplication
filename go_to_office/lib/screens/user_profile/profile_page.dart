import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_to_office/util/repository.dart';
import 'package:go_to_office/util/strings.dart';
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

  final _userTextController = TextEditingController();

  @override
  void initState() {
    getAvatarURL();
    super.initState();
  }

  Future<void> getAvatarURL() async {
    String downloadURL = await repository.getAvatarUrl();

    setState(() {
      _imageURL = downloadURL;
    });
  }

  void _showPhotoLibrary() async {
    final file = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _path = file.path;
      repository.uploadAvatar(File(_path)).then((value) => getAvatarURL());
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
      repository.uploadAvatar(File(_path)).then((value) => getAvatarURL());
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
  void dispose() {
    // Cleans up the controller when the widget is disposed.
    _userTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: _userTextController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 200,
                                  height: 200,
                                  child: ClipOval(
                                      child: _imageURL == null
                                          ? Image.asset('assets/user_profile_b_24.png', fit: BoxFit.fill)
                                          : CachedNetworkImage(
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              imageUrl: _imageURL,
                                              fit: BoxFit.fill,
                                            )
                                  )
                              ),
                              FlatButton(
                                child: Text("Change profile pic",
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.green,
                                onPressed: () {
                                  _showOptions(context);
                                },
                              ),
                            ]))))));
  }
}
