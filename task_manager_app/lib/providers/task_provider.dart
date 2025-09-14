// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/task.dart';

// class TaskNotifier extends StateNotifier<List<Task>> {
//   TaskNotifier() : super([]);

//   void addTask(String title, String keywordId) {
//     final newTask = Task(
//       id: DateTime.now().toString(),
//       title: title,
//       keywordId: keywordId,
//     );
//     state = [...state, newTask];
//   }

//   void editTask(String id, String newTitle, String keywordId) {
//     state = [
//       for (final task in state)
//         if (task.id == id)
//           task.copyWith(title: newTitle, keywordId: keywordId)
//         else
//           task
//     ];
//   }

//   void deleteTask(String id) {
//     state = state.where((task) => task.id != id).toList();
//   }

//   void toggleComplete(String id) {
//     state = [
//       for (final task in state)
//         if (task.id == id)
//           task.copyWith(isCompleted: !task.isCompleted)
//         else
//           task
//     ];
//   }
// }

// final taskProvider =
//     StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    fetchTasks(); // Load tasks from backend initially
  }

  /// Fetch all tasks from backend
  Future<void> fetchTasks() async {
    try {
      final tasks = await ApiService.getTasks();
      state = tasks;
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  /// Add a new task via backend
    Future<void> addTask(String title, String keywordId) async {
      try {
        final newTask = await ApiService.createTask(title, keywordId);
     print("Sending task: title=$title, keywordId=$keywordId");


        state = [...state, newTask];
      } catch (e) {
        print("Error adding task: $e");
      }
    }

  /// Edit a task via backend
  Future<void> editTask(String id, String newTitle, String? keywordId) async {
    try {
      final updatedTask = await ApiService.updateTask(id, newTitle, keywordId);
      state = [
        for (final task in state)
          if (task.id == id) updatedTask else task
      ];
    } catch (e) {
      print("Error editing task: $e");
    }
  }

  /// Delete a task via backend
  Future<void> deleteTask(String id) async {
    try {
      await ApiService.deleteTask(id);
      state = state.where((task) => task.id != id).toList();
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  /// Toggle task completion via backend

  Future<void> toggleComplete(String id) async {
  try {
    final task = state.firstWhere((task) => task.id == id);
    final updatedTask = await ApiService.updateTask(
     task.id,
      task.title,
      task.keywordId,
      isCompleted: !task.isCompleted,
    );
    state = [
      for (final t in state)
        if (t.id == id) updatedTask else t
    ];
  } catch (e) {
    print("Error toggling task: $e");
  }
}

  // Future<void> toggleComplete(String id) async {
  //   try {
  //     final task = state.firstWhere((task) => task.id == id);
  //     final updatedTask = await ApiService.updateTask(
  //       id,
  //       task.title,
  //       task.keywordId,
  //       isCompleted: !task.isCompleted,
  //     );
  //     state = [
  //       for (final t in state)
  //         if (t.id == id) updatedTask else t
  //     ];
  //   } catch (e) {
  //     print("Error toggling task: $e");
  //   }
  // }
}

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
