import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {

  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance; // Create a instance of FirebaseAuth
  FirebaseFirestore firestore = FirebaseFirestore.instance; // Create a instance of FireStore
  User? loggedInUser;
  String? messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async{
    
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    }catch(e){
      print(e);
    }

  }

  // Get onetime messages form firebase
  // void getMessages() async{
  //
  //   QuerySnapshot messages = await firestore.collection('messages').get();
  //   // Access the documents in querySnapshot.docs
  //   for (QueryDocumentSnapshot message in messages.docs) {
  //     // Access data for each document using doc.data()
  //     print(message.data());
  //   }
  // }

  // Get realtime messages form firebase
  void messagesStrem() async{

    await for (var snapshot in firestore.collection("messages").snapshots()){
      for (var messsage in snapshot.docs){
        print(messsage.data());
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("messages").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }

                  final messages = snapshot.data?.docs;
                  List<Text> messageWidgets = [];
                  for(var message in messages!){
                    final messageData = message.data() as Map<String, dynamic>;
                    final messageText = messageData['text'];
                    final messageSender = messageData['sender'];

                    final messageWidget = Text('$messageText from $messageSender');
                    messageWidgets.add(messageWidget);
                  }
                  return Column(
                    children: messageWidgets,
                  );

                },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                    ),
                    onPressed: () {

                      // Add message to the firestore
                      CollectionReference msg = firestore.collection('messages');
                      msg.add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                      });
                      
                    },
                    child: Text('Send'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}