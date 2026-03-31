import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddEditTask extends StatefulWidget {
  final int? index;
  final Task? task;

  AddEditTask({this.index, this.task});

  @override
  _AddEditTaskState createState() => _AddEditTaskState();
}

class _AddEditTaskState extends State<AddEditTask> {
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();

  String status = 'To-Do';
  DateTime selectedDate = DateTime.now();
  int? blockedBy;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<TaskProvider>(context, listen: false);

    if (widget.task != null) {
      // Edit mode
      title.text = widget.task!.title;
      desc.text = widget.task!.description;
      status = widget.task!.status;
      selectedDate = widget.task!.dueDate;
      blockedBy = widget.task!.blockedBy;
    } else {
      // Draft restore
      title.text = provider.draftTitle;
      desc.text = provider.draftDesc;
      status = provider.draftStatus;
      selectedDate = provider.draftDate;
      blockedBy = provider.draftBlockedBy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? "Add Task" : "Edit Task"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // TITLE
            TextField(
              controller: title,
              onChanged: (_) {
                provider.saveDraft(
                  title: title.text,
                  desc: desc.text,
                  status: status,
                  date: selectedDate,
                  blockedBy: blockedBy,
                );
              },
              decoration: InputDecoration(
                labelText: "Title",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 12),

            // DESCRIPTION
            TextField(
              controller: desc,
              maxLines: 3,
              onChanged: (_) {
                provider.saveDraft(
                  title: title.text,
                  desc: desc.text,
                  status: status,
                  date: selectedDate,
                  blockedBy: blockedBy,
                );
              },
              decoration: InputDecoration(
                labelText: "Description",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 12),

            // STATUS DROPDOWN
            DropdownButtonFormField<String>(
              value: status,
              decoration: InputDecoration(
                labelText: "Status",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: [
                'To-Do',
                'In Progress',
                'Done',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                setState(() => status = value!);

                provider.saveDraft(
                  title: title.text,
                  desc: desc.text,
                  status: status,
                  date: selectedDate,
                  blockedBy: blockedBy,
                );
              },
            ),
            SizedBox(height: 12),

            // DATE PICKER
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    setState(() => selectedDate = picked);

                    provider.saveDraft(
                      title: title.text,
                      desc: desc.text,
                      status: status,
                      date: selectedDate,
                      blockedBy: blockedBy,
                    );
                  }
                },
                child: Text(
                  "Pick Due Date: ${selectedDate.toString().split(' ')[0]}",
                ),
              ),
            ),

            SizedBox(height: 12),

            // BLOCKED BY DROPDOWN
            DropdownButtonFormField<int?>(
              value: blockedBy,
              decoration: InputDecoration(
                labelText: "Blocked By (Optional)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text("None")),
                ...provider.tasks.asMap().entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value.title),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() => blockedBy = value);

                provider.saveDraft(
                  title: title.text,
                  desc: desc.text,
                  status: status,
                  date: selectedDate,
                  blockedBy: blockedBy,
                );
              },
            ),
            SizedBox(height: 20),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.isLoading
                    ? null
                    : () async {
                        if (title.text.isEmpty || desc.text.isEmpty) return;

                        final task = Task(
                          title: title.text,
                          description: desc.text,
                          dueDate: selectedDate,
                          status: status,
                          blockedBy: blockedBy,
                        );

                        if (widget.index == null) {
                          await provider.addTask(task);
                          provider.clearDraft();
                        } else {
                          await provider.updateTask(widget.index!, task);
                        }

                        Navigator.pop(context);
                      },
                child: provider.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
