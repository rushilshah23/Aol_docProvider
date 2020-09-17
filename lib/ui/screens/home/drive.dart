import 'package:Aol_docProvider/core/models/usermodel.dart';
import 'package:Aol_docProvider/core/services/database.dart';
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
  final DatabaseReference ref;

  // final String folderPath;
  // final String realFolderPath;
  final String folderName;
  DrivePage({
    @required this.uid,
    this.pid,
    this.folderId,
    this.ref,
    // this.folderPath,
    // this.realFolderPath,
    this.folderName,
  });

  @override
  _DrivePageState createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  GlobalKey<FormState> _folderNameKey = new GlobalKey<FormState>();
  TextEditingController _folderNameController = new TextEditingController();
  List<FolderCard> foldersCard = [];
  List<FileCard> filesCard = [];
  String appPath, folderappBar;
  DatabaseReference driveRef;

  final FirebaseDatabase db = FirebaseDatabase.instance;
  var reference;

  void initState() {
    driveRef = widget.ref.reference().child(widget.folderId);
    // driveRef = (widget.ref).reference();

    // driveRef = widget.ref;

    print(driveRef.path);
    // .child(widget.folderId);
    reference = db.reference();
    // databaseReference = databaseReference.child(widget.folderId).reference();
    // setState(() {
    // getFilesList();
    // getFoldersList();
    // });
    // getFoldersList();
    // getFilesList();

    super.initState();
  }

  Future<List<FolderCard>> getFoldersList() async {
    await driveRef.once().then((DataSnapshot snapshot) {
      foldersCard.clear();
      if (snapshot.value != null) {
        try {
          var data = snapshot.value;
          var keys = snapshot.value.keys;
          foldersCard.clear();

          if (keys != 0) {
            for (var key in keys) {
              if ((data[key]['documentType']) == 'documentType.folder') {
                // if (data[key]['parentId'] == widget.folderId) {
                setState(() {
                  FolderCard folderCard = new FolderCard(
                    globalRef: driveRef,
                    userId: data[key]['userId'] ?? '',
                    parentId: data[key]['parentId'] ?? '',
                    folderId: data[key]['folderId'] ?? '',
                    folderName: data[key]['folderName'] ?? '',
                    createdAt: data[key]['createdAt'] ?? '',
                    documentType: data[key]['documentType'] ?? '',
                  );
                  foldersCard.add(folderCard);
                });
              }
            }

            // else {
            //   getFoldersList();
            // }
          }
          // }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });

    return foldersCard;
  }

  Future<List<FileCard>> getFilesList() async {
    // var db = FirebaseDatabase.instance;
    // var ref = db.reference();

    await driveRef.once().then((DataSnapshot snapshot) {
      filesCard.clear();
      if (snapshot.value != null) {
        var data = snapshot.value;
        var keys = snapshot.value.keys;
        filesCard.clear();
        try {
          if (keys != 0) {
            for (var key in keys) {
              if ((data[key]['documentType']) == 'documentType.file') {
                // if (data[key]['parentId'] == widget.folderId) {
                setState(() {
                  FileCard fileCard = new FileCard(
                    globalRef: driveRef,
                    userId: data[key]['userId'] ?? '',
                    parentId: data[key]['parentId'] ?? '',
                    fileId: data[key]['fileId'] ?? '',
                    fileName: data[key]['fileName'] ?? '',
                    createdAt: data[key]['createdAt'] ?? '',
                    documentType: data[key]['documentType'] ?? '',
                    fileDownloadLink: data[key]['fileDownloadLink'] ?? '',
                  );
                  filesCard.add(fileCard);
                });
                // }
              }
            }
          }
        } catch (e) {
          debugPrint(e.toString());
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
          title: Text("Enter folder name"),
          content: Form(
            key: _folderNameKey,
            child: TextFormField(
                autofocus: true,
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
                        documentType: documentType.folder,
                        folderName: _folderNameController.text,
                        parentId: widget.folderId,
                        driveRef: driveRef);
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
                      DatabaseService(userID: widget.uid).chooseFile(
                        documentType: documentType.file,
                        parentId: widget.folderId,
                        driveRef: driveRef,
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<bool> gobackFolder() async {
    setState(() {
      // driveRef.reference().parent().reference();
      driveRef.parent().reference();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context);
    // getFilesList();
    // getFoldersList();

    // DatabaseService(userID: user.uid).getFoldersList(widget.realFolderPath);
    // var _dbRef = FirebaseDatabase.instance.reference().child('users').child(user.uid).child('documentManager').onValue;
    return StreamBuilder<Event>(
        // stream: driveRef.reference().onValue,
        stream: db
            .reference()
            .child('users')
            .child(user.uid)
            .child('documentManager')
            .reference()
            .onValue,
        // stream:
        //     DatabaseService(userID: widget.uid, driveRef: driveRef.reference())
        //         .documentStream,
        builder: (context, snapshot) {
          getFilesList();
          getFoldersList();
          return snapshot.hasData && !snapshot.hasError
              ? Scaffold(
                  appBar: AppBar(
                      // title: Text(widget.folderPath),
                      title: AutoSizeText(
                        widget.folderName,
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
                  body: WillPopScope(
                    onWillPop: gobackFolder,
                    child: foldersCard.length != 0 || filesCard.length != 0
                        ? ListView(children: [
                            // Text(
                            //     "length of lsit = ${foldersCard.length + filesCard.length}"),
                            foldersCard.length != 0 || filesCard.length != 0
                                ?
                                // && (foldersCard.length + filesCard.length) != null
                                GridView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: (foldersCard.length +
                                            filesCard.length) ??
                                        0,
                                    // (foldersCard.length),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder: (_, index) {
                                      // getFoldersList();
                                      // getFilesList();
                                      // if (index >= 0) {
                                      // if (index is int) {

                                      return index < foldersCard.length
                                          // &&  index >= 0
                                          ? foldersCard[index]
                                          : filesCard[
                                              index - foldersCard.length];

                                      // return foldersCard[index];
                                      // }
                                      // else
                                      //   return Center(
                                      //     child: Container(
                                      //       padding:
                                      //           EdgeInsets.fromLTRB(50, 300, 50, 200),
                                      //       child: Text(
                                      //         'No Items left',
                                      //         style: TextStyle(
                                      //             fontSize: 40,
                                      //             fontWeight: FontWeight.bold,
                                      //             color: appColor),
                                      //       ),
                                      //     ),
                                      //   );
                                    })
                                : Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(50, 300, 50, 200),
                                      child: Text(
                                        'No Items',
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: appColor),
                                      ),
                                    ),
                                  )
                          ])
                        : Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(50, 300, 50, 200),
                              child: Text(
                                'No Items',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: appColor),
                              ),
                            ),
                          ),
                  ))
              : Loading();
        });
  }
}
