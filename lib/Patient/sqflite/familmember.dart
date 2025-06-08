import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model.dart';

class DatabaseHelper {
  static const _databaseName = 'family_info.db';
  static const _databaseVersion = 1;
  static const table = 'Family';

  // Columns of the family table
  static const columnId = 'id';
  static const columnFirstName = 'firstName';
  static const columnLastName = 'lastName';
  static const columnRelation = 'relation';
  static const columnMobileNo = 'mobileNo';
  static const columnBloodGroup = 'bloodGroup';
  static const columnDob = 'dob';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create the table if it doesn't exist
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the Family table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnFirstName TEXT NOT NULL,
      $columnLastName TEXT NOT NULL,
      $columnRelation TEXT NOT NULL,
      $columnMobileNo TEXT NOT NULL,
      $columnBloodGroup TEXT NOT NULL,
      $columnDob TEXT NOT NULL
    )
    ''');
  }

  // Insert a family member into the database
  Future<int> insertFamilyMember(Model model) async {
    Database db = await instance.database;
    return await db.insert(table, model.toMap());
  }

  // Update an existing family member
  Future<int> updateFamilyMember(Model model) async {
    Database db = await instance.database;
    return await db.update(table, model.toMap(),
        where: '$columnId = ?', whereArgs: [model.id]);
  }

  // Delete a family member
  Future<int> deleteFamilyMember(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Retrieve all family members
  Future<List<Model>> getFamilyMembers() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return Model.fromMap(maps[i]);
    });
  }
}

class FamilyMembersInfo extends StatefulWidget {
  const FamilyMembersInfo({super.key});
  @override
  State createState() => _FamilyMembersInfoState();
}

class _FamilyMembersInfoState extends State<FamilyMembersInfo> {
  final TextEditingController _relationcontroller = TextEditingController();
  final TextEditingController _firstNamecontroller = TextEditingController();
  final TextEditingController _lastNamecontroller = TextEditingController();
  final TextEditingController _mobileNocontroller = TextEditingController();
  final TextEditingController _bloodGroupcontroller = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  late DatabaseHelper dbHelper;
  List<Model> data = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _loadFamilyData();
  }

  // Load data from the database
  _loadFamilyData() async {
    List<Model> members = await dbHelper.getFamilyMembers();
    if (mounted) {
      setState(() {
        data = members;
      });
    }
  }

  // Submit method for adding or updating family members
  // Submit method for adding or updating family members
  void submit(bool edit, context, [Model? obj]) async {
    if (_relationcontroller.text.trim().isNotEmpty &&
        _firstNamecontroller.text.trim().isNotEmpty &&
        _lastNamecontroller.text.trim().isNotEmpty &&
        _mobileNocontroller.text.trim().isNotEmpty &&
        _bloodGroupcontroller.text.trim().isNotEmpty &&
        _dobController.text.trim().isNotEmpty) {
      Model member = Model(
        relation: _relationcontroller.text,
        firstName: _firstNamecontroller.text,
        lastName: _lastNamecontroller.text,
        mobileNo: _mobileNocontroller.text,
        bloodGroup: _bloodGroupcontroller.text,
        dob: _dobController.text,
      );

      if (edit) {
        member.id = obj!.id; // Set the id of the object
        await dbHelper.updateFamilyMember(member);
      } else {
        await dbHelper.insertFamilyMember(member);
      }

      _loadFamilyData();
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(context)
            .pop(); // This ensures that the bottom sheet is closed after a small delay
      });

      clearControllers();
    }
  }

  // Clear all controllers after submission
  void clearControllers() {
    _firstNamecontroller.clear();
    _relationcontroller.clear();
    _mobileNocontroller.clear();
    _bloodGroupcontroller.clear();
    _lastNamecontroller.clear();
    _dobController.clear();
  }

  // Delete a family member
  void deleteFamilyMember(int id) async {
    await dbHelper.deleteFamilyMember(id);
    _loadFamilyData();
  }

  // Show the bottom sheet for adding/editing family members
  void bottomSheet(bool edit, BuildContext context, [Model? obj]) {
    if (mounted) {
      if (edit && obj != null) {
        _relationcontroller.text = obj.relation;
        _firstNamecontroller.text = obj.firstName;
        _lastNamecontroller.text = obj.lastName;
        _mobileNocontroller.text = obj.mobileNo;
        _bloodGroupcontroller.text = obj.bloodGroup;
        _dobController.text = obj.dob;

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Padding(
        //       padding: EdgeInsets.only(bottom: 10.0),
        //       child: Text(
        //         "Family Member Added",
        //       ),
        //     ),
        //     backgroundColor: Colors.blue,
        //   ),
        // );
      } else {
        clearControllers(); // Clear fields if it's for adding a new member
      }
///////////////////////////////////////////////////////////////////////////////////////
      DateTime _selectedDate = DateTime.now();

      Future<void> _selectDate(BuildContext context) async {
        final DateTime picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate, // initial date
              firstDate: DateTime(1900), // The earliest date that can be picked
              lastDate:
                  DateTime.now(), // The latest date that can be picked (today)
            ) ??
            _selectedDate; // If null, keep the current date

        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
            _dobController.text =
                "${_selectedDate.toLocal()}".split(' ')[0]; // Format the date
          });
        }
      }

      ////////////////////////////////////////////////////////////////////////////////

      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                right: 20,
                left: 20,
                top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _relationcontroller,
                  decoration: InputDecoration(
                    labelText: 'Relation :',
                    labelStyle: const TextStyle(color: Colors.blue),
                    //  hintText: 'Type something here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _firstNamecontroller,
                  decoration: InputDecoration(
                    labelText: 'First Name :',
                    labelStyle: const TextStyle(color: Colors.blue),
                    //  hintText: 'Type something here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _lastNamecontroller,
                  decoration: InputDecoration(
                    labelText: 'Last Name :',
                    labelStyle: const TextStyle(color: Colors.blue),
                    //  hintText: 'Type something here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _mobileNocontroller,
                  decoration: InputDecoration(
                    labelText: 'Mobile No :',
                    labelStyle: const TextStyle(color: Colors.blue),
                    //  hintText: 'Type something here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _bloodGroupcontroller,
                  decoration: InputDecoration(
                    labelText: 'Blood Group :',
                    labelStyle: const TextStyle(color: Colors.blue),
                    //  hintText: 'Type something here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth :',
                    labelStyle: const TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Color.fromARGB(236, 13, 194, 255),
                      ),
                      // Calendar icon
                      onPressed: () {
                        _selectedDate; // Open the date picker when clicked
                      },
                    ),
                  ),

                  readOnly: true, // Make the TextField read-only
                  onTap: () {
                    _selectDate(context); // Open the date picker when tapped
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    submit(edit, obj);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Family Members"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Colors.blue[100],
              child: ListTile(
                leading: const Icon(
                  Icons.account_circle,
                  size: 50,
                ),
                // title: Text("Name : ${data[index].firstName}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${data[index].firstName}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "Relation: ${data[index].relation}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "Mobile No: ${data[index].mobileNo}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "Blood Group: ${data[index].bloodGroup}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        bottomSheet(true, context, data[index]);
                      },
                    ),
                    IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteFamilyMember(data[index].id!);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomSheet(false, context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
