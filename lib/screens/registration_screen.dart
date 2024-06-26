import 'package:flutter/material.dart';
import 'package:flutter_chat_app/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';


class RegistrationScreen extends StatefulWidget {

  static String id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  late String email;
  late String password;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase when the screen is first created
    print("Call ininstate");
    initFirebase();
  }

  // Initialize Firebase
  void initFirebase()  async{
    print("calling initFirebase");
    await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'AIzaSyCq7qJPKDIzK8gq8ZUoKI6uyNHyN3P7zVs',
          appId: '1:87105101281:android:a8d9d34a3aa22560b106a0',
          messagingSenderId: '87105101281',
          projectId: 'flash-chat-7c511'
          // storageBucket: 'myapp-b9yt18.appspot.com',
          // These are come form gogle-services.json file
          // look -> https://www.youtube.com/watch?v=_M-GLwuWfoM
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              textAlign: TextAlign.center,
              //style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                //hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              obscureText: true, // texts becomes dots, like password
              textAlign: TextAlign.center,
              //style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                //hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton('Register',Colors.blueAccent,() async{
              // print(email);
              // print(password);

              // Register new User
              try{
                //final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                //FirebaseAuth auth = FirebaseAuth.instance;

                UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password
                );

                Navigator.pushNamed(context, ChatScreen.id);

                // if(newUser != null){
                //   Navigator.pushNamed(context, ChatScreen.id);
                // }
              }catch(e){
                print(e);
              }


            }),
          ],
        ),
      ),
    );
  }
}