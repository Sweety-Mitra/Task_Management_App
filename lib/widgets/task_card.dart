import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isBlocked;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TaskCard({
    required this.task,
    required this.isBlocked,
    required this.onEdit,
    required this.onDelete,
  });

  // Highlight search text
  Widget buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    }

    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              color: Colors.indigo,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.indigo.withOpacity(0.2),
            ),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = context.watch<TaskProvider>().searchText;

    return Opacity(
      opacity: isBlocked ? 0.5 : 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Highlighted Title
            buildHighlightedText(task.title, searchQuery),

            SizedBox(height: 4),

            Text(task.description),

            SizedBox(height: 6),

            Text("Due: ${task.dueDate.toString().split(' ')[0]}"),

            SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status color
                Chip(
                  label: Text(task.status),
                  backgroundColor: task.status == "Done"
                      ? Colors.green[100]
                      : task.status == "In Progress"
                      ? Colors.orange[100]
                      : Colors.red[100],
                ),

                Row(
                  children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
                    IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
