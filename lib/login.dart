import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'camera_screen.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});

  @override
  State<LoginInScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginInScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(30),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.020,
                ),
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(hintText: "Username"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.020,
                ),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(hintText: "Password"),
                  obscureText: true,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.020,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_username.text == 'abc' && _password.text == 'abc') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CameraScreen()),
                      );
                    }
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
