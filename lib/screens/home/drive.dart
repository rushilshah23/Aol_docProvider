import 'package:Aol_docProvider/Services/constants.dart';
import 'package:Aol_docProvider/Services/database.dart';
import 'package:Aol_docProvider/Widgets/drawer.dart';
import 'package:Aol_docProvider/Widgets/file.dart';
import 'package:Aol_docProvider/Widgets/folders.dart';
import 'package:Aol_docProvider/models/filemodel.dart';
import 'package:Aol_docProvider/models/foldermodel.dart';

import 'package:flutter/material.dart';

class DrivePage extends StatefulWidget {
  final String uid;
  final String pid;
  DrivePage({this.uid, this.pid});
  @override
  _DrivePageState createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  GlobalKey<FormState> _folderNameKey = new GlobalKey<FormState>();
  TextEditingController _folderNameController = new TextEditingController();

  List<FileModel> fileCards = [];
  List<FolderModel> folderCards = [];

  createFolderPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter folder name"),
          content: Form(
            key: _folderNameKey,
            child: TextFormField(
                controller: _folderNameController,
                validator: (String content) {
                  if (content.length != 0) {
                    if (content.contains("#") ||
                        content.contains("[") ||
                        content.contains("]") ||
                        content.contains("*") ||
                        content.contains("/") ||
                        content.contains("?")) {
                      return "enter valid folder name";
                      // "Folder name should not contains invalid characters like #,[,],*,?";
                    } else
                      return null;
                  } else
                    return "Enter a folder name";
                }),
          ),
          actions: [
            FlatButton(
                onPressed: () async {
                  if (_folderNameKey.currentState.validate()) {
                    await DatabaseService(userID: widget.uid).createFolder(
                        // userId: widget.uid,
                        folderName: _folderNameController.text,
                        parentID: widget.pid,
                        type: 'folder');
                    _folderNameController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text("Ok")),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"))
          ],
        );
      },
    );
  }

  void driveOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    topRight: const Radius.circular(30),
                  )),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.create_new_folder),
                    title: Text("Create Folder"),
                    onTap: () {
                      Navigator.pop(context);
                      return createFolderPopUp(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.cloud_upload),
                    title: Text("Upload File"),
                    onTap: () {
                      // TODO upload file
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("DrivePage"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: colorBox,
          )),
      drawer: homeDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          return driveOptions(context);
        },
        backgroundColor: appColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: GridView(
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: [
          FolderCard(),
          FileCard(),
          FolderCard(),
          FileCard(),
          FolderCard(),
          FileCard(),
          FolderCard(),
          FileCard(),
        ],
      ),
    );
  }
}
