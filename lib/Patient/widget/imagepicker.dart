import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:trackrx/AuthenticationPatient/patient/registerpatient.dart';
import 'package:trackrx/hospital/requestData.dart';

class MyImagepicker {
  static Future<void> uplodImage({required String FileName}) async {
    log("in Upload image method");
    await FirebaseStorage.instance
        .ref()
        .child(FileName)
        .putFile(File(selectfile!.path));
  }

  static Future<String> downLoadImageUrl({required String FileName}) async {
    log("in download image method");
    String url =
        await FirebaseStorage.instance.ref().child(FileName).getDownloadURL();
    log("Image url :$url");
    return url;
  }
}
