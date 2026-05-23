class PatientModel {
  String name;
  int age;
  String hospital;
  String condition;
  bool emergency;
  String imagePath;
  double latitude;
  double longitude;

  PatientModel({
    required this.name,
    required this.age,
    required this.hospital,
    required this.condition,
    required this.emergency,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
  });
}