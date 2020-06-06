import 'package:flutter_test/flutter_test.dart';
import 'package:postgrad_tracker/Controller/StudentController.dart';
import 'package:postgrad_tracker/Controller/UserController.dart';
import 'package:postgrad_tracker/Model/Student.dart';
import 'package:postgrad_tracker/Model/User.dart';
import 'package:postgrad_tracker/main.dart';

void main() {
  group('Student tests', () {
    test('fetchStudent', () async {
      StudentController studentController=new StudentController();

      expect(await studentController.fetchStudent('1713445@students.wits.ac.za',url:"https://lamp.ms.wits.ac.za/~s1611821/viewStudentProfile.php"), isInstanceOf<Student>());
    });

    test('setStudentUser', () async {
      StudentController studentController=new StudentController();
      await studentController.setStudentUser('1713445@students.wits.ac.za',
          url:"https://lamp.ms.wits.ac.za/~s1611821/viewStudentProfile.php",url2: "https://lamp.ms.wits.ac.za/~s1611821/ReadBoards.php");
      expect(student!=null, true);
    });

    test('studentRegistration', () async {
          User testUser=new User();

          testUser.email='123@students.wits.ac.za';
          testUser.password="testPassword";
          testUser.userTypeID=1;

          Student testStudent=new Student();
          testStudent.email=testUser.email;
          testStudent.studentNo="123";
          testStudent.fName="Test";
          testStudent.lName="Student";
          testStudent.degreeID=1;
          testStudent.registrationDate=DateTime.now();
          testStudent.studentTypeID=1;

          //testStudent.studentTypeID
      StudentController studentController=new StudentController();

      expect(await studentController.studentRegistration(testStudent,testUser,
          url1:'https://lamp.ms.wits.ac.za/~s1611821/register_student.php',
          url2:"https://lamp.ms.wits.ac.za/~s1611821/register_user.php"),
          "Student Register Success");
      //UserController userController=new UserController();
      var j=await userController.userDeRegistration(testUser,url:"https://lamp.ms.wits.ac.za/~s1611821/deregister_user.php");
      print(j);
    });

  });

}