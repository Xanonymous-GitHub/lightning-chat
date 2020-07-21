import 'package:flutter/material.dart';
import 'package:lightning_chat/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lightning_chat/widgets/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  static final String sName = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  FirebaseUser _firebaseUser;
  String _messageText;
  TextEditingController messageFieldController;

  void _getCurrentUser() async {
    try {
      final currentUser = await _auth.currentUser();
      if (currentUser != null) {
        _firebaseUser = currentUser;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    messageFieldController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    messageFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                SharedPreferences _sharedPreferences =
                    await SharedPreferences.getInstance();
                _sharedPreferences.remove('userEmail');
                _sharedPreferences.remove('userPassword');
                Navigator.pop(context);
              }),
        ],
        title: Text(
          '⚡  Mr.Coding',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'No messages!',
                      style: TextStyle(
                        fontSize: 50.0,
                      ),
                    ),
                  );
                }
                List<Message> messageWidgets = [];
                final messages = snapshot.data.documents;
                messages.sort((a, b) {
                  return a.data['timeStamp'].compareTo(b.data['timeStamp']);
                });
                for (var message in messages) {
                  final senderId = message.data['senderId'];
                  final senderEmail = message.data['senderEmail'];
                  final text = message.data['text'];
                  final messageWidget = Message(
                    sender: senderEmail ?? '',
                    text: text ?? '',
                    sendBySelf: senderId == _firebaseUser.uid,
                  );
                  messageWidgets.add(messageWidget);
                }
                return Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 20.0,
                      ),
                      itemCount: messageWidgets.length,
                      itemBuilder: (context, index) {
                        return messageWidgets[index];
                      }),
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
                      controller: messageFieldController,
                      onChanged: (value) {
                        if (value != null) {
                          _messageText = value.toString().trim();
                        }
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      setState(() {
                        messageFieldController.clear();
                      });
                      if (_messageText != null) {
                        await _firestore.collection('messages').add({
                          'senderId': _firebaseUser.uid ?? '',
                          'senderEmail': _firebaseUser.email ?? '',
                          'text': _messageText ?? '',
                          'timeStamp': Timestamp.fromMillisecondsSinceEpoch(
                                  DateTime.now().millisecondsSinceEpoch) ??
                              '',
                        });
                      }
                      _messageText = null;
                    },
                    child: Material(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(50.0),
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
