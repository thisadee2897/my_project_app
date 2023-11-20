// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;
  String? _resultText;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _resultText = null;
      });
    } else {
      const AlertDialog();
    }
  }

  Future<void> _performOCR() async {
    if (_imageFile == null) {
      return;
    }
    try {
      print("_imageFile=${_imageFile!.path}");
      String result = await FlutterTesseractOcr.extractText(
        _imageFile!.path,
        language: 'eng',
      );
      setState(() {
        _resultText = result;
      });
    } on PlatformException catch (e) {
      print('Error during OCR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16.0),
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_imageFile != null) {
                  _performOCR();
                }
              },
              child: const Text('Perform OCR'),
            ),
            const SizedBox(height: 16.0),
            if (_resultText != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _resultText!,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
