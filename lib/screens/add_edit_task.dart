import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddEditTask extends StatelessWidget {
  final title = TextEditingController();
  final desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Column(
        children: [
          TextField(controller: title),
          TextField(controller: desc),
          ElevatedButton(
            onPressed: () {
              provider.addTask(Task(
                title: title.text,
                description: desc.text,
                dueDate: DateTime.now(),
                status: "To-Do",
              ));
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}