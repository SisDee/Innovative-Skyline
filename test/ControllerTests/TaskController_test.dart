import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:postgrad_tracker/Controller/TaskController.dart';
import 'package:postgrad_tracker/Model/Task.dart';

class MockClient extends Mock implements http.Client {}

void main() {

  bool created=false;

  group('Test Task CRUD', () {


    test('Creating a task', () async {

      TaskController taskController = new TaskController();
      created = true;
      var data;
      Task atask = new Task();

      atask.Task_Title ='New task test';
      atask.ListID=196;
      atask.Task_Description = 'This is a test task.';
      atask.Task_AddedBy = '1713445';
      atask.Task_StatusID = 1;
      atask.Task_DateAdded = DateTime.now();
      atask.Task_Due = DateTime.now();
      expect(await taskController.createTask(atask), "Task created!");
      if(taskController.dateAdded!=null){
        expect(taskController.dateAdded, DateFormat("yyyy-MM-dd").format(atask.Task_DateAdded));
      }
      if(taskController.dateDue!=null){
        expect(taskController.dateDue, DateFormat("yyyy-MM-dd").format(atask.Task_Due));
      }



    });

    test('Reading tasks for a valid list', () async {

      TaskController taskController = new TaskController();
      expect(await taskController.ReadTasks(196),isNotEmpty);

    });

    test('Reading tasks for an invalid list', () async {

      TaskController taskController = new TaskController();
      expect(await taskController.ReadTasks(0),isEmpty);

    });

    test('Updating Task', () async {
      TaskController taskController = new TaskController();
      Task atask = new Task();
      List<Task> testTasks=[];
      testTasks=await taskController.ReadTasks(196);
      atask=testTasks.last;
      await taskController.updateTask(atask);


      expect(await taskController.updateTask(atask),"Task updated successfully");

      if(taskController.dateAdded!=null){
        expect(taskController.dateAdded, DateFormat("yyyy-MM-dd").format(atask.Task_DateAdded));
      }
      if(taskController.dateDue!=null){
        expect(taskController.dateDue, DateFormat("yyyy-MM-dd").format(atask.Task_Due));
      }

    });

    test("Delete Task", () async {
      TaskController taskController = new TaskController();
      Task atask = new Task();
      List<Task> testTasks=[];
      testTasks=await taskController.ReadTasks(196);
      atask=testTasks.last;

      expect(await taskController.deleteTask(atask.TaskID),"Task DELETED!");
    });


  });

}