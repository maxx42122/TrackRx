class PatientModel {
  String name;
  String email;
  dynamic age; // Use dynamic to handle both int and String
  String imageUrl;
  String gender;

  PatientModel({
    required this.name,
    required this.email,
    required this.age,
    required this.imageUrl,
    required this.gender,
  });
}
