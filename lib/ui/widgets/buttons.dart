import 'package:flutter/material.dart';

Widget formButton(BuildContext context,
    {IconData iconData, String textData, Function onPressed}) {
  return RaisedButton(
    onPressed: onPressed,
    color: Colors.amber[600],
    padding: EdgeInsets.only(
      top: 8,
      bottom: 8,
      left: 48,
      right: 48,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          // Icons.lock_open,
          iconData,
        ),
        SizedBox(
          width: 4,
        ),
        Text(textData),
      ],
    ),
  );
}
