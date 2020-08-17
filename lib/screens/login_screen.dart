import 'package:flutter/material.dart';
import 'package:tusmatik/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tusmatik/constants.dart';
import 'package:tusmatik/screens/after_register_screen.dart';
import 'krono_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String nickname;
  FirebaseUser myUser;

  Future<void> getData() async{
    FirebaseUser myUser = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =
                Firestore.instance.collection("users").document(myUser.uid);
            await documentReference.get().then((datasnapshot) {
              if (datasnapshot.exists) {
                print(datasnapshot.data['nickName'].toString());
                nickname = datasnapshot.data['nickName'].toString();
              }
              else{
                nickname = 'noname';
                print("No username");
              }
            });
}
  @override
  Widget build(BuildContext context) {
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
                      child: Image.asset('assets/clock.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Şifre'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Builder(builder: (context) {
                  return RoundedButton(
                    title: 'Giriş Yap',
                    colour: Colors.lightBlueAccent,
                    onPressed: () async {
                      if (email == null || password == null) {
                        _displaySnackBar(
                            context, 'Lütfen boş alanları doldurunuz.');
                      } else {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            await getData();
                            Navigator.of(context).pushNamedAndRemoveUntil(KronoScreen.id, (r) => false);
                            
                          }

                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                            _displaySnackBar(context,
                                'Girilen bilgiler hatalıdır. Lütfen tekrar kontrol ediniz.');
                          });
                          print(e);
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
  }
}

_displaySnackBar(BuildContext context, String message) {
  Scaffold.of(context).removeCurrentSnackBar();
  final snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}
