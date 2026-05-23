import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/patient_model.dart';
import '../services/add_patient_service.dart';

class AddPatientScreen extends StatefulWidget {
  final VoidCallback onSuccess;

  const AddPatientScreen({super.key, required this.onSuccess});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final conditionController = TextEditingController();

  bool isEmergency = false;
  String? selectedHospital;
  GoogleMapController? mapController;

  final hospitals = ["AIIMS", "Apollo", "Fortis", "Max Hospital"];

  final AddPatientService _service = AddPatientService();

  File? selectedImage;
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF3FF),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff2F6DF6),
        title: const Text(
          "Add Patient",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // ================= PATIENT INFO =================
              _sectionCard(
                title: "Patient Information",
                icon: Icons.person_outline,
                child: Column(
                  children: [

                    Row(
                      children: [
                        Expanded(child: _field("Patient Name", nameController)),
                        const SizedBox(width: 10),
                        Expanded(child: _field("Age", ageController, number: true)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Emergency Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Accidental Case - Emergency",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Switch(
                          value: isEmergency,
                          activeColor: Colors.red,
                          onChanged: (v) {
                            setState(() => isEmergency = v);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _field("Medical Condition", conditionController, max: 2),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // ================= HOSPITAL =================
              _sectionCard(
                title: "Select Hospital",
                icon: Icons.local_hospital_outlined,
                child: DropdownButtonFormField(
                  value: selectedHospital,
                  decoration: _inputDecoration(),
                  hint: const Text("Select Hospital"),
                  items: hospitals
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    setState(() => selectedHospital = v);
                  },
                ),
              ),

              const SizedBox(height: 15),

              // ================= IMAGE UPLOAD =================
              GestureDetector(
                onTap: () async {
                  final result = await showModalBottomSheet<File?>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      return SafeArea(
                        child: Wrap(
                          children: [

                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text("Gallery"),
                              onTap: () async {
                                final img = await _service.pickImageFromGallery();
                                Navigator.pop(context, img);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("Camera"),
                              onTap: () async {
                                final img = await _service.pickImageFromCamera();
                                Navigator.pop(context, img);
                              },
                            ),

                          ],
                        ),
                      );
                    },
                  );

                  if (result != null) {
                    setState(() {
                      selectedImage = result;
                    });
                  }
                },
                child: _sectionCard(
                  title: "Upload Picture (Self or Others)",
                  icon: Icons.image_outlined,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade300, width: 1.5),
                      color: Colors.blue.shade50,
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedImage!,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, color: Colors.blue),
                        SizedBox(height: 8),
                        Text("Tap to upload patient picture"),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ================= LOCATION =================
              _sectionCard(
                title: "Location",
                icon: Icons.location_on_outlined,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _locationBox("Latitude", latitude.toString()),
                        const SizedBox(width: 10),
                        _locationBox("Longitude", longitude.toString()),
                      ],
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff2F6DF6),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final pos = await _service.getCurrentLocation();

                            setState(() {
                              latitude = pos.latitude;
                              longitude = pos.longitude;
                            });

                            // 🔥 MAP KO MOVE KARO CURRENT LOCATION PE
                            mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                LatLng(pos.latitude, pos.longitude),
                                16,
                              ),
                            );

                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        icon: const Icon(Icons.my_location),
                        label: const Text("Get Current Location"),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= SAVE BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2F6DF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                    onPressed: () {
                      final error = _service.validate(
                        name: nameController.text,
                        age: ageController.text,
                        hospital: selectedHospital ?? "",
                        condition: conditionController.text,
                      );

                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                        return;
                      }

                      final patient = PatientModel(
                        name: nameController.text,
                        age: int.parse(ageController.text),
                        hospital: selectedHospital!,
                        condition: conditionController.text,
                        emergency: isEmergency,
                        imagePath: selectedImage?.path ?? "",
                        latitude: latitude,
                        longitude: longitude,
                      );

                      _service.addPatient(patient);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Patient Added Successfully")),
                      );

                      widget.onSuccess();
                    },
                  child: const Text(
                    "Save Patient",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SECTION CARD =================
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // header
          Row(
            children: [
              Icon(icon, color: const Color(0xff2F6DF6), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _field(String hint, TextEditingController c,
      {bool number = false, int max = 1}) {
    return TextFormField(
      controller: c,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      maxLines: max,
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration([String? hint]) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xffF6F8FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  // ================= LOCATION BOX =================
  Widget _locationBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffF6F8FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }


}
