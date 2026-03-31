import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'add_edit_task.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => provider.setSearch(value),
            ),
          ),

          // FILTER DROPDOWN
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: provider.filterStatus,
              decoration: InputDecoration(
                labelText: "Filter by Status",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: ['All', 'To-Do', 'In Progress', 'Done']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) => provider.setFilter(value!),
            ),
          ),

          SizedBox(height: 10),

          // TASK LIST
          Expanded(
            child: provider.filteredTasks.isEmpty
                ? Center(child: Text("No tasks found"))
                : ListView.builder(
                    itemCount: provider.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = provider.filteredTasks[index];

                      // BLOCKED LOGIC
                      bool isBlocked = false;

                      if (task.blockedBy != null) {
                        final blockedTask =
                            provider.tasks[task.blockedBy!];

                        if (blockedTask.status != "Done") {
                          isBlocked = true;
                        }
                      }
                    },
                  ),
          ),
        ],
      ),

      // ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTask(),
            ),
          );
        },
      ),
    );
  }
}
