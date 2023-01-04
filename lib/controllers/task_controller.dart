import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  // get data from DB
  Future<void> getTask() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());

  }
// delete data from DB
  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTask();
  }

  // delete All data from DB
  void deleteAllTask() async {
    await DBHelper.deleteAll();

    getTask();
  }


// update isCompleted data from DB
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }
}
