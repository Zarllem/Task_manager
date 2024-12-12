import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/tasks/model/task_model.dart';

abstract final class _TaskKey {
  static const String taskKey = "users";
  static const String collectKey = "task";
}

final class TaskRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TaskRepository({required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _firestore = firestore,
        _auth = auth;

  User get _user => _auth.currentUser!;
  String get userID => _user.uid;

  Future<void> addTask(String task, Timestamp when) async {
    log('Добавление');
    await _firestore.collection(_TaskKey.taskKey).doc(userID).collection(_TaskKey.collectKey).add({
      'task': task,
      'when': when,
      'isDone': false,
    });
  }

  Future<void> deleteTask(String taskId) async {
    log('Удаление');
    await _firestore.collection(_TaskKey.taskKey).doc(userID).collection(_TaskKey.collectKey).doc(taskId).delete();
  }

  Stream<List<TaskModel>> getTasks() {
    log('Получить');
    return _firestore.collection(_TaskKey.taskKey).doc(userID).collection(_TaskKey.collectKey).orderBy('when', descending: false).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromJson(doc)).toList();
    });
  }

  Future<void> updateTask(TaskModel task) async {
    log('Обновить');
    await _firestore.collection(_TaskKey.taskKey).doc(userID).collection(_TaskKey.collectKey).doc(task.id).update(task.toJson());
  }
}
