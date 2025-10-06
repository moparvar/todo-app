import 'package:eisenhower_matrix/data/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import 'add_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Color color;

  const TaskCard({super.key, required this.task, required this.color});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _showEditDialog(context),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (context) => _deleteTask(context),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: task.isCompleted
                ? Colors.grey[300]!
                : color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _toggleCompletion(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted ? Colors.grey : color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: task.isCompleted
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (task.dueDate != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: _isOverdue(task.dueDate!)
                                    ? Colors.red
                                    : Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('MMM d, y').format(task.dueDate!),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _isOverdue(task.dueDate!)
                                      ? Colors.red
                                      : Colors.grey[600],
                                  fontWeight: _isOverdue(task.dueDate!)
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now()) && !task.isCompleted;
  }

  void _toggleCompletion(BuildContext context) {
    context.read<TaskBloc>().add(ToggleTaskCompletion(task.id));
  }

  void _deleteTask(BuildContext context) {
    context.read<TaskBloc>().add(DeleteTask(task.id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<TaskBloc>(context),
        child: AddTaskDialog(taskToEdit: task),
      ),
    );
  }
}
