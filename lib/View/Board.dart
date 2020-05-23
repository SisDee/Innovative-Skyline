import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:postgrad_tracker/Controller/ListController.dart';
import 'package:postgrad_tracker/Controller/Project_BoardController.dart';
import 'package:postgrad_tracker/Controller/TaskController.dart';
import 'package:postgrad_tracker/Controller/TaskStatusController.dart';
import 'package:postgrad_tracker/Model/ListCard.dart';
import 'package:postgrad_tracker/Model/Project_Board.dart';
import 'package:postgrad_tracker/Model/Task.dart';
import 'package:postgrad_tracker/Model/TaskStatus.dart';
import 'package:postgrad_tracker/main.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

List<StaggeredTile> stiles = new List<StaggeredTile>();
List<DynamicList> listDynamic = [];
int BoardIdentificationIndex;

// ignore: must_be_immutable

// ignore: must_be_immutable

class Board extends StatefulWidget {
  //final String title;
  // ignore: non_constant_identifier_names
  final Project_Board proj_board;

  final items = List();
  // ignore: non_constant_identifier_names
  Board({Key key, this.proj_board}) : super(key: key);

  // ignore: non_constant_identifier_names

  TaskController taskController = new TaskController();

  // ignore: non_constant_identifier_names

  // ignore: non_constant_identifier_names

  Future populateListDisplay(int ProjectID) async {
    //lists = [];
    int boardIndex;
    int listIndex;
    int testVal;
    void getIndexes() {
      for (int i = 0; i < user.boards.length; i++) {
        if (user.boards[i].ProjectID == ProjectID) {
          boardIndex = i;
          BoardIdentificationIndex = i;
          if (user.boards[i].boardLists != null) {
            for (int j = 0; j < user.boards[i].boardLists.length; j++) {
              if (user.boards[i].boardLists[j] == testVal) {
                testVal = j;
              }
            }
          }
        }
      }
    }

    getIndexes();
    items.clear();

    if (user.boards[boardIndex].boardLists != null) {
      print('Initializing list display! ##################');
      stiles.clear();
      listDynamic.clear();
      for (int i = 0; i < user.boards[boardIndex].boardLists.length; i++) {
        // ListCard lsc=new ListCard();
        //lsc.List_Title="lsc test";
        DynamicList dynamicCreatedList =
            new DynamicList(aList: user.boards[boardIndex].boardLists[i]);
        //await dynamicCreatedList.initializeTaskDisplay();
        listDynamic.add(dynamicCreatedList);
        // user.boards[boardIndex].boardLists[i].listTasks.clear();
        //await taskController.ReadTasks(testVal);
        //items.add(listDynamic[i]);
        print(i);
        print('adding stiles for: StaggeredTile.count(' +
            (2).toString() +
            "," +
            (user.boards[boardIndex].boardLists[i].listTasks.length + 2)
                .toString() +
            ")");
        stiles.add(StaggeredTile.count(
            2, user.boards[boardIndex].boardLists[i].listTasks.length + 1.5));
      }
      //print("STILES"+stiles.length.toString());

    }
  }

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  String boardTitle = "";
  final _EditformKey = GlobalKey<FormState>();
  //int userType=user.userTypeID;

  DateTime _startDate = new DateTime.now();
  DateTime _endDate = new DateTime.now();
  final format = DateFormat("yyyy-MM-dd");
  String startDateinput = "Select date ...";
  String endDateinput = "Select date ...";
  TextStyle datestyle = TextStyle(
      color: Colors.black.withOpacity(0.65), fontFamily: 'Montserrat');
  bool ChangedStart = false;
  bool ChangedEnd = false;
  bool ChangedBoardValue;
  Future<Null> selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(2000),
        lastDate: new DateTime(2030));

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _startDate = picked;
        ChangedStart = true;
      });
    }
    datestyle = TextStyle(color: Colors.black, fontFamily: 'Montserrat');
    startDateinput = DateFormat('yyyy-MM-dd').format(_startDate);
  }

  Future<Null> selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(2000),
        lastDate: new DateTime(2030));

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _endDate = picked;
        ChangedEnd = true;
      });
    }
    datestyle = TextStyle(color: Colors.black, fontFamily: 'Montserrat');
    endDateinput = DateFormat('yyyy-MM-dd').format(_endDate);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController listTitle = new TextEditingController();
  final items = List();
  // ignore: non_constant_identifier_names
  Project_BoardController project_boardController =
      new Project_BoardController();
  String newListTitle = "";

  Future<String> editBoardAlertDialog(BuildContext context) {
    TextEditingController titleController = new TextEditingController();
    descriptionController.text = widget.proj_board.Project_Description;
    if (widget.proj_board.Project_StartDate != null) {
      startDateinput =
          DateFormat('yyyy-MM-dd').format(widget.proj_board.Project_StartDate);
    } else {
      startDateinput = "Select date ...";
    }
    if (widget.proj_board.Project_EndDate != null) {
      endDateinput =
          DateFormat('yyyy-MM-dd').format(widget.proj_board.Project_EndDate);
    } else {
      endDateinput = "Select date ...";
    }
    titleController.text = widget.proj_board.Project_Title;
    String title = "";
    if (widget.proj_board.Project_Title != null) {
      title = widget.proj_board.Project_Title;
    }
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(widget.proj_board.Project_Title),
              content: Form(
                  key: _EditformKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 20),
                            child: Text("Board Title:")),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                //hintText: "* Board Title",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            onChanged: (val) {
                              ChangedBoardValue = true;
                              setState(
                                  () => widget.proj_board.Project_Title = val);
                            },
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 20),
                            child: Text("Description:")),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                //hintText: "Description",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            onChanged: (val) {
                              ChangedBoardValue = true;
                              setState(() =>
                                  widget.proj_board.Project_Description = val);
                            },
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 60,
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              //padding: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(32),
                                shape: BoxShape.rectangle,
                              ),
                              child: MaterialButton(
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.calendar_today,
                                        color: Color(0xff009999),
                                      ),
                                      onPressed: () {},
                                      tooltip: "Select start date",
                                    ),
                                    Text(
                                      startDateinput,
                                      style: datestyle,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  selectStartDate(context);
                                  startDateinput = DateFormat('yyyy-MM-dd')
                                      .format(_startDate);
                                  //startDateinput=_startDate.toString();
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                                left: 10,
                                top: 12,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: 10, left: 3, right: 0),
                                  margin: EdgeInsets.only(left: 10),
                                  color: Colors.white,
                                  child: Text(
                                    'Start Date:',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.65)),
                                  ),
                                )),
                          ],
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 60,
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              //padding: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(32),
                                shape: BoxShape.rectangle,
                              ),
                              child: MaterialButton(
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.calendar_today,
                                        color: Color(0xff009999),
                                      ),
                                      onPressed: () {
                                        setState(() {});
                                      },
                                      tooltip: "Select end date",
                                    ),
                                    Text(
                                      endDateinput,
                                      style: datestyle,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  selectEndDate(context);
                                  endDateinput =
                                      DateFormat('yyyy-MM-dd').format(_endDate);
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                                left: 10,
                                top: 12,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: 10, left: 3, right: 0),
                                  margin: EdgeInsets.only(left: 10),
                                  color: Colors.white,
                                  child: Text(
                                    'End Date: ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.65)),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
              actions: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.bottomLeft,
                        //color: Colors.green,
                        width: MediaQuery.of(context).size.width / 1.75,
                        child: MaterialButton(
                          elevation: 5.0,
                          child: Text(
                            "DELETE",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            int boardIndex;
                            for (int j = 0; j < user.boards.length; j++) {
                              if (user.boards[j].ProjectID ==
                                  widget.proj_board.ProjectID) {
                                boardIndex = j;
                              }
                            }
                            await project_boardController
                                .deleteBoard(widget.proj_board.ProjectID);

                            listDynamic.removeAt(boardIndex);
                            user.boards.removeAt(boardIndex);
                            homePage.initializeDisplay();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => homePage),
                            );
                            setState(() {});
                          },
                        )),
                    Container(
                        alignment: Alignment.bottomRight,
                        //color: Colors.green,
                        child: MaterialButton(
                          elevation: 5.0,
                          child: Text("Ok"),
                          onPressed: () {
                            boardTitle = titleController.text;
                            //print(widget.proj_board.Project_Description);
                            if (_EditformKey.currentState.validate()) {
                              if (ChangedStart == true) {
                                widget.proj_board.Project_StartDate =
                                    _startDate;
                              }
                              if (ChangedEnd == true) {
                                widget.proj_board.Project_EndDate = _endDate;
                              }
                              if (ChangedBoardValue == true ||
                                  ChangedStart == true ||
                                  ChangedEnd == true) {
                                project_boardController
                                    .updateBoard(widget.proj_board);
                              }
                            }
                            Navigator.of(context).pop();
                          },
                        )),
                  ],
                ),
              ],
            );
          });
        });
  }

  Future<String> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("List title: "),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: listTitle,
                validator: (val) => val.isEmpty ? 'Enter a List Title' : null,
                onChanged: (val) {
                  setState(() => newListTitle = val);
                },
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Create List"),
                onPressed: () {
                  listTitle.text = "";
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final plusButton = new Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.all(1),
      child: MaterialButton(
        onPressed: () {
          createAlertDialog(context).then((onValue) {
            if (newListTitle != "") {
              if (_formKey.currentState.validate()) {
                ListCard newList = new ListCard();
                newList.List_Title = listTitle.text;
                newList.ProjectID = widget.proj_board.ProjectID;
                listController.createList(newList);
                //widget.populateListDisplay(widget.proj_board.ProjectID);
                listDynamic.add(new DynamicList(aList: newList));
                setState(() {});
              }
            }
          });
        },
        color:
            //Colors.blueGrey
            Color(0xff009999),
        textColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 40,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      ),
    );

    final arrowImage = Image.asset("assets/downarrow.png");

    final noBoardsView = new Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            alignment: Alignment.center,
            child: Text(
              "Click the + button below to create a list.",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 100, top: 10),
            alignment: Alignment.bottomLeft,
            child: arrowImage,
          ),
        ],
      ),
    );

    final orientation = MediaQuery.of(context).orientation;
    //listTitle.text="Enter list title ...";

    final addListButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff009999),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          //if (_formKey.currentState.validate()) {
          if (_formKey.currentState.validate()) {
            ListCard newList = new ListCard();
            newList.List_Title = listTitle.text;
            newList.ProjectID = widget.proj_board.ProjectID;
            listController.createList(newList);
            //widget.populateListDisplay(widget.proj_board.ProjectID);
            listDynamic.add(new DynamicList(aList: newList));
            setState(() {});
          }
        },
        key: Key('ListInput'),
        child: Text("Add list",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final ListCardItem = new Container(
      //width: MediaQuery.of(context).size.width/2,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            controller: listTitle,
            decoration: InputDecoration(
                fillColor: Colors.white, hintText: "Enter list title..."),
          ),
          SizedBox(
            height: 20,
          ),
          addListButton,
        ]),
      ),
    );
//    items.add(ListCardItem);

    final addListCard = GridTile(
      child: Container(
        margin: new EdgeInsets.all(5.0),
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: listTitle,
                  // textDirection: TextDirection.ltr,
//                  onChanged: (val) {
//                    setState(() => listTitle.text = val);
//                  },
                  validator: (val) => val.isEmpty ? 'Enter list title.' : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white, hintText: "Enter list title..."),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              addListButton,
            ]),
      ),
    );

    Widget dynamicLists = new Flexible(
      flex: 2,
      child: new GridView.builder(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
        //itemBuilder: (_, index) => widget.listDynamic[index],
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new GridTile(child: items[index]),
          );
        },
      ),
    );

    List<Widget> testList = List<Widget>();

    void pop() {
      testList.clear();
      stiles.clear();
      int boardIndex;

      for (int i = 0; i < user.boards.length; i++) {
        if (user.boards[i].ProjectID == widget.proj_board.ProjectID) {
          boardIndex = i;
          BoardIdentificationIndex = i;
        }
      }

      if (user.boards[boardIndex].boardLists != null) {
        print('Initializing list display! ##################');
        stiles.clear();
        for (int i = 0; i < user.boards[boardIndex].boardLists.length; i++) {
          testList.add(listDynamic[i]);
          stiles.add(StaggeredTile.count(
              2, user.boards[0].boardLists[i].listTasks.length + 1.5));
        }
        //print("STILES"+stiles.length.toString());

      }

      //testList.add(addListCard);
      //stiles.add(StaggeredTile.count(2, 2));
      print("testList: " + testList.length.toString());
      print(" stiles: " + stiles.length.toString());
    }

    pop();
    print("STILES: " + stiles.length.toString());

    final staggered = Container(
      margin: new EdgeInsets.all(10.0),
      // child:  SizedBox(
      //height: 505,
      child: SingleChildScrollView(
        child: StaggeredGridView.count(
          primary: false,
          crossAxisCount: 4,
          shrinkWrap: true,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: testList,
          staggeredTiles: stiles,
        ),
      ),
      //)
    );
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  editBoardAlertDialog(context);
                },
              ),
            ),
          )
        ],
        title: Text(widget.proj_board.Project_Title),
        backgroundColor: Color(0xff009999),
      ),
      backgroundColor: Colors.grey,
      body: user.boards[BoardIdentificationIndex].boardLists != null
          ? staggered
          : noBoardsView,
      floatingActionButton: plusButton,
      //bottomSheet: plusButton,
    );
  }
}

class Constants {
  static const String Edit = 'Edit';
  static const String Delete = 'Delete';
  //static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[
    Edit,
    Delete,
    //SignOut
  ];
}

// ignore: must_be_immutable
class DynamicList extends StatefulWidget {
  ListCard aList;

  DynamicList({Key key, @required this.aList}) : super(key: key);

  int boardIndex;
  int listIndex;
  void getIndex() {
    for (int i = 0; i < user.boards.length; i++) {
      if (user.boards[i].ProjectID == aList.ProjectID) {
        boardIndex = i;
        for (int j = 0; j < user.boards[i].boardLists.length; j++) {
          if (user.boards[i].boardLists[j].ListID == aList.ListID) {
            listIndex = j;
          }
        }
      }
    }
  }

  List<Task> thisListTasks = [];

  Future initializeTaskDisplay() async {
    getIndex();

    if (user.boards[boardIndex].boardLists[listIndex].listTasks != null) {
      print('Initializing task display! ##################');
      thisListTasks = [];

      for (int i = 0;
          i < user.boards[boardIndex].boardLists[listIndex].listTasks.length;
          i++) {
        thisListTasks
            .add(user.boards[boardIndex].boardLists[listIndex].listTasks[i]);
      }
    }
  }

  @override
  _DynamicListState createState() => _DynamicListState();
}
/*
  class DynamicList extends StatefulWidget {
  @override
  _DynamicListState createState() => _DynamicListState();
}
class _DynamicListState extends State<DynamicList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
   */

class _DynamicListState extends State<DynamicList> {
  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: (Colors.white));

  final _formKey = GlobalKey<FormState>();
  List<TaskStatus> _taskStatus = taskStatuses;
  List<DropdownMenuItem<TaskStatus>> _dropdownTaskStatusMenuItems;
  TaskStatus _selectedTaskStatus;

  List<DropdownMenuItem<TaskStatus>> buildDropdownTaskStatusMenuItems(
      List types) {
    List<DropdownMenuItem<TaskStatus>> items = List();
    for (TaskStatus type in types) {
      items.add(
        DropdownMenuItem(
          value: type,
          child: Text(
            type.Status,
            style: TextStyle(
                color: Colors.grey, fontFamily: 'Montserrat', fontSize: 20.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return items;
  }

  onChangeTaskStatusDropdownItem(TaskStatus selectedStatus) {
    setState(() {
      _selectedTaskStatus = selectedStatus;
    });
  }

  initializeTaskStatus() {
    _dropdownTaskStatusMenuItems =
        buildDropdownTaskStatusMenuItems(taskStatuses);

    _selectedTaskStatus = taskStatuses[0];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ignore: missing_return
    int getBoardIndex(int boardID) {
      int boardIndex;
      //print("BOARD ID: "+boardID.toString());
      //print("getting board index ... ugh");
      for (int i = 0; i < user.boards.length; i++) {
        //print("looking...............");
        //print("Board ID: "+user.boards[i].ProjectID.toString()+" our ID: "+boardID.toString() );

        if (user.boards[i].ProjectID == boardID) {
          boardIndex = i;
          //print("BOARD INDEX: "+i.toString());
          return i;
        }
      }
    }

    // ignore: missing_return
    int getListIndex(int listID) {
      //print('get list index ...');
      int listIndex;
      int boardIndex;
      for (int j = 0;
          j <
              user.boards[getBoardIndex(widget.aList.ProjectID)].boardLists
                  .length;
          j++) {
        if (user.boards[getBoardIndex(widget.aList.ProjectID)].boardLists[j]
                .ListID ==
            listID) {
          listIndex = j;
          //print("LIST INDEX: "+j.toString());
          return j;
        }
      }
    }

    int getTaskStatusIndex(int statusID) {
      int statusIndex;
      for (int j = 0; j < taskStatuses.length; j++) {
        if (taskStatuses[j].TaskStatusID == statusID) {
          statusIndex = j;
          return j;
        }
      }
    }

    int getTaskIndex(int TaskID) {
      int statusIndex;
      for (int j = 0;
          j <
              user
                  .boards[getBoardIndex(widget.aList.ProjectID)]
                  .boardLists[getListIndex(widget.aList.ListID)]
                  .listTasks
                  .length;
          j++) {
        if (user
                .boards[getBoardIndex(widget.aList.ProjectID)]
                .boardLists[getListIndex(widget.aList.ListID)]
                .listTasks[j]
                .TaskID ==
            TaskID) {
          statusIndex = j;
          return j;
        }
      }
    }

    void choiceAction(String choice) {
      if (choice == Constants.Edit) {
        print('Edit');
      } else if (choice == Constants.Delete) {
        print('Delete');
      }
    }

    final _EditformKey = GlobalKey<FormState>();

    DateTime _dueDate = new DateTime.now();
    bool dueChanged = false;
    final format = DateFormat("yyyy-MM-dd");
    String dueDateinput = "Select date ...";
    TextStyle datestyle = TextStyle(
        color: Colors.black.withOpacity(0.65), fontFamily: 'Montserrat');

    Future<Null> selectDueDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: new DateTime(2000),
          lastDate: new DateTime(2030));

      if (picked != null) {
        setState(() {
          _dueDate = picked;
          dueChanged = true;
        });
      }
      datestyle = TextStyle(color: Colors.black, fontFamily: 'Montserrat');

      dueDateinput = DateFormat('yyyy-MM-dd').format(_dueDate);
      //print(dueDateinput);
    }



    int _selectedTaskID;
    bool ChangedTask = false;
    Future<String> createTaskAlertDialog(BuildContext context, bool create) {
      ChangedTask = false;
      TextEditingController titleController = new TextEditingController();
      TextEditingController descriptionController = new TextEditingController();

      //THIS MUST CHANGE TO DATETIME PICKER!
      TextEditingController dueController = new TextEditingController();
      TextEditingController statusController = new TextEditingController();

      TaskController taskController = new TaskController();
      Task newTask = new Task();

      if (create == false) {
        //i.e. to View/Edit the Task

        newTask = user
            .boards[getBoardIndex(widget.aList.ProjectID)]
            .boardLists[getListIndex(widget.aList.ListID)]
            .listTasks[getTaskIndex(_selectedTaskID)];

        titleController.text = newTask.Task_Title;
        descriptionController.text = newTask.Task_Description;
        _selectedTaskStatus = taskStatuses[getTaskStatusIndex(newTask.Task_StatusID)];

        if (newTask.Task_Due != null) {

          _dueDate = newTask.Task_Due;
          dueDateinput = DateFormat("yyyy-MM-dd").format(_dueDate);
        }
      } else {
        titleController.text = "";
        descriptionController.text = "";
        _selectedTaskStatus = taskStatuses[0];
        _dueDate = DateTime.now();
        dueDateinput = "Select date ...";
      }

      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: create == true
                      ? Text("New Task: ")
                      : Text(user
                          .boards[getBoardIndex(widget.aList.ProjectID)]
                          .boardLists[getListIndex(widget.aList.ListID)]
                          .listTasks[getTaskIndex(_selectedTaskID)]
                          .Task_Title),
                  content: Container(
                    child: Form(
                      key: _EditformKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //Title
                            TextFormField(
                              controller: titleController,
                              style: style.copyWith(color: Colors.black),
                              obscureText: false,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter Task Title' : null,
                              onChanged: (val) {
                                newTask.Task_Title = val;
                                ChangedTask = true;
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "* Title",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            //Description
                            TextFormField(
                              controller: descriptionController,
                              style: style.copyWith(color: Colors.black),
                              maxLines: 5,
                              obscureText: false,
                              //validator: (val) => val.isEmpty ? 'Enter Task Title' : null,
                              onChanged: (val) {
                                newTask.Task_Description = val;
                                ChangedTask = true;
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Description",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            //Status

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                      color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownButton(
                                      value: _selectedTaskStatus,
                                      items: _dropdownTaskStatusMenuItems,
                                      onChanged: (value) {
                                        ChangedTask = true;
                                        setState(() {
                                          _selectedTaskStatus = value;
                                        });
                                      },
                                      isExpanded: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
//                            TextFormField(
//                              controller: statusController,
//                              style: style.copyWith(color: Colors.black),
//                              //maxLines: 5,
//                              obscureText: false,
//                              //validator: (val) => val.isEmpty ? 'Enter Task Title' : null,
//                              onChanged: (val) {
//                                newTask.Task_StatusID = int.parse(val);
//                              },
//                              decoration: InputDecoration(
//                                  contentPadding:
//                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                                  hintText: "Status",
//                                  border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(32.0))),
//                            ),
                            SizedBox(
                              height: 10,
                            ),

                            //Due
                            Stack(
                              children: <Widget>[
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    //padding: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(32),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: MaterialButton(
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.calendar_today,
                                              color: Color(0xff009999),
                                            ),
                                            onPressed: () {},
                                            //tooltip: "Select start date",
                                          ),
                                          Text(
                                            dueDateinput,
                                            style: datestyle,
                                          ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        await selectDueDate(context);
                                        //startDateinput=_startDate.toString();
                                        setState(() {
                                          dueDateinput =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(_dueDate);
                                          ChangedTask = true;
                                        });
                                      },
                                    )),
                                Positioned(
                                    left: 10,
                                    top: 12,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: 10, left: 3, right: 0),
                                      margin: EdgeInsets.only(left: 10),
                                      color: Colors.white,
                                      child: Text(
                                        'Due Date:',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(.65)),
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    create == true
                        ? MaterialButton(
                            elevation: 5.0,
                            child: Text("Create"),
                            onPressed: () async {
                              if(_EditformKey.currentState.validate()){
                                newTask.Task_Title = titleController.text;
                                newTask.Task_Description =
                                    descriptionController.text;
                                newTask.ListID = widget.aList.ListID;
                                newTask.Task_AddedBy = personNo;

                                //NB COME BACK AND CHANGE THIS!
                                newTask.Task_StatusID = _selectedTaskStatus.TaskStatusID;

                                newTask.Task_DateAdded = DateTime.now();

                                //NB COME BACK AND CHANGE!
                                //newTask.Task_Due=DateTime.parse(dueController.text);
                                //newTask.Task_Due = DateTime.parse("2020-02-02");
                                if(dueChanged==true){
                                  newTask.Task_Due=_dueDate;
                                }


                                await taskController.createTask(newTask);
                                //widget.aList.listTasks.add(newTask);
                                user
                                    .boards[getBoardIndex(widget.aList.ProjectID)]
                                    .boardLists[getListIndex(widget.aList.ListID)]
                                    .listTasks
                                    .add(newTask);
                                stiles[getListIndex(widget.aList.ListID)] =
                                new StaggeredTile.count(
                                    2,
                                    stiles[getListIndex(widget.aList.ListID)]
                                        .mainAxisCellCount +
                                        1.5);
                              }

                              Navigator.of(context).pop();
                            },
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  //color: Colors.green,
                                  width:
                                      MediaQuery.of(context).size.width / 1.75,
                                  child: MaterialButton(
                                    elevation: 5.0,
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      print("DELETE TASK");
                                      //await taskController.deleteTask(_selectedTaskID);

                                      //listDynamic.removeAt(boardIndex);
                                      //user.boards[getBoardIndex(widget.aList.ProjectID)].boardLists[getListIndex(widget.aList.ListID)].listTasks.removeWhere((element) => element.TaskID==_selectedTaskID);
//                                homePage.initializeDisplay();
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (BuildContext context) => homePage),
//                                );
                                      setState(() {});
                                    },
                                  )),
                              Container(
                                  alignment: Alignment.bottomRight,
                                  //color: Colors.green,
                                  child: MaterialButton(
                                    elevation: 5.0,
                                    child: Text("Ok"),
                                    onPressed: () {
                                      //boardTitle = titleController.text;
                                      //print(widget.aboard.Project_Description);
                                      if (_EditformKey.currentState
                                          .validate()) {
                                        if (dueChanged == true) {
                                          newTask.Task_Due = _dueDate;
                                        }
                                        newTask.Task_StatusID=_selectedTaskStatus.TaskStatusID;
                                        if (ChangedTask == true) {
                                          taskController.updateTask(newTask);
                                          print("Update task");
                                        }
                                      }
                                      newTask=new Task();
                                      titleController.text = "";
                                      descriptionController.text = "";
                                      _selectedTaskStatus = taskStatuses[0];
                                      _dueDate = DateTime.now();
                                      dueDateinput = "Select date ...";
                                      Navigator.of(context).pop();
                                    },
                                  )),
                            ],
                          ),
                  ],
                );
              },
            );
          });
    }

    final addTaskButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff009999).withOpacity(0.65),

      //Color(0xff009999),
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            initializeTaskStatus();

            await createTaskAlertDialog(context, true);
            //print("PROJECT ID?!?!?: "+widget.aList.ProjectID.toString());
            boardPage = new Board(
              proj_board: user.boards[getBoardIndex(widget.aList.ProjectID)],
            );

            await boardPage.populateListDisplay(widget.aList.ProjectID);

            Navigator.popAndPushNamed(context, '/Board');
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (BuildContext context) => boardPage),
//            );
            setState(() {});
          },
          key: Key('ListInput'),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text("Add Task",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          )),
    );

    final TaskContainer = new Expanded(
        flex: 1,
        child: ListView.builder(
          itemCount: widget.aList.listTasks.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Container(
              margin: EdgeInsets.all(4),
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xff009999).withOpacity(0.1),

                boxShadow: [
                  new BoxShadow(
                    color: Color(0xff009999),
                    //blurRadius: 10.0,
                    //offset: Offset(1.0,0.0)
                  ),
                ],

                //border: Border.all(color: Colors.white, width: 8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          left: BorderSide(
                              color: Color(0xff009999), width: 5.0))),
                  child: ListTile(
                    title: Text(widget.aList.listTasks[index].Task_Title),
//                      trailing: PopupMenuButton<String>(
//                        onSelected: choiceAction,
//                        itemBuilder: (BuildContext context) {
//                          return Constants.choices.map((String choice) {
//                            return PopupMenuItem<String>(
//                              value: choice,
//                              child: Text(choice),
//                            );
//                          }).toList();
//                        },
//                      ),
                    onTap: () {
                      //print("Task press :)");
                      // print(widget.aList.listTasks[index].Task_Title);
                      _selectedTaskID = widget.aList.listTasks[index].TaskID;
                      initializeTaskStatus();
                      createTaskAlertDialog(context, false);
                    },
//                    IconButton(
//                      icon: Icon(Icons.more_vert),
//                      onPressed: () {
//
//                      },
//                    ),
                  ),
                ),
              ),
              //margin: EdgeInsets.all(3),
//              child:
            );
          },
          shrinkWrap: true,
        ));

    final BoardItem = Container(
      width: MediaQuery.of(context).size.width / 2,
      margin: new EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text(widget.aList.List_Title,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    //createAlertDialog(context);
                  },
                ),
              ],
            ),
            TaskContainer,
            addTaskButton,
          ]),
    );

    return BoardItem;
  }
}
