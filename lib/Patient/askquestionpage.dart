import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AskQuestionHere extends StatefulWidget {
  const AskQuestionHere({super.key});

  @override
  _AskQuestionHereState createState() => _AskQuestionHereState();
}

class _AskQuestionHereState extends State<AskQuestionHere> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final List<String> _suggestions = [
    "What are the visiting hours?",
    "Is emergency service available?",
    "How can I book an appointment?",
    "What are the hospital charges?",
    "Are there any specialists available?",
  ];

  String? _selectedHospital;
  List<String> _hospitalNames = [];

  @override
  void initState() {
    super.initState();
    _fetchHospitalNames();
  }

  Future<void> _fetchHospitalNames() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('hospital').get();
      final List<String> hospitalNames = snapshot.docs
          .map((doc) => doc.data()['hospitalName'] as String)
          .toList();
      setState(() {
        _hospitalNames = hospitalNames;
        if (_hospitalNames.isNotEmpty) {
          _selectedHospital = _hospitalNames.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching hospital names: $e')),
      );
    }
  }

  Future<void> _submitToFirestore(String type, String content) async {
    if (_selectedHospital == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a hospital.')),
      );
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance
          .collection('patientquestion')
          .doc(_selectedHospital);

      await docRef.set({
        type: FieldValue.arrayUnion([content]),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$type submitted for $_selectedHospital')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting $type: $e')),
      );
    }
  }

  void _submitQuestion() {
    final question = _questionController.text.trim();
    if (question.isNotEmpty) {
      _submitToFirestore('questions', question);
      _questionController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a question before submitting.')),
      );
    }
  }

  void _submitFeedback() {
    final feedback = _feedbackController.text.trim();
    if (feedback.isNotEmpty) {
      _submitToFirestore('feedback', feedback);
      _feedbackController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter feedback before submitting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask a Question'),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 10.0, top: 15, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Hospital:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedHospital,
              isExpanded: true,
              hint: const Text('Select Hospital'),
              items: _hospitalNames
                  .map((hospital) => DropdownMenuItem(
                        value: hospital,
                        child: Text(hospital),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHospital = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                hintText: 'Ask question here',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitQuestion,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit Question'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Suggestions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    leading: const Icon(Icons.help_outline),
                    onTap: () {
                      setState(() {
                        _questionController.text = _suggestions[index];
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                hintText: 'Enter your feedback here',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
