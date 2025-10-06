import 'package:eisenhower_matrix/data/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskDialog({super.key, this.taskToEdit});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late Priority _selectedPriority;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.taskToEdit?.description ?? '',
    );
    _selectedPriority = widget.taskToEdit?.priority ?? Priority.doFirst;
    _selectedDueDate = widget.taskToEdit?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.taskToEdit == null ? 'Add New Task' : 'Edit Task',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'Enter task title',
                  prefixIcon: Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter task description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              const Text(
                'Priority',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildPrioritySelector(),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => _selectDueDate(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDueDate == null
                              ? 'Set Due Date (Optional)'
                              : 'Due: ${DateFormat('MMM d, y').format(_selectedDueDate!)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedDueDate == null
                                ? Colors.grey[600]
                                : Colors.black87,
                            fontWeight: _selectedDueDate == null
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (_selectedDueDate != null)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedDueDate = null;
                            });
                          },
                          icon: const Icon(Icons.close, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saveTask,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.taskToEdit == null ? 'Add Task' : 'Update',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      children: [
        _buildPriorityOption(
          Priority.doFirst,
          'Do First',
          'Urgent & Important',
          const Color(0xFFEF4444),
          Icons.local_fire_department,
        ),
        const SizedBox(height: 8),
        _buildPriorityOption(
          Priority.schedule,
          'Schedule',
          'Not Urgent & Important',
          const Color(0xFF3B82F6),
          Icons.calendar_month,
        ),
        const SizedBox(height: 8),
        _buildPriorityOption(
          Priority.delegate,
          'Delegate',
          'Urgent & Not Important',
          const Color(0xFFF59E0B),
          Icons.group,
        ),
        const SizedBox(height: 8),
        _buildPriorityOption(
          Priority.eliminate,
          'Eliminate',
          'Not Urgent & Not Important',
          const Color(0xFF10B981),
          Icons.delete_outline,
        ),
      ],
    );
  }

  Widget _buildPriorityOption(
    Priority priority,
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    final isSelected = _selectedPriority == priority;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final task = Task(
      id:
          widget.taskToEdit?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      createdAt: widget.taskToEdit?.createdAt ?? DateTime.now(),
      isCompleted: widget.taskToEdit?.isCompleted ?? false,
      dueDate: _selectedDueDate,
    );

    if (widget.taskToEdit == null) {
      context.read<TaskBloc>().add(AddTask(task));
    } else {
      context.read<TaskBloc>().add(UpdateTask(task));
    }

    Navigator.pop(context);
  }
}
