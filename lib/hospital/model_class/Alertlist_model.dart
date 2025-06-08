import 'package:cloud_firestore/cloud_firestore.dart';

class AlertlistModel {
  static int countorder = 0;
  static int countmedicine = 0;
  static List<String> AlertData = [];

  static Future<void> updateOrderCount(String hospitalId) async {
    // Listen to changes in the 'manufacturerorder' collection
    FirebaseFirestore.instance
        .collection('manufactureorder')
        .where('hospitalId', isEqualTo: hospitalId)
        .snapshots()
        .listen((snapshot) {
      int newOrderCount = 0;

      // Loop through all orders to count new ones
      for (var doc in snapshot.docs) {
        final orders = doc['orders'] as List<dynamic>?;
        if (orders != null) {
          newOrderCount +=
              orders.where((order) => order['status'] == 'New').length;
        }
      }

      // Update the count and notify listeners
      countorder = newOrderCount;
    });
  }
}
