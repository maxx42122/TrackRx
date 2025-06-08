import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewQuestionsFeedback extends StatefulWidget {
  final String hospitalName; // Pass the hospital name as a parameter

  const ViewQuestionsFeedback({super.key, required this.hospitalName});

  @override
  _ViewQuestionsFeedbackState createState() => _ViewQuestionsFeedbackState();
}

class _ViewQuestionsFeedbackState extends State<ViewQuestionsFeedback> {
  List<String> _questions = [];
  List<String> _feedbacks = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('patientquestion')
          .doc(widget.hospitalName);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          _questions = List<String>.from(data?['questions'] ?? []);
          _feedbacks = List<String>.from(data?['feedback'] ?? []);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data found for this hospital.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions & Feedback'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Questions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _questions.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.question_answer),
                          title: Text(_questions[index]),
                        );
                      },
                    )
                  : const Text('No questions found.'),
              const SizedBox(height: 20),
              const Text(
                'Feedback:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _feedbacks.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _feedbacks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.feedback),
                          title: Text(_feedbacks[index]),
                        );
                      },
                    )
                  : const Text('No feedback found.'),
            ],
          ),
        ),
      ),
    );
  }
}
