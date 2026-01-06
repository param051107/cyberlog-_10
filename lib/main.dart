import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.cyanAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.cyanAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const CyberPermissionScreen(),
    );
  }
}

class CyberPermissionScreen extends StatefulWidget {
  const CyberPermissionScreen({super.key});

  @override
  State<CyberPermissionScreen> createState() => _CyberPermissionScreenState();
}

class _CyberPermissionScreenState extends State<CyberPermissionScreen> {
  String status = "Awaiting action...";
  File? image;

  // 📷 CAMERA
  Future<void> openCamera() async {
    final statusPermission = await Permission.camera.request();

    if (statusPermission.isGranted) {
      final picker = ImagePicker();
      final picked =
      await picker.pickImage(source: ImageSource.camera);

      if (picked != null) {
        setState(() {
          image = File(picked.path);
          status = "CAMERA ACCESS GRANTED";
        });
      }
    } else {
      setState(() {
        status = "CAMERA ACCESS DENIED";
      });
    }
  }

  // 📁 STORAGE
  Future<void> requestStorage() async {
    final storageStatus = await Permission.photos.request();

    setState(() {
      status = storageStatus.isGranted
          ? "STORAGE ACCESS GRANTED"
          : "STORAGE ACCESS DENIED";
    });
  }

  // 🌐 INTERNET
  Future<void> checkInternet() async {
    try {
      final response =
      await http.get(Uri.parse("https://api.ipify.org?format=json"));

      setState(() {
        status = response.statusCode == 200
            ? "INTERNET CONNECTED"
            : "INTERNET ERROR";
      });
    } catch (_) {
      setState(() {
        status = "NO INTERNET CONNECTION";
      });
    }
  }

  Widget cyberButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 1,
          )
        ],
        border: Border.all(color: Colors.cyanAccent, width: 1.5),
      ),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.cyanAccent),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027), // dark blue-black
                  Color(0xFF203A43), // cyber blue
                  Color(0xFF2C5364), // glowing blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 1,
                )
              ],
            ),
          ),
          title: const Text(
            "CYBER PERMISSION CONTROL",
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Colors.cyanAccent,
                  blurRadius: 12,
                )
              ],
            ),
          ),
        ),

        body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (image != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.4),
                      blurRadius: 15,
                    )
                  ],
                ),
                child: Image.file(image!, height: 200),
              ),

            cyberButton(
              icon: Icons.camera_alt,
              text: "ACTIVATE CAMERA",
              onTap: openCamera,
            ),

            cyberButton(
              icon: Icons.folder,
              text: "ACCESS STORAGE",
              onTap: requestStorage,
            ),

            cyberButton(
              icon: Icons.wifi,
              text: "CHECK INTERNET",
              onTap: checkInternet,
            ),

            const SizedBox(height: 25),

            Text(
              status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.cyanAccent,
                    blurRadius: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
