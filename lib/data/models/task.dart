import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  doFirst, // Urgent & Important
  @HiveField(1)
  schedule, // Not Urgent & Important
  @HiveField(2)
  delegate, // Urgent & Not Important
  @HiveField(3)
  eliminate, // Not Urgent & Not Important
}

@HiveType(typeId: 1)
class Task extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final Priority priority;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
    this.isCompleted = false,
    this.dueDate,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    DateTime? createdAt,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    priority,
    createdAt,
    isCompleted,
    dueDate,
  ];
}
