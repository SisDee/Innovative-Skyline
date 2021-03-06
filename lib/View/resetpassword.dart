import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:postgrad_tracker/main.dart';
import 'package:http/http.dart' as http;

http.Client resetClient=new http.Client();

class ResetPasswordView extends StatefulWidget {
  bool isHidden=true;
  bool isHiddenConf=true;
  String email = '';
  String password = '';
  bool reset=false;

  String resetUrl="http://10.100.15.38/ResetPassword.php";
  @override
  ResetPasswordViewState createState() => ResetPasswordViewState();
}

class ResetPasswordViewState extends State<ResetPasswordView> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String msg="";
  var emailController = TextEditingController();
  final passwordController = TextEditingController();
  TextEditingController confirmPassCont = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  String ConfirmPass = '';

  void toggleVisibility(){
    setState(() {
      widget.isHidden=!widget.isHidden;
    });
  }





  void toggleVisibilityConf(){
    setState(() {
      widget.isHiddenConf=!widget.isHiddenConf;
    });
  }

  Future<bool> tryReset(http.Client client, {url= "http://10.100.15.38/ResetPassword.php"}) async{
    _formKey.currentState.validate();
//    print("Reset client: "+widget.resetClient.toString());
    msg= await userController.ResetPassword(widget.email, widget.password,client, url: widget.resetUrl);
    if (msg=="Successfully updated password!"){
      msg="";
      Navigator.pop(context);
      return true;
    }else{
      print("Unable to reset password in tryReset.");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {


    final studentEmailField = TextFormField(
      controller: emailController,
      obscureText: false,
      validator: (val) => val.isEmpty ? 'Email is Required' : null,
      onChanged: (val) {
        setState(() => widget.email = val);
      },
      style: style,
      key: Key('StudentEmailInput'),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      obscureText: widget.isHidden,

      validator: (val) =>
      val.length < 6 ? 'Enter a password 6+ chars long' : null,
      onChanged: (val) {
        setState(() => widget.password = val);
      },
      style: style,
      key: Key('PasswordInput'),
      decoration: InputDecoration(
          suffixIcon: IconButton(icon: widget.isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility), onPressed: toggleVisibility, key: Key("viewHidePassword"),),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "New Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final confirmPasswordField = TextFormField(
      controller: confirmPassCont,

      validator: (val) {
        if (val.isEmpty) {
          return 'Confirm password.';
        }
        if (val !=passwordController.text){
          return 'Passwords must match';
        }
        return null;
      },
      obscureText: widget.isHiddenConf,
      onChanged: (val) {
        setState(() => ConfirmPass = val);
      },
      style: style,
      key: Key('confirmPasswordInput'),
      decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: widget.isHiddenConf ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
              key: Key('isHiddenConfButton'),
              onPressed: toggleVisibilityConf),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Confirm Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    // ignore: non_constant_identifier_names
    final ResetButton = kIsWeb? Row(
      children: [
        Expanded(
          child:Text("")
        ),
        Expanded(
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Color(0xff009999),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () async{
                if(_formKey.currentState.validate()){
                  widget.reset =await tryReset(resetClient);
                }
              },
              key: Key('ResetButtonInput'),
              child: Text("Reset",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Expanded(
          child: Text(""),
        )
      ],
    ):
    Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff009999),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async{
          //
          if(_formKey.currentState.validate()){
            widget.reset =await tryReset(resetClient);
          }

        },
        key: Key('ResetButtonInput'),
        child: Text("Reset",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final error= new Text(
      msg,
      style: TextStyle(color: Colors.red, fontSize: 18.0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        backgroundColor: Color(0xff009999),
      ),
        body: Center(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                      height: 15.0,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(""),),
                          Expanded(child: studentEmailField,),
                          Expanded(child: Text(""),)
                        ],
                      ),

                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(""),),
                          Expanded(child: passwordField,),
                          Expanded(child: Text(""),)
                        ],
                      ),
                      SizedBox(
                      height: 15.0,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(""),),
                          Expanded(child: confirmPasswordField,),
                          Expanded(child: Text(""),)
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      error,
                      SizedBox(
                        height: 15.0,
                      ),
                      ResetButton
                    ]
                  )
                 )
              )
            )
          )
        )
    );
  }
}
