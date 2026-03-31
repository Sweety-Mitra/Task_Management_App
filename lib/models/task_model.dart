import 'dart:convert';

class Task {
  String title;
  String description;
  DateTime dueDate;
  String status; // To-Do, In Progress, Done
  int? blockedBy;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedBy,
  });

  // Convert Task → Map (for saving)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'blockedBy': blockedBy,
    };
  }

  // Convert Map → Task (for loading)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
      blockedBy: json['blockedBy'],
    );
  }
}