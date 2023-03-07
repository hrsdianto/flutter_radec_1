import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radec_1/screens/add_answer_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter_radec_1/models/read_model.dart';
import 'package:flutter_radec_1/screens/update_task_screen.dart';

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  User? user;
  DatabaseReference? taskRef;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      taskRef = FirebaseDatabase.instance
          .reference()
          .child('data_reads')
          .child(user!.uid);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Answer', style: TextStyle(color: Colors.black)),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black54),
        ),
      ),
      body: StreamBuilder(
        stream: taskRef != null ? taskRef!.onValue : null,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            var event = snapshot.data as Event;

            var snapshot2 = event.snapshot.value;
            if (snapshot2 == null) {
              return const Center(
                child: Text('No Read Added Yet'),
              );
            }

            Map<String, dynamic> map = Map<String, dynamic>.from(snapshot2);

            var tasks = <ReadModel>[];

            for (var taskMap in map.values) {
              ReadModel taskModel =
                  ReadModel.fromMap(Map<String, dynamic>.from(taskMap));

              tasks.add(taskModel);
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    ReadModel task = tasks[index];

                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  task.titleRead,
                                  //"You Can Wrap your widget with Flexible Widget and than you can set property of Text using overflow property of Text Widget",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '(${getHumanReadableDate(task.dt)})',
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: const Text('Confirmation !!!'),
                                          content: const Text(
                                              'Are you sure to delete ? '),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: const Text('No')),
                                            TextButton(
                                                onPressed: () async {
                                                  if (taskRef != null) {
                                                    await taskRef!
                                                        .child(task.taskId)
                                                        .remove();
                                                  }

                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: const Text('Yes')),
                                          ],
                                        );
                                      });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return UpdateTaskScreen(task: task);
                                  }));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      //floating buttom for add task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const AddAnswerScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);

    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
