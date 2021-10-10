import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper extends GetxController {
  static const _table = "tasks";
  static const _verstion = 1;
  static Database? database;

  static RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;
  static RxList<Map<String, dynamic>> doneTask = <Map<String, dynamic>>[].obs;
  static RxList<Map<String, dynamic>> archiveTask = <Map<String, dynamic>>[].obs;

  static Future createDatabase() async {
    String _path = await getDatabasesPath() + "task.db";

    database = await openDatabase(
      _path,
      version: _verstion,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE $_table (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, isComplete TEXT)").then((value) {
          print("Successfuly Create Database");
        }).catchError((error) {
          print("Error $error");
        });
    
      },
      onOpen: (db) async {

        print("Database path ${db.path}");
        print("Opened Database");
      },
    );
  }

  static Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    Map<String, dynamic> values = {
      "title": title,
      "date": date,
      "time": time,
      "isComplete": "To Do",
    };
    return await database!.insert(_table, values).then((value) {
      print("Insert Completed $value");
    }).catchError((error) {
      print("Error in insert task in function insertToDatabase \nError Details : ${error.toString}");
    });
  }

  static Future<List<Map<String, Object?>>> getDataFromDatabase() async {
    await database!.query(_table).then((value) {
      List<Map<String, Object?>> newList = [];
      value.forEach((element) {
        if (element["isComplete"] == "To Do") {
          newList.add(element);
        }
      });
      tasks.assignAll(newList);
    });
    
    print(tasks);
    return tasks;
  }

  static deletDataFromDatabase() async {
    await database!.delete(_table);
    getDataFromDatabase();
  }

  static Future getDoneTasks() async {
    await database!.query(_table).then((value) {
      List<Map<String, Object?>> newList = [];
      value.forEach((element) {
        if (element["isComplete"] == "Done") {
          newList.add(element);
        }
      });
      doneTask.assignAll(newList);
    });
  }

  static Future deleteSingleTask(int id) async {
    await database!.delete(_table, where: 'id = ?', whereArgs: [id]).then((value) {
      getDataFromDatabase();
    });
  }

  static Future updateTaskToDone(int id) async {

    await database!.rawUpdate(
      '''
    UPDATE $_table
    SET isComplete = ?
    WHERE id = ?
    ''',
      ["Done", id],
    ).then((value) {
      getDataFromDatabase();
    });
  }

  static Future updateTaskToArchive(int id) async {
  
    await database!.rawUpdate(
      '''
    UPDATE $_table
    SET isComplete = ?
    WHERE id = ?
    ''',
      ["Archive", id],
    ).then((value) {
      getDataFromDatabase();
    });
  }
  static Future getArchiveTasks() async {
    await database!.query(_table).then((value) {
      List<Map<String, Object?>> newList = [];
      value.forEach((element) {
        if (element["isComplete"] == "Archive") {
          newList.add(element);
        }
      });
      archiveTask.assignAll(newList);
    });
  }
}
