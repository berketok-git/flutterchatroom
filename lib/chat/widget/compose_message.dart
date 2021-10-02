import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ComposeMessage extends StatefulWidget {
  final database = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final String chatId;

  ComposeMessage({required this.chatId});

  @override
  _ComposeMessageState createState() => _ComposeMessageState();
}

class _ComposeMessageState extends State<ComposeMessage> {
  String _message = '';
  final _messageController = TextEditingController();

  void _sendMessage() async {
    if (_message.trim().isEmpty) return;

    try {
      final uid = widget.auth.currentUser!.uid;
      final userData = await widget.database.collection('users').doc(uid).get();
      await widget.database.collection('chats/${widget.chatId}/messages').add({
        'uid': widget.auth.currentUser!.uid,
        'text': _messageController.text,
        'created_at': Timestamp.now(),
        'username': userData['username'],
      });
      _messageController.clear();
      setState(() => _message = '');
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? '')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 4.0),
            blurRadius: 6.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 20,
          left: 10,
          right: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'message'),
                onChanged: (value) {
                  setState(() => _message = value);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send_rounded),
              onPressed: _message.trim().isEmpty ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
