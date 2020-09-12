import 'package:flutter/material.dart';

Widget showdeleteDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.lightBlue,
    title: Text("Delete?"),
    content: Text('Are you sure you want to delete this folder?'),
    actions: [
      FlatButton(
          color: Colors.black,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.orange),
          )),
      FlatButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: TextStyle(color: Colors.orange[300])))
    ],
  );
}

Widget foldercreatedpopup(context) {
  return AlertDialog(
    backgroundColor: Colors.lightGreen,
    title: Text('Success!!'),
    content: Text('Your Folder has been created successfully!'),
    actions: [
      FlatButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.orangeAccent),
          ))
    ],
  );
}

Widget fileuploadedpopup(context) {
  return AlertDialog(
    backgroundColor: Colors.lightGreen,
    title: Text('Success!!'),
    content: Text('File Uploaded successfully!'),
    actions: [
      FlatButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.orangeAccent),
          ))
    ],
  );
}
