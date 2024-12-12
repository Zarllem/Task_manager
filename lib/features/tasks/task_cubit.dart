import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager/features/tasks/model/task_model.dart';
import 'package:task_manager/features/tasks/repository/task_repository.dart';
import 'package:task_manager/features/tasks/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final TaskRepository _taskRepository;

  TaskCubit(this._taskRepository) : super(TaskState(list: null, isLoading: false, error: null));

  Future<void> fetchTask({bool withRel = true}) async {
    emit(state.copyWith(isLoading: withRel));
    _taskRepository.getTasks().listen((task) {
      emit(state.copyWith(isLoading: false, list: task.isEmpty ? null : task));
    }, onError: (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    });
  }

  Future<void> createTask(String task, Timestamp when) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _taskRepository.addTask(task, when);
      await fetchTask();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deletTask(TaskModel task) async {
    try {
      await _taskRepository.deleteTask(task.id);
      await fetchTask();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> changeIsDone(TaskModel task) async {
    try {
      await _taskRepository.updateTask(
        task.copyWith(isDone: !task.isDone),
      );
      fetchTask(withRel: false);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
