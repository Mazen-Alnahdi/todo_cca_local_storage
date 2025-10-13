import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final bool isCompleted;

  const TodoEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [id, title, body, isCompleted];
}
