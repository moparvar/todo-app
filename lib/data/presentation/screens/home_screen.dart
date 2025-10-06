import 'package:eisenhower_matrix/data/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/quadrant_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eisenhower Matrix'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear') {
                _showClearDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, size: 20),
                    SizedBox(width: 12),
                    Text('Clear Completed'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is TaskLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(state),
                  const SizedBox(height: 24),
                  _buildMatrix(context, state),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildHeader(TaskLoaded state) {
    final totalTasks = state.tasks.length;
    final completedTasks = state.tasks.where((t) => t.isCompleted).length;
    final progressPercentage = totalTasks > 0
        ? (completedTasks / totalTasks * 100).toInt()
        : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$completedTasks of $totalTasks tasks',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: totalTasks > 0
                              ? completedTasks / totalTasks
                              : 0,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$progressPercentage%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrix(BuildContext context, TaskLoaded state) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: QuadrantSection(
                title: 'Do First',
                subtitle: 'Urgent & Important',
                priority: Priority.doFirst,
                tasks: state.getTasksByPriority(Priority.doFirst),
                color: const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: QuadrantSection(
                title: 'Schedule',
                subtitle: 'Not Urgent & Important',
                priority: Priority.schedule,
                tasks: state.getTasksByPriority(Priority.schedule),
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: QuadrantSection(
                title: 'Delegate',
                subtitle: 'Urgent & Not Important',
                priority: Priority.delegate,
                tasks: state.getTasksByPriority(Priority.delegate),
                color: const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: QuadrantSection(
                title: 'Eliminate',
                subtitle: 'Not Urgent & Not Important',
                priority: Priority.eliminate,
                tasks: state.getTasksByPriority(Priority.eliminate),
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<TaskBloc>(context),
        child: const AddTaskDialog(),
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Completed Tasks'),
        content: const Text(
          'Are you sure you want to delete all completed tasks?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<TaskBloc>().add(ClearCompletedTasks());
              Navigator.pop(dialogContext);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
