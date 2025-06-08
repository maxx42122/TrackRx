import 'package:flutter/material.dart';

class MedicineSearchPage extends StatefulWidget {
  const MedicineSearchPage({super.key});

  @override
  _MedicineSearchPageState createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends State<MedicineSearchPage> {
  TextEditingController demotextcontroller = TextEditingController();
  List<Map<String, dynamic>> medicineList = [];
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    fetchMedicineData();
  }

  Future<void> fetchMedicineData() async {
    // Fetch data from Firestore
    // Your existing code for fetching data from Firestore
  }

  void filterMedicines(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(medicineList);
      } else {
        filteredList = medicineList
            .where((medicine) =>
                medicine['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void showMedicineDialog(Map<String, dynamic> medicine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Medicine Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(medicine['imageUrl'],
                  height: 150, width: 150, fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text('ID: ${medicine['productId']}'),
              Text('Name: ${medicine['name']}'),
              Text('Price: Rs. ${medicine['price']}'),
              Text('Expiry Date: ${medicine['expiryDate']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // This ensures the layout adjusts when the keyboard appears
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                Image.asset("assets/patient/logo.png", height: 120, width: 80),
                const Text(
                  "TrackRx",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                )
              ],
            ),
            FocusableActionDetector(
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  // This will make sure the keyboard opens when the TextField is focused
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              child: TextField(
                keyboardAppearance: Brightness.light,
                controller: demotextcontroller,
                onChanged: filterMedicines,
                decoration: const InputDecoration(
                  hintText: "Search for Medicine",
                  filled: true,
                  fillColor: Color.fromARGB(255, 229, 238, 245),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  // suffixIcon: GestureDetector(
                  //   onTap: () {
                  //     print("scan chya aatmadhe");
                  //     Navigator.pushNamed(context, "/scan");
                  //   },
                  //   child: const Icon(
                  //     Icons.qr_code_scanner,
                  //     color: Color.fromRGBO(5, 77, 154, 1),
                  //   ),
                  // ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            // List of Medicines
            filteredList.isEmpty
                ? const Center(
                    child: Text("No medicines found",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showMedicineDialog(filteredList[index]);
                        },
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Image of the medicine
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          filteredList[index]['imageUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Name: ${filteredList[index]['name']}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 5),
                                      Text(
                                          "ID: ${filteredList[index]['productId']}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                      const SizedBox(height: 5),
                                      Text(
                                          "Price: Rs. ${filteredList[index]['price']}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                      const SizedBox(height: 5),
                                      Text(
                                          "Expiry: ${filteredList[index]['expiryDate']}",
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
