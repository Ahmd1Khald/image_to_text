import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? outputText;
  File? _image;
  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      print("Error when pickImage $e");
    }
  }

  Future _textRecognition(File image) async {
    final testRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText =
        await testRecognizer.processImage(inputImage);
    setState(() {
      outputText = recognizedText.text;
    });
    print(outputText);
    testRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                ),
                child: Center(
                    child: _image == null
                        ? const Icon(
                            Icons.camera_alt,
                            size: 60,
                          )
                        : Image.file(_image!)),
              ),
              const SizedBox(
                height: 15,
              ),
              MaterialButton(
                color: Colors.blueGrey,
                textColor: Colors.white,
                onPressed: () {
                  _pickImage(ImageSource.camera).then((value) {
                    if (_image != null) {
                      _textRecognition(_image!);
                    }
                  });
                },
                child: Text('من الكاميرا'),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.blueGrey,
                textColor: Colors.white,
                onPressed: () {
                  _pickImage(ImageSource.gallery).then((value) {
                    if (_image != null) {
                      _textRecognition(_image!);
                    }
                  });
                },
                child: Text('من المعرض'),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                outputText ?? 'Empty',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
