import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../vitalModelclass/blood_glucoseModel.dart';

Future<void> saveBloodGlucoseData(List<BloodGlucosemodel> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the list of objects to a JSON string
  List<String> jsonList =
      list.map((item) => jsonEncode(item.toJson())).toList();

  // Save the list
  prefs.setStringList('bloodGlucoseData', jsonList);
}

Future<List<BloodGlucosemodel>> getBloodGlucoseData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('bloodGlucoseData');

  if (jsonList != null) {
    return jsonList
        .map((jsonItem) => BloodGlucosemodel.fromJson(jsonDecode(jsonItem)))
        .toList();
  }
  return [];
}

Future<void> saveBloodOxygenData(List<Bloodoxygenmodel> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the list of objects to a JSON string
  List<String> jsonList =
      list.map((item) => jsonEncode(item.toJson())).toList();

  // Save the list
  prefs.setStringList('bloodOxygenData', jsonList);
}

Future<List<Bloodoxygenmodel>> getBloodOxygenData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('bloodOxyegenData');

  if (jsonList != null) {
    return jsonList
        .map((jsonItem) => Bloodoxygenmodel.fromJson(jsonDecode(jsonItem)))
        .toList();
  }
  return [];
}

Future<void> saveBloodPressureData(List<Bloodpressuremodel> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the list of objects to a JSON string
  List<String> jsonList =
      list.map((item) => jsonEncode(item.toJson())).toList();

  // Save the list
  prefs.setStringList('bloodPressureData', jsonList);
}

Future<List<Bloodpressuremodel>> getBloodPressureData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('bloodPressureData');

  if (jsonList != null) {
    return jsonList
        .map((jsonItem) => Bloodpressuremodel.fromJson(jsonDecode(jsonItem)))
        .toList();
  }
  return [];
}

Future<void> saveWeightData(List<weightmodel> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the list of objects to a JSON string
  List<String> jsonList =
      list.map((item) => jsonEncode(item.toJson())).toList();

  // Save the list
  prefs.setStringList('bloodWeightData', jsonList);
}

Future<List<weightmodel>> getWeightData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('WeightData');

  if (jsonList != null) {
    print("get the dataaa");
    return jsonList
        .map((jsonItem) => weightmodel.fromJson(jsonDecode(jsonItem)))
        .toList();
  }
  return [];
}
