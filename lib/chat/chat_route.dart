import 'package:chatme/chat/widget/chat_messages.dart';
import 'package:chatme/chat/widget/compose_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Chat Room'),
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton(
                itemHeight: 50,
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                items: [
                  DropdownMenuItem(
                    onTap: () {},
                    value: 'logout',
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 16),
                          Text('Logout')
                        ],
                      ),
                    ),
                  )
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                },
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(child: ChatMessages(chatId: 'qxFLYtYri0wY0vTQHuLz')),
            ComposeMessage(chatId: 'qxFLYtYri0wY0vTQHuLz'),
          ],
        ),
      );
}
