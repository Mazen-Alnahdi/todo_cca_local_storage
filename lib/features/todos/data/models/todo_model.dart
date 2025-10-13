import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/todo_entity.dart';

@Entity(tableName: 'todos', primaryKeys: ['id'])
class TodoModel extends TodoEntity {
  TodoModel({
    String? id,
    required super.title,
    required super.body,
    super.isCompleted = false,
  }) : super(id: id ?? const Uuid().v4());

  TodoModel copyWith({
    String? id,
    String? title,
    String? body,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body, 'isCompleted': isCompleted};
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      isCompleted: (map['isCompleted'] is int)
          ? (map['isCompleted'] == 1)
          : map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));

  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      isCompleted: entity.isCompleted,
    );
  }

  @override
  List<Object> get props => [id, title, body, isCompleted];
}
