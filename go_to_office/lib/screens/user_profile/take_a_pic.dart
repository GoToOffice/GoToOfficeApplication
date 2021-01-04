import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_to_office/screens/user_profile/preview.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

class TakeAPic extends StatefulWidget {
  TakeAPic({Key key}) : super(key: key);


  @override
  _TakeAPicState createState() => _TakeAPicState();
}

class MainActionBtn extends StatefulWidget {
  MainActionBtn({Key key, this.tookAPic, this.onPressed}) : super(key: key);

  @required
  final Function onPressed;
  final Function tookAPic;

  @override
  _MainActionBtnState createState() => _MainActionBtnState(tookAPic, onPressed);

}

class _MainActionBtnState extends State<MainActionBtn> {
  _MainActionBtnState(this.tookAPic, this.onPressed);

  final Function onPressed;
  final Function tookAPic;

  void handlePress() {
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        tookAPic() ? Icons.done : Icons.camera,
        color: tookAPic() ? Colors.white : Colors.black,
      ), backgroundColor: tookAPic() ? Colors.green : Colors.white,
      onPressed: () { handlePress(); },
    );
  }
}

class SecondaryActionBtn extends StatefulWidget {
  SecondaryActionBtn({Key key, this.tookAPic, this.getCameraIcon, this.onPressed}) : super(key: key);

  final IconData getCameraIcon;
  final Function tookAPic;

  @required
  final VoidCallback onPressed;


  @override
  _SecondaryActionBtnState createState() => _SecondaryActionBtnState(tookAPic, getCameraIcon, onPressed);
}

class _SecondaryActionBtnState extends State<SecondaryActionBtn> {
  _SecondaryActionBtnState(this.tookAPic, this.cameraIcon, this.onPressed);

  final VoidCallback onPressed;
  final IconData cameraIcon;
  final Function tookAPic;

  void handlePress() {
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        tookAPic() ? Icons.cancel : cameraIcon,
        color: tookAPic() ? Colors.white : Colors.black,
      ), backgroundColor: tookAPic() ? Colors.red : Colors.white,
      onPressed: () { handlePress(); },
    );
  }
}

class _TakeAPicState extends State<TakeAPic> {

  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  String imgPath;
  String fileName;
  bool tookApic = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future onNewCamera(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    controller.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Display camera preview
  Widget cameraPreview() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        'Loading',
        style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget primaryAction(context) {

    return Expanded(
        child: Align(
            alignment: Alignment.center,
            child: MainActionBtn(
              tookAPic: () => tookApic,
              onPressed: () {
                if (!tookApic)
                  onCapture(context);
                updateActionsState(!tookApic);
                },
            )
        )
    );
  }

  Widget secondaryAction() {

    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
        child: Align(
            alignment: Alignment.centerRight,
            child: SecondaryActionBtn(
              tookAPic: () => tookApic,
              getCameraIcon: getCameraLensIcons(lensDirection),
              onPressed: () {
                if (!tookApic) {
                  onSwitchCamera();
                  updateActionsState(tookApic);
                } else
                  updateActionsState(!tookApic);
                },
            )
        )
    );
  }

  onCapture(context) async {
    try {
      final p = await getTemporaryDirectory();
      final name = DateTime.now();
      final path = "${p.path}/$name.png";

      await controller.takePicture(path).then((value) {
        this.imgPath = path;
        this.fileName = "$name.png";
      });

    } catch (e) {
      showCameraException(e);
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      if(cameras.length > 0){
        setState(() {
          selectedCameraIndex = 0;
        });
        onNewCamera(cameras[selectedCameraIndex]).then((value) {

        });
      } else {
        print('No camera available');
      }
    }).catchError((e){
      print('Error : ${e.code}');
    });
  }

  void updateActionsState(bool tookApic) {
    setState(() {
      this.tookApic = tookApic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: cameraPreview(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    primaryAction(_scaffoldKey),
                    secondaryAction(),
                    Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCameraLensIcons(lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return CupertinoIcons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }

  onSwitchCamera() {
    selectedCameraIndex =
    selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    onNewCamera(selectedCamera);
  }

  showCameraException(e) {
    String errorText = 'Error ${e.code} \nError message: ${e.description}';
  }
}
