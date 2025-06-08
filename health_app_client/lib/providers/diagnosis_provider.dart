// lib/providers/diagnosis_provider.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DiagnosisProvider with ChangeNotifier {
  XFile? _pickedImage;
  Map<String, dynamic>? _diagnosisResult;

  XFile? get pickedImage => _pickedImage;
  Map<String, dynamic>? get diagnosisResult => _diagnosisResult;

  void setImage(XFile? image) {
    _pickedImage = image;
    notifyListeners();
  }

  void clearResults() {
    _pickedImage = null;
    _diagnosisResult = null;
    notifyListeners();
  }
}