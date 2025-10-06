import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskRepository {
  final Box<Task> _taskBox;

  TaskRepository(this._taskBox);

  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  List<Task> getTasksByPriority(Priority priority) {
    return _taskBox.values.where((task) => task.priority == priority).toList();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  Future<void> toggleTaskCompletion(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _taskBox.put(id, updatedTask);
    }
  }

  Future<void> clearCompletedTasks() async {
    final completedKeys = _taskBox.values
        .where((task) => task.isCompleted)
        .map((task) => task.id)
        .toList();
    await _taskBox.deleteAll(completedKeys);
  }
}
