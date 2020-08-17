import 'package:flutter/material.dart';
import 'package:tusmatik/screens/about_us_screen.dart';
import 'package:tusmatik/screens/after_register_screen.dart';
import 'package:tusmatik/screens/krono_screen.dart';
import 'package:tusmatik/screens/user_agreement.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/user_topic_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String myInitialRoute;
String nickname;
FirebaseUser user; 
final databaseReference = Firestore.instance;

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  user = await FirebaseAuth.instance.currentUser();
  
  if(user!=null){
    final snapshot = await databaseReference.collection("users").document(user.uid).get();
    if(snapshot.exists){
      myInitialRoute = KronoScreen.id;
    } else {
      myInitialRoute = AfterRegisterScreen.id;
    }
    
  } else {
    myInitialRoute = WelcomeScreen.id;
  }
  runApp(MyApp());
}



class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: myInitialRoute,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegisterScreen.id : (context) => RegisterScreen(),
        KronoScreen.id : (context) => KronoScreen(),
        AfterRegisterScreen.id : (context) => AfterRegisterScreen(),
        UserTopicDetail.id : (context) => UserTopicDetail(userUid: user.uid,),
        AboutUsScreen.id : (context) => AboutUsScreen(),
        UserAgreementScreen.id : (context) => UserAgreementScreen(),
      },
    );
  }
}