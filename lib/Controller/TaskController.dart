import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:postgrad_tracker/Model/Task.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class TaskController{

  /*
  The purpose of this method is to take in a Task (for it's associated values)
  and create an instance in the Task table in the database with the values
  of the passed in task.
   */
  String dateAdded;
  String dateDue;

  Future<String> createTask(Task aTask,{String url='http://10.100.15.38/createTask.php'}) async{
    print(url);
    dateAdded=null;
    dateDue=null;
    print("CREATING TASK...");

    if(aTask.Task_Due!=null){
      dateDue=DateFormat("yyyy-MM-dd").format(aTask.Task_Due);
    }
    if(aTask.Task_DateAdded!=null){
      dateAdded=DateFormat("yyyy-MM-dd").format(aTask.Task_DateAdded);
    }
    // SERVER API URL
//    var url =
//          'http://lamp.ms.wits.ac.za/~s1611821/createTask.php';
//        'https://witsinnovativeskyline.000webhostapp.com/createTask.php';
    //print('================= '+title);
    // Store all data with Param Name.
    var data = {
      //'TaskID': aTask.TaskID.toString(),
      'Task_Title': aTask.Task_Title,
      'ListID':aTask.ListID.toString(),
      'Task_AddedBy':aTask.Task_AddedBy,
      'Task_DateAdded':dateAdded,
      'Task_Description':aTask.Task_Description,
      'Task_Due':dateDue,
      'Task_StatusID':aTask.Task_StatusID.toString(),
    };

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));
    //print(response.body);
    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    print(message);
    return message;




  }

  /*
  The purpose of this method is to read in all the instances in the Task table
  with the ListID of that which is passed in. These instances are returned in
  the form of a list of Task objects.
   */
  // ignore: non_constant_identifier_names
  Future<List<Task>> ReadTasks(int ListID,http.Client client,{url='http://10.100.15.38/ReadTasks.php'}) async{
    List<Task> tasks=new List();
      String msg = '';

        // SERVER API URL
//            'https://witsinnovativeskyline.000webhostapp.com/ReadTasks.php';

        var data={
          'ListID' : ListID.toString(),
        };

        // Starting Web API Call.
        var response = await client.post(url, body: data);
//        print("Task response body : "+(response.body==null).toString());
        // Getting Server response into variable.
        // ignore: non_constant_identifier_names

    if(response!=null){
      var Response = jsonDecode(response.body);
//        print(Response);


      if (Response.length == 0) {
        msg = "No Tasks created yet.";
      }
      else {
//          print('mmmmmmmmmmmmmmmmmmmmmm lists!');
        tasks=[];

        //Come back and add other task details

        for (int i = 0; i < Response.length; i++) {
          Task taskReceived = new Task();
          taskReceived.TaskID = int.parse(Response[i]['TaskID']);
          taskReceived.Task_Title = Response[i]['Task_Title'];

          taskReceived.Task_StatusID = int.parse(Response[i]['Task_StatusID']);
          if(Response[i]['Task_Date_Due']!=null){
            taskReceived.Task_Due = DateTime.parse(Response[i]['Task_Date_Due']);
          }

          taskReceived.Task_Description = Response[i]['Task_Description'];
          //taskReceived.Task_DateAdded = DateTime.parse(Response[i]['Task_Date_added']);
          taskReceived.Task_AddedBy = Response[i]['Task_AddedBy'];
          taskReceived.ListID = int.parse(Response[i]['ListID']);

          tasks.add(taskReceived);
//            print("Added: "+tasks.length.toString());
        }

      }
    }

    return tasks;
  }



  /*
  The purpose of this method is to take in a Task (for it's associated values)
  and update the instance in the Task table (the instance with the
  corresponding TaskID to that which was passed in) with the values
  of the passed in task (said values may have been updated by the user via the
  UI).
   */
  Future<String> updateTask(Task aTask, {url ='http://10.100.15.38/updateTask.php'}) async{
   // var url =
        //'http://10.100.15.38/updateTask.php';
//        'https://witsinnovativeskyline.000webhostapp.com/updateTask.php';



    dateAdded=null;
    dateDue=null;
    if(aTask.Task_DateAdded!=null){
      dateAdded=DateFormat("yyyy-MM-dd").format(aTask.Task_DateAdded);
    }
    if(aTask.Task_Due!=null){
      dateDue=DateFormat("yyyy-MM-dd").format(aTask.Task_Due);
    }
    // Store all data with Param Name.
    var data = {
      'TaskID': aTask.TaskID.toString(),
      'Task_Title': aTask.Task_Title,
      'ListID':aTask.ListID.toString(),
      'Task_AddedBy':aTask.Task_AddedBy,
      'Task_Date_added':dateAdded,
      'Task_Description':aTask.Task_Description,
      'Task_Date_Due':dateDue,
      'Task_StatusID':aTask.Task_StatusID.toString(),
    };


    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    return message;
  }

  /*
  The purpose of this method is to take in a Task (for it's associated values)
  and remove the instance in the Task table (the instance with the
  corresponding TaskID to that which was passed in).
   */
  // ignore: non_constant_identifier_names
  Future<String> deleteTask(int TaskID, {url="http://10.100.15.38/deleteTask.php"}) async{

    // SERVER API URL
//    var url =
//    'http://10.100.15.38/deleteTask.php';
////        'https://witsinnovativeskyline.000webhostapp.com/deleteTask.php';

    var data={
      'TaskID' : TaskID.toString(),
    };

    // Starting Web API Call.
    var response = await http.post(url, body: jsonEncode(data));

    // Getting Server response into variable.
    // ignore: non_constant_identifier_names
    var Response = jsonDecode(response.body);
    return Response;
  }
}
