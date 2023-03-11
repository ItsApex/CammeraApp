import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Timer _timer;
  int _countdown = 8;
  late BuildContext _context;

  @override
  void initState() {
    super.initState();
    _context = context;

    // Call the asynchronous method here
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Initialize Flutter binding
    WidgetsFlutterBinding.ensureInitialized();

    await Permission.storage.request();
    await Permission.location.request();

    // Get available cameras
    List<CameraDescription> cameras = await availableCameras();
    CameraDescription firstCamera = cameras.first;

    // Create a CameraController instance
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // Initialize the camera controller and start the camera preview
    await _controller.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});

    // Start the countdown timer when the camera preview is ready
    _startCountdown();
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  void _startCountdown() {
    // Start a timer that counts down from 8 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown -= 1;
      });

      // When the countdown reaches 0, take a photo and cancel the timer
      if (_countdown == 0) {
        _controller.takePicture().then((XFile file) async {
          // Save the file to the device's gallery
          final path = (await getTemporaryDirectory()).path;
          final fileName = DateTime.now().toString();
          final newPath = '$path/$fileName.jpg';
          await file.saveTo(newPath);
          final result = await GallerySaver.saveImage(newPath);
          // print('Image saved to gallery: $result');
          // Exit the camera screen
          // Navigator.of(context).pop();
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Camera preview
              Expanded(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller),
                      )
                    : Container(),
              ),
              // Countdown timer
              TimerBuilder.periodic(const Duration(seconds: 1),
                  builder: (context) {
                if (_countdown == 0) {
                  return Container();
                } else {
                  return Center(
                    child: Text(
                      '$_countdown',
                      style: const TextStyle(fontSize: 64),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
