
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String messageText;
  final String username;
  final bool ownMessage;
  final Key key;



  MessageBubble({
    required this.messageText,
    required this.username,
    required this.ownMessage,
    required this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Padding(
            padding: ownMessage
                ? EdgeInsets.only(left: 64)
                : EdgeInsets.only(right: 64),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: ownMessage
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(ownMessage ? 16 : 2),
                  bottomRight: Radius.circular(ownMessage ? 2 : 16),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    messageText,
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline1!.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
