import 'package:Aol_docProvider/core/models/usermodel.dart';

import 'package:Aol_docProvider/core/services/database.dart';
import 'package:Aol_docProvider/core/services/pathnavigator.dart';

import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:Aol_docProvider/ui/widgets/drawer.dart';
import 'package:Aol_docProvider/ui/widgets/file.dart';
import 'package:Aol_docProvider/ui/widgets/folders.dart';
import 'package:Aol_docProvider/ui/widgets/loading.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrivePage extends StatefulWidget {
  final String uid;
  final String pid;
  final String folderId;
  final String folderPath;
  final String realFolderPath;
  final String folderName;
  DrivePage(
      {this.uid,
      this.pid,
      this.folderId,
      this.folderPath,
      this.realFolderPath,
      this.folderName});

  @override
  _DrivePageState createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  GlobalKey<FormState> _folderNameKey = new GlobalKey<FormState>();
  TextEditingController _folderNameController =
      new TextEditingController(text: 'Untitled Folder');
  List<FolderCard> foldersCard = [];
  List<FileCard> filesCard = [];
  final _focusNode = FocusNode();

  void initState() {
    PathNavigator().readblePath.add("${widget.folderName}/");
    getFoldersList(widget.realFolderPath);
    getFilesList(widget.realFolderPath);
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _folderNameController.selection = TextSelection(
            baseOffset: 0, extentOffset: _folderNameController.text.length);
      }
    });
  }

  Future<List<FolderCard>> getFoldersList(String realFolderPath) async {
    var db = FirebaseDatabase.instance;
    var ref = db.reference();
    await ref
        .reference()
        // .child(realFolderPath)
        // .reference()
        .child('users')
        .child(widget.uid)
        .child('documentManager')
        .reference()
        .once()
        .then((snapshot) {
      var data = snapshot.value;
      var keys = snapshot.value.keys ?? 0;
      foldersCard.clear();

      for (var key in keys) {
        if ((data[key]['documentType']) == 'documentType.folder') {
          if (data[key]['parentId'] == widget.folderId) {
            setState(() {
              FolderCard folderCard = new FolderCard(
                userId: data[key]['userId'],
                parentId: data[key]['parentId'],
                folderId: data[key]['folderId'],
                folderName: data[key]['folderName'],
                createdAt: data[key]['createdAt'],
                documentType: data[key]['documentType'],
                folderPath: data[key]['folderPath'],
                realFolderPath: data[key]['realFolderPath'],
              );
              foldersCard.add(folderCard);
            });
          }
        }
      }
    });

    return foldersCard;
  }

  Future<List<FileCard>> getFilesList(String realFolderPath) async {
    var db = FirebaseDatabase.instance;
    var ref = db.reference();
    await ref
        .reference()
        // .child(realFolderPath)

        .child('users')
        .child(widget.uid)
        .child('documentManager')
        .reference()
        .once()
        .then((snapshot) {
      var data = snapshot.value;
      var keys = snapshot.value.keys ?? 0;
      filesCard.clear();

      for (var key in keys) {
        if ((data[key]['documentType']) == 'documentType.file') {
          if (data[key]['parentId'] == widget.folderId) {
            setState(() {
              FileCard fileCard = new FileCard(
                userId: data[key]['userId'],
                parentId: data[key]['parentId'],
                fileId: data[key]['fileId'],
                fileName: data[key]['fileName'],
                createdAt: data[key]['createdAt'],
                documentType: data[key]['documentType'],
                filePath: data[key]['filePath'],
                realFilePath: data[key]['realFilePath'],
                fileDownloadLink: data[key]['fileDownloadLink'],
              );
              filesCard.add(fileCard);
            });
          }
        }
      }
    });
    return filesCard;
  }

  createFolderPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text("Enter folder name"),
          content: Form(
            key: _folderNameKey,
            child: TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[500],
                  labelStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                autofocus: true,
                focusNode: _focusNode,
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
                color: Colors.grey[700],
                onPressed: () async {
                  if (_folderNameKey.currentState.validate()) {
                    await DatabaseService(userID: widget.uid).createFolder(
                      parentPath: widget.folderPath,
                      realParentPath: widget.realFolderPath,
                      folderName: _folderNameController.text,
                      // TODO FIX HERE
                      parentId: widget.folderId,
                      type: documentType.folder,
                      // TODO CALL CREATE FOLDER
                    );
                    _folderNameController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.blue),
                )),
            FlatButton(
                color: Colors.grey[700],
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.blue)))
          ],
        );
      },
    );
  }

  void driveOptions(BuildContext context) {
    showModalBottomSheet(
        barrierColor: Colors.yellow.withOpacity(0.5),
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
                      DatabaseService(userID: widget.uid).chooseFile(
                          parentId: widget.folderId,
                          documentType: documentType.file,
                          parentPath: widget.folderPath,
                          realParentPath: widget.realFolderPath);

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
    var user = Provider.of<UserModel>(context);
    getFoldersList(widget.realFolderPath);
    getFilesList(widget.realFolderPath);

    // DatabaseService(userID: user.uid).getFoldersList(widget.realFolderPath);

    return StreamBuilder<Event>(
        stream: DatabaseService(
                userID: user.uid, realFolderPath: widget.realFolderPath)
            .documentStream,
        builder: (context, snapshot) {
          return snapshot.hasData && !snapshot.hasError
              ? Scaffold(
                  appBar: AppBar(
                      title: AutoSizeText(
                        PathNavigator().readblePath.join(",").toString(),
                        overflow: TextOverflow.visible,
                      ),
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
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  body: ListView(children: [
                    (foldersCard.length + filesCard.length) != 0
                        ? GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: foldersCard.length + filesCard.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (_, index) {
                              return index < foldersCard.length
                                  ? foldersCard[index]
                                  : filesCard[index - foldersCard.length];
                            })
                        : Center(
                            child: Container(
                              child: Text('No Items'),
                            ),
                          )

                    // GridView.builder(
                    //     shrinkWrap: true,
                    //     scrollDirection: Axis.vertical,
                    //     itemCount: filesCard.length,
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2),
                    //     itemBuilder: (_, index) {
                    //       return filesCard[index];
                    //     }),
                  ]))
              : Loading();
        });
  }
}
