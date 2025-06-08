class StocklistModel {
  String MedicineUrl;
  String MedicineName;
  String Rssss;
  String expiry;
  int Quantity;
  bool alert;

  StocklistModel({
    required this.MedicineUrl,
    required this.MedicineName,
    required this.Rssss,
    required this.expiry,
    required this.Quantity,
    this.alert = false,
  });
}
