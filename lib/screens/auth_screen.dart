import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:provider/provider.dart';

enum authFlag { signup, login }

Map<String, String> userCredentials = {
  'email': '',
  'pass': ''
};

class AuthScreen extends StatelessWidget {
  static const routeName = 'AuthScreen';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xff42275a),
                      Color(0xff734b6d),
                    ]),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: size.height,
                width: size.width,
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthCard(),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class AuthCard extends StatefulWidget {

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  authFlag flag = authFlag.login;
  final passController = TextEditingController();
  var isLoading = false;
  AnimationController _animationController;
  Animation<Size> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animation = Tween<Size>(
        begin: Size(double.infinity, 320), end: Size(double.infinity, 400))
        .animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
//    _animationController.addListener(() {setState(() {
//    });});
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
  void toggleLogin() {
    if (flag == authFlag.login) {
      setState(() {
        _animationController.forward();
        flag = authFlag.signup;
      });
    }
    else {
      setState(() {
        _animationController.reverse();
        flag = authFlag.login;
      });
    }
  }

  void showErrDialog(String msg) {
    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        title: Text('Error'), content: Text(msg), actions: [
        FlatButton(onPressed: () {
          Navigator.of(ctx).pop();
        }, child: Text('OK'))
      ],);
    });
  }

  Future<void> login() async
  {
    final valid = _formKey.currentState.validate();
    if (!valid) return;
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      if (flag == authFlag.signup) {
        await Provider.of<Auth>(context, listen: false).signUp(
            userCredentials['email'], userCredentials['pass']);
      }
      else {
        await Provider.of<Auth>(context, listen: false).login(
            userCredentials['email'], userCredentials['pass']);
      }
    }
    on HttpException catch (error) {
      var errorMessage = 'Something went wrong ! Try again later !';
      if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = 'Invalid Password';
      }
      else if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = 'Email id already in use';
      }
      else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = 'Email id not found';
      }
      showErrDialog(errorMessage);
    }
    catch (error) {
      showErrDialog('Something went wrong ! Try again later !');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedBuilder(animation: _animationController, builder: (context,ch) =>
              Container(
                alignment: Alignment.center,
                height: _animation.value.height,
                  padding: EdgeInsets.all(10),
                child: ch,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email ID'),
                    onSaved: (value) {
                      userCredentials['email'] = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your Email ID';
                      }
                      else if (!value.contains("@")) {
                        return 'Enter valid Email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    onSaved: (value) {
                      userCredentials['pass'] = value;
                    },
                    controller: passController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your password';
                      }
                      else if (value.length < 8) {
                        return 'Password should have minimum of 9 characters';
                      }
                      return null;
                    },
                  ),
                  flag == authFlag.signup
                      ? TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration:
                      InputDecoration(labelText: 'Confirm Password'),
                      onSaved: (value) {
                        userCredentials['pass'] = value;
                      },
                      validator: flag == authFlag.signup ? (value) {
                        if (value.isEmpty) {
                          return 'Confirm password filed is empty';
                        }
                        else if (value != passController.text) {
                          return 'Passwords does n\'t match';
                        }
                        else {
                          return null;
                        }
                      } : null
                  )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading ? Center(child: CircularProgressIndicator()) :
                  RaisedButton(
                    onPressed: () {
                      login();
                    },
                    child: flag == authFlag.signup
                        ? Text(
                      'Sign Up', style: TextStyle(color: Colors.white),)
                        : Text('Login', style: TextStyle(color: Colors.white),),
                    elevation: 5,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      toggleLogin();
                    },
                    child: flag == authFlag.signup
                        ? Text('Login')
                        : Text('Sign Up'),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
