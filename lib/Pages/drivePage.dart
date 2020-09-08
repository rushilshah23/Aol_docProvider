import 'package:Aol_docProvider/services/database.dart';

import 'package:flutter/material.dart';

class DrivePage extends StatefulWidget {
  final String folderName;
  final String userId;
  final String folderId;
  final String parentId;

  DrivePage({this.userId, this.parentId, this.folderId, this.folderName});
  @override
  _DrivePageState createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  GlobalKey<FormState> _folderNameKey = new GlobalKey<FormState>();
  TextEditingController _folderNameController = new TextEditingController();

  // ScrollController _controller = new ScrollController();

  // List<FolderModel> folderCards = [];
  // List<FileModel> fileCards = [];

  void initState() {
    DatabaseService(userID: widget.userId)
        .loadFirebaseData(folderId: widget.folderId);

    super.initState();
  }

  // loadFirebaseData() {

  // globalRefDB.once().then((DataSnapshot snap) {
  //   var keys = snap.value.keys;
  //   var data = snap.value;

  //   folderCards.clear();
  //   fileCards.clear();
  //   print("Stream builder is running..");
  //   for (var key in keys) {
  //     if ((data[key]["folderName"]) != null) {
  //       setState(() {
  //         // globalRefDB = globalRefDB.child(widget.folderKey).reference();
  //         FolderModel folderCard = new FolderModel(
  //           globalRefDB: globalRefDB,
  //           folderKey: key,
  //           folderName: data[key]["folderName"],
  //         );

  //         folderCards.add(folderCard);
  //       });
  //     } else if ((data[key]["fileName"] != null)) {
  //       setState(() {
  //         FileModel fileCard = new FileModel(
  //             globalRefDB: globalRefDB,
  //             fileKey: key,
  //             fileName: data[key]["fileName"],
  //             fileDownloadLink: data[key]["fileDownloadLink"]);

  //         fileCards.add(fileCard);
  //       });
  //     }
  //   }
  // });
  // }

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
                    // TODO CREATE A FOLDER
                    Navigator.pop(context);
                  }
                },
                child: Text("Ok")),
            FlatButton(
                onPressed: () {
                  _folderNameController.clear();
                  Navigator.of(context).pop();
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
                      // Navigator.pop(context);
                      // FileManagement()
                      //     .openFileExplorer(globalrefDB: globalRefDB);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<bool> gobackFolder() async {
    // setState(() {
    //   globalRefDB = globalRefDB.parent().reference();
    //   try {
    //     globalPath.removeLast();
    //   } catch (e) {
    //     print(e.toString());
    //   }
    // });
    Navigator.pop(context, true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService(userID: widget.userId)
        .loadFirebaseData(folderId: widget.folderId);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(
          Icons.add,
          size: 45,
        ),
        onPressed: () {
          driveOptions(context);
        },
        // child: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment.centerLeft,
        //         end: Alignment.centerRight,
        //         colors: [
        //           const Color(0xFFFF8F00),
        //           const Color(0xFFFFc107)
        //         ],
        //       ),
        //     ),
        //     child: Icon(Icons.add)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: Text("${widget.folderName}"),
        // title: Text(
        //     globalPath.join(",").replaceAll(",", "/").substring(20)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [const Color(0xFFFF8F00), const Color(0xFFFFc107)],
            ),
          ),
        ),
        // actions: [
        //   drivePopUp(context),
        // ],
      ),
    );
  }
}
