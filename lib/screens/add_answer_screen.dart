import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAnswerScreen extends StatefulWidget {
  const AddAnswerScreen({super.key});

  @override
  State<AddAnswerScreen> createState() => _AddAnswerScreenState();
}

class _AddAnswerScreenState extends State<AddAnswerScreen> {
  var titleController = TextEditingController();
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Add Read', style: TextStyle(color: Colors.black)),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black54),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(hintText: 'Enter the title here'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textController,
              maxLines: 10, //or null
              decoration: const InputDecoration.collapsed(
                  hintText: "Enter the text here"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  String titleRead = titleController.text.trim();
                  String textRead = textController.text.trim();

                  if (titleRead.isEmpty || textRead.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Please provide corrected fill');
                    return;
                  }

                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    String uid = user.uid;
                    int dt = DateTime.now().millisecondsSinceEpoch;

                    DatabaseReference taskRef = FirebaseDatabase.instance
                        .reference()
                        .child('data_reads')
                        .child(uid);

                    String? taskId = taskRef.push().key;

                    await taskRef.child(taskId).set({
                      'dt': dt,
                      'titleRead': titleRead,
                      'textRead': textRead,
                      'taskId': taskId,
                    });
                  }
                },
                child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
