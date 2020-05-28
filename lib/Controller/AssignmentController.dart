import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssignmentController extends StatefulWidget {
  /*
  The purpose of this method is to share a board. This is done by taking in the
  appropriate arguments to write to the Assignment table in the database -
  with special mention of who the board is being shared with as this will be
  used to load the board upon their logging in.
   */

  Future createAssignment(int OtherUserType, String OtherPersonNo, int ProjectID, int AccessID) async{
    var url =
        'https://witsinnovativeskyline.000webhostapp.com/createAssignment.php';

    var data={
      'UserTypeID' : OtherUserType.toString(),
      'AssignPerson' : OtherPersonNo,
      'ProjectID' : ProjectID.toString(),
      'AccessLevelID' : AccessID.toString(),
    };

    // Starting Web API Call.
    var response = await http.post(url,body: jsonEncode(data));

    // Getting Server response into variable.
    // ignore: non_constant_identifier_names
    var Response = jsonDecode(response.body);
    print(Response);

    return Response;


  }

  @override
  _AssignmentControllerState createState() => _AssignmentControllerState();
}

class _AssignmentControllerState extends State<AssignmentController> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
