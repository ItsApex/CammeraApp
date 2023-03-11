import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Ensure that plugin services are initialized before 'runApp()'
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device
  final cameras = await availableCameras();

  // Select the first camera from the list
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;

  const MyApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();

    // Create a CameraController object
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    // Initialize the controller and store the future
    _initializeControllerFuture = _controller.initialize().then((_) {
      // When the controller is initialized, take a photo automatically
      _takePhoto();
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      // Construct the path where the image should be saved using the path_provider plugin
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/image.jpg';

      // Take the picture and save it to the specified path
      await _controller.takePicture();

      // Display the captured photo on the screen
      setState(() {
        _imageFile = XFile(imagePath);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _imageFile == null
              ? FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the camera preview
                      return CameraPreview(_controller);
                    } else {
                      // Otherwise, display a loading spinner
                      return const CircularProgressIndicator();
                    }
                  },
                )
              : Image.file(File(_imageFile!.path)),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: _takePhoto,
        ),
      ),
    );
  }
}
