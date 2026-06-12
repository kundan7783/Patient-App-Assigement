import 'package:flutter/material.dart';

import '../data/patient_data.dart';
import '../screens/patient_details_screen.dart';
import '../widgets/patient_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        backgroundColor: const Color(0xff2f6df6),
        elevation: 0,
        title: const Text(
          "Patient",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: PatientData.patients.isEmpty
              ? const Center(
            child: Text(
              "No Patient Present",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          )
              : ListView.builder(
            itemCount: PatientData.patients.length,
            itemBuilder: (context, index) {
              final patient = PatientData.patients[index];

              return PatientCard(
                patient: patient,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PatientDetailsScreen(
                        patient: patient,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
    );
  }
}