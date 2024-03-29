import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_radec_1/models/read_model.dart';

class UpdateTaskScreen extends StatefulWidget {
  final ReadModel task;
  const UpdateTaskScreen({super.key, required this.task});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  var titleController = TextEditingController();
  var textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task.titleRead;
    textController.text = widget.task.textRead;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Edit Read', style: TextStyle(color: Colors.black)),
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
            ElevatedButton(
                onPressed: () async {
                  var titleRead = titleController.text.trim();
                  var textRead = textController.text.trim();
                  if (titleRead.isEmpty || textRead.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Please provide corrected fill');
                    return;
                  }

                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    DatabaseReference taskRef = FirebaseDatabase.instance
                        .reference()
                        .child('data_reads')
                        .child(user.uid)
                        .child(widget.task.taskId);

                    await taskRef.update({
                      'titleRead': titleRead,
                      'textRead': textRead,
                    });
                  }
                },
                child: const Text('Update')),
          ],
        ),
      ),
    );
  }
}
