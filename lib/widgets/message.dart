import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String text, sender;
  final bool sendBySelf;

  Message({
    Key key,
    @required this.text,
    @required this.sender,
    this.sendBySelf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Column(
          crossAxisAlignment:
              sendBySelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
              child: Text(
                sender,
                style: TextStyle(
                  color: sendBySelf ? Colors.blue[800] : Colors.purple[700],
                  fontSize: 10.0,
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(20.0),
              elevation: 5.0,
              color: sendBySelf ? Colors.blueAccent : Colors.deepPurple,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 4.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
