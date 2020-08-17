import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tusmatik/components/rounded_button.dart';
import 'package:tusmatik/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tusmatik/screens/krono_screen.dart';
import 'package:tusmatik/strings.dart';
import 'after_register_screen.dart';
import 'package:tusmatik/images.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String passwordR;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        height: 150.0,
                        child: Image.asset(iLoadingIcon),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 45.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Email'),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Şifre'),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      passwordR = value;
                    },
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Şifre Tekrar'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Builder(builder: (context) {
                    return RoundedButton(
                      title: 'Kayıt Ol',
                      colour: Colors.blueAccent,
                      onPressed: () async {
                        setState(() {
                          showSpinner = false;
                        });
                        try {
                          if (passwordR != password) {
                            _displaySnackBar(context,sPasswordsNotMatch);
                          } else {
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                            if (newUser != null) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, AfterRegisterScreen.id, (r) => false);
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        } on PlatformException catch (e) {
                          switch(e.code){
                            case 'ERROR_EMAIL_ALREADY_IN_USE':
                              _displaySnackBar(context,sEmailAlreadyUse);
                              break;
                            case 'ERROR_INVALID_EMAIL':
                              _displaySnackBar(context,sInvalidEmail);
                              break;
                            case 'ERROR_MISSING_EMAIL':
                              _displaySnackBar(context,sMissingEmail);
                              break;
                            case 'ERROR_WEAK_PASSWORD':
                              _displaySnackBar(context,sWeakPassword);
                              break;
                            default:
                              print(e.code);
                              _displaySnackBar(context,sDefaultAuthError);
                          }
                          
                      
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

_displaySnackBar(BuildContext context,String title) {
  Scaffold.of(context).removeCurrentSnackBar();
  final snackBar =
      SnackBar(content: Text(title));
  Scaffold.of(context).showSnackBar(snackBar);
}
