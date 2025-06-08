


class StockModel{

  String MdName;
  String destination;
  String quantity;
  String recevied;
  StockModel({
    required this.MdName,
    required this.destination,
    required this.quantity,
    required this.recevied,
    });

  static  List <StockModel> data=[

  ];


  static void  modelObject(StockModel obj){

    data.add(obj);
  }
}