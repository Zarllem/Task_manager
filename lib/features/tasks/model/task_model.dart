import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String task;
  bool isDone;
  Timestamp when;
  String id;

  TaskModel({
    required this.task,
    required this.isDone,
    required this.when,
    required this.id,
  });

  TaskModel copyWith({String? task, bool? isDone, Timestamp? when, String? id, String? userId}) {
    return TaskModel(
      task: task ?? this.task,
      isDone: isDone ?? this.isDone,
      when: when ?? this.when,
      id: id ?? this.id,
    );
  }

  factory TaskModel.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      task: data['task'] ?? '',
      isDone: data['isDone'] ?? false,
      when: data['when'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'isDone': isDone,
      'when': when,
      'id': id,
    };
  }
}
