import 'package:Aol_docProvider/core/services/database.dart';
import 'package:Aol_docProvider/core/services/pathnavigator.dart';
import 'package:Aol_docProvider/ui/screens/home/drive.dart';
import 'package:Aol_docProvider/ui/widgets/popUps.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';

class FolderCard extends StatefulWidget {
  final dynamic userId;
  final dynamic parentId;
  final dynamic folderId;
  final dynamic documentType;
  final dynamic realFolderPath;
  final dynamic folderPath;
  final dynamic folderName;
  final dynamic createdAt;

  FolderCard(
      {@required this.userId,
      @required this.parentId,
      @required this.folderId,
      @required this.documentType,
      @required this.realFolderPath,
      @required this.folderPath,
      @required this.folderName,
      @required this.createdAt});
  @override
  _FolderCardState createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  TextEditingController _renameFolderController = new TextEditingController();
  GlobalKey<FormState> _renameFolderKey = new GlobalKey<FormState>();
  final _focusNode = FocusNode();

  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _renameFolderController.selection = TextSelection(
            baseOffset: 0, extentOffset: _renameFolderController.text.length);
      }
    });
  }

  deleteFolderPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Delete Folder?"),
            content: Text('Are you sure you want to delete this folder?'),
            actions: [
              FlatButton(
                  color: Colors.white,
                  onPressed: () async {
                    DatabaseService(userID: widget.userId).deleteFolder(
                        folderId: widget.folderId,
                        folderName: widget.folderName,
                        folderPath: widget.folderPath);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  )),
              FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  renameFolderPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Rename folder",
          ),
          content: Form(
            key: _renameFolderKey,
            child: TextFormField(
                cursorColor: Colors.amber,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                      color: _focusNode.hasFocus ? Colors.black : Colors.amber,
                      fontSize: 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[500],
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                focusNode: _focusNode,
                autofocus: true,
                controller: _renameFolderController,
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
                    return "Enter new filename";
                }),
          ),
          actions: [
            FlatButton(
                color: Colors.white,
                onPressed: () async {
                  if (_renameFolderKey.currentState.validate()) {
                    DatabaseService(userID: widget.userId).renameFolder(
                        folderId: widget.folderId,
                        folderName: widget.folderName,
                        newFolderName: _renameFolderController.text,
                        parentPath: widget.folderPath);
                    _renameFolderController.clear();
                    Navigator.pop(context);
                    // DatabaseService(userID: widget.userId).renameFolder();
                    // Navigator.pop(context);
                  }
                },
                child: Text(
                  "Rename",
                  style: TextStyle(color: Colors.amber),
                )),
            FlatButton(
                color: Colors.white,
                onPressed: () {
                  _renameFolderController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      },
    );
  }

  void folderOptions(BuildContext context) {
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
                    leading: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    title: Text("Delete Folder"),
                    onTap: () async {
                      Navigator.pop(context);
                      deleteFolderPopUp(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.label,
                      color: Colors.black,
                    ),
                    title: Text("Rename Folder"),
                    onTap: () async {
                      Navigator.pop(context);
                      renameFolderPopUp(context);
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
    return Container(
        height: 120,
        width: 120,
        // color: Colors.red,
        child: FittedBox(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  iconSize: 60,
                  // constraints: BoxConstraints.tight(Size.fromRadius(40)),
                  icon: Icon(
                    Icons.folder,
                    size: 70,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DrivePage(
                        pid: widget.parentId,
                        uid: widget.userId,
                        folderId: widget.folderId,
                        folderPath: widget.folderPath,
                        realFolderPath: widget.realFolderPath,
                        folderName: widget.folderName,
                      );
                    }));
                    // folder pressed
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 3),
                  width: 70,
                  padding: EdgeInsets.only(left: 13),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 120,
                          child: AutoSizeText(
                            "${widget.folderName}",
                            maxLines: 2,
                            minFontSize: 28,
                            maxFontSize: 28,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Text(
                        //   "${widget.folderName}",
                        //   overflow: TextOverflow.,
                        //   maxLines: 1,
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //   ),
                        // ),
                        SizedBox(width: 5),
                        IconButton(
                            icon: FaIcon(FontAwesomeIcons.ellipsisV),
                            onPressed: () {
                              folderOptions(context);
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
