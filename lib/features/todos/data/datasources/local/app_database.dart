import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../models/todo_model.dart';
import 'DAO/todo_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [TodoModel])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
}
