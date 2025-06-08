class BloodGlucosemodel {
  final String glucoselevel;
  final String value1;
  final String measuredon;
  final String note;

  BloodGlucosemodel(
      {required this.glucoselevel,
      required this.value1,
      required this.measuredon,
      required this.note});

  Map<String, dynamic> toJson() {
    return {
      'glucoselevel': glucoselevel,
      'value1': value1,
      'measuredon': measuredon,
      'note': note,
    };
  }

  // Create object from JSON
  factory BloodGlucosemodel.fromJson(Map<String, dynamic> json) {
    return BloodGlucosemodel(
      glucoselevel: json['glucoselevel'],
      value1: json['value1'],
      measuredon: json['measuredon'],
      note: json['note'],
    );
  }

  get timestamp => DateTime.november;
}

class Bloodoxygenmodel {
  String spo2;
  String pulseRate;
  String measuredon;
  String note;
  Bloodoxygenmodel(
      {required this.spo2,
      required this.pulseRate,
      required this.note,
      required this.measuredon});

  Map<String, dynamic> toJson() {
    return {
      'spo2': spo2,
      'pulseRate': pulseRate,
      'measuredon': measuredon,
      'note': note,
    };
  }

  // Create object from JSON
  factory Bloodoxygenmodel.fromJson(Map<String, dynamic> json) {
    return Bloodoxygenmodel(
      spo2: json['spo2'],
      pulseRate: json['pulseRate'],
      measuredon: json['measuredon'],
      note: json['note'],
    );
  }

  get timestamp => DateTime.november;
}

class Bloodpressuremodel {
  String systolic;
  String diastolic;
  String pulse;
  String measuredon;
  String note;
  Bloodpressuremodel(
      {required this.systolic,
      required this.diastolic,
      required this.pulse,
      required this.measuredon,
      required this.note});

  Map<String, dynamic> toJson() {
    return {
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'measuredon': measuredon,
      'note': note,
    };
  }

  // Create object from JSON
  factory Bloodpressuremodel.fromJson(Map<String, dynamic> json) {
    return Bloodpressuremodel(
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      pulse: json['pulse'],
      measuredon: json['measuredon'],
      note: json['note'],
    );
  }

  get timestamp => DateTime.november;
}

class weightmodel {
  String weight;
  String height;
  String measuredon;
  String note;
  weightmodel(
      {required this.weight,
      required this.height,
      required this.measuredon,
      required this.note});

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'measuredon': measuredon,
      'note': note,
    };
  }

  // Create object from JSON
  factory weightmodel.fromJson(Map<String, dynamic> json) {
    return weightmodel(
      weight: json['weight'],
      height: json['height'],
      measuredon: json['measuredon'],
      note: json['note'],
    );
  }

  get timestamp => DateTime.november;
}
