// class Model {
//   String relation;
//   String firstName;
//   String lastName;
//   String mobileNo;
//   String bloodGroup;
//   String dob;

//   Model(
//       {required this.relation,
//       required this.firstName,
//       required this.lastName,
//       required this.mobileNo,
//       required this.bloodGroup,
//       required this.dob});

//   Map<String, dynamic> FamilyInfoMap() {
//     return {
//       'relation': relation,
//       'firstName': firstName,
//       'lastNAme': lastName,
//       'mobileNo': mobileNo,
//       'bloodGroup': bloodGroup,
//       'dob': dob,
//     };
//   }
// }

class Model {
  int? id;
  String firstName;
  String lastName;
  String relation;
  String mobileNo;
  String bloodGroup;
  String dob;

  Model({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.relation,
    required this.mobileNo,
    required this.bloodGroup,
    required this.dob,
  });

  // Convert a Model object into a map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'relation': relation,
      'mobileNo': mobileNo,
      'bloodGroup': bloodGroup,
      'dob': dob,
    };
  }

  // Extract a Model object from a map object
  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      relation: map['relation'],
      mobileNo: map['mobileNo'],
      bloodGroup: map['bloodGroup'],
      dob: map['dob'],
    );
  }
}
