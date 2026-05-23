import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../models/patient_model.dart';
import '../data/patient_data.dart';

class AddPatientService {
  final ImagePicker _picker = ImagePicker();

  // ================= GET CURRENT LOCATION =================
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location service disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ================= IMAGE PICKER =================
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return null;
    return File(image.path);
  }

  Future<File?> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) return null;
    return File(image.path);
  }

  // ================= VALIDATION + ADD PATIENT =================
  String? validate({
    required String name,
    required String age,
    required String hospital,
    required String condition,
  }) {
    if (name.isEmpty) return "Name required";
    if (age.isEmpty) return "Age required";
    if (hospital.isEmpty) return "Hospital required";
    if (condition.isEmpty) return "Condition required";

    final intAge = int.tryParse(age);
    if (intAge == null) return "Age must be number";

    return null;
  }

  // ================= ADD PATIENT =================
  void addPatient(PatientModel patient) {
    PatientData.patients.add(patient);
  }
}