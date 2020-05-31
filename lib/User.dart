import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

import 'main.dart';

String email = '';
String uid = '';
String ost = '';

class UserWidget extends StatefulWidget
{
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget>
{
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool logining = false;

  dispose()
  {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future login(BuildContext context) async {
    email = emailController.text.trim();
    var r = await Requests.post(
      BASE_URL + '/login',
      body: {
        'email': email,
        'password': passwordController.text.trim()
      }
    );
    r.raiseForStatus();
    var res = r.json();
    print(r.content());
    if (res["response"] != "SUCCESS") {
      setState(() {
        logining = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Login failed: ' + (res["data"] != null ? res["data"]: res["response"])),
        backgroundColor: Colors.red,
      ));
    } else {
      uid = res["data"]["uid"];
      ost = res["data"]["ost"];
      setState(() {
        logining = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget;

    if (uid.isNotEmpty) {
      childWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Email: $email"),
          Text("uid: $uid"),
          Text("ost: $ost"),
          RaisedButton(
            child: Text('Logout'),
            color: Colors.redAccent,
            textColor: Colors.white,
            onPressed: () {
              email = '';
              uid = '';
              ost = '';
              setState(() {
                // do nothing
              });
            },
          )
        ],
      );
    } else {
      childWidget = Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Email'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'required';
                }
                if (value.length < 5 || value.indexOf('@') < 1) {
                  return 'invalid email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Password'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'required';
                }
                if (value.length < 6) {
                  return 'invalid password';
                }
                return null;
              },
            ),
            RaisedButton(
              child: Text(logining ? 'Login ...' : 'Login'),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                if (formKey.currentState.validate()) {
                  setState(() {
                    logining = true;
                  });
                  login(context);
                }
              },
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('我'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
        child: childWidget,
      )
    );
  }
}