import 'package:Aol_docProvider/core/models/filemodel.dart';
import 'package:Aol_docProvider/core/models/foldermodel.dart';
import 'package:Aol_docProvider/core/models/received.dart';
import 'package:Aol_docProvider/core/models/receivedusermodel.dart';
import 'package:Aol_docProvider/core/models/usermodel.dart';
import 'package:Aol_docProvider/core/services/database.dart';
import 'package:Aol_docProvider/core/viewmodels/file.dart';
import 'package:Aol_docProvider/core/viewmodels/folders.dart';
import 'package:Aol_docProvider/core/viewmodels/receivedModelList.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:Aol_docProvider/ui/widgets/loading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SharedPage extends StatefulWidget {
  @override
  _SharedPageState createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  DatabaseReference _shareRef;
  final FirebaseDatabase _fbdb = FirebaseDatabase.instance;
  List<ReceivedModel> receivedModelCards = [];
  List<FolderCard> folderModelList = [];
  List<FileCard> fileModelList = [];
  List<ReceivedModelListTile> receivedModelListTileCards = [];

  UserModel userModelVar;
  void initState() {
    userModelVar = Provider.of<UserModel>(context, listen: false);

    _shareRef = _fbdb.reference();
    //     .child('users')
    //     .child(userModelVar.uid)
    //     .child('received');
    // .reference();

    // getReceivedUsersEmail();

    // getReceivedModelListTileList();
    super.initState();
  }

  Future<List<ReceivedModelListTile>> getReceivedUsersEmail() async {
    // print("shared");
    await _shareRef
        .reference()
        .child('shared')
        .child('users')
        .child(userModelVar.uid)
        .child('received')
        .reference()
        .once()
        .then((snapshot) async {
      // folderModelList.clear();
      // fileModelList.clear();
      if (snapshot.value != null) {
        try {
          var keys = snapshot.value.keys;
          var data = snapshot.value;
          receivedModelListTileCards.clear();
          // folderModelList.clear();
          // fileModelList.clear();
          for (var key in keys) {
            var receivedUserEmailid =
                await DatabaseService().getEmailIdfromUserId(userId: key);
            // await _shareRef
            //     .reference()
            //     .child('shared')
            //     .child('users')
            //     .child(userModelVar.uid)
            //     .child('received')
            //     .child(key)
            //     .once()
            //     .then((snapshot) {
            //   if (snapshot.value != null) {
            //     var keys = snapshot.value.keys;
            //     var data = snapshot.value;
            //     receivedModelListTileCards.clear();
            //     folderModelList.clear();
            //     fileModelList.clear();
            //     for (var key2 in keys) {
            //       if (data[key2]['documentSenderId'] == key) {
            //         if (data[key2]['documentType'] == 'documentType.folder') {
            //           setState(() {
            // FolderModel folderModel = new FolderModel(
            //     userId: data[key2]['folderSenderId'],
            //     parentId: data[key2]['folderParentId'],
            //     folderId: data[key2]['folderId'],
            //     documentType: data[key2]['folderDocumentType'],
            //     globalRef: data[key2]['folderGlobalRef'],
            //     folderName: data[key2]['folderName'],
            //     createdAt: data[key2]['folderCreatedAt']);
            // folderModelList.add(FolderCard(
            //   folderModel: folderModel,
            //   documentSenderId: data[key2]['documentSenderId'],
            // ));
            //           });
            //         } else if (data[key2]['documentType'] ==
            //             'documentType.file') {
            //           setState(() {
            //             FileModel fileModel = new FileModel(
            //                 userId: data[key2]['fileSenderId'],
            //                 parentId: data[key2]['fileParentId'],
            //                 fileId: data[key2]['fileId'],
            //                 documentType: data[key2]['fileDocumentType'],
            //                 globalRef: data[key2]['fileGlobalRef'],
            //                 fileName: data[key2]['fileName'],
            //                 createdAt: data[key2]['fileCreatedAt']);
            //             fileModelList.add(FileCard(fileModel: fileModel));
            //           });
            //         }
            //       }
            //     }
            //   }
            // });

            setState(() {
              // receivedModelListTileCards.clear();
              // print(key);
              ReceivedUserModel receivedModelCard = new ReceivedUserModel(
                receivedUserEmailId: receivedUserEmailid,
                receivedUserUid: key,
                userId: userModelVar.uid,

                // fileModelList: fileModelList,
                // folderModelList: folderModelList,
                // receiverRef: _shareRef
                // .reference()
                // .child('users')
                // .child(userModelVar.uid)
                // .child('received')
                // .reference(),
              );

              receivedModelListTileCards.add(ReceivedModelListTile(
                receivedUserModel: receivedModelCard,
              ));
            });
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
    return receivedModelListTileCards;
  }

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<UserModel>(context);
    // getReceivedUsersEmail();
    return StreamBuilder<Event>(
        stream: _fbdb
            .reference()
            .child('shared')
            .child('users')
            .child(userModelVar.uid)
            .child('received')
            .reference()
            .onValue,
        // _shareRef
        // .reference()
        // .child('users')
        // .child(userModelVar.uid)
        // .child('received')
        // .reference()
        // .onValue,
        builder: (context, snapshot) {
          getReceivedUsersEmail();
          return snapshot.hasData && !snapshot.hasError
              ?

              // getReceivedModelListTileList();
              Scaffold(
                  appBar: AppBar(
                    title: Text('Documents shared with you'),
                    backgroundColor: appColor,
                  ),
                  body: receivedModelListTileCards.length != 0
                      ? Container(
                          child: ListView(
                            children: [
                              receivedModelListTileCards.length != 0
                                  ? ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          receivedModelListTileCards.length ??
                                              0,
                                      itemBuilder: (_, index) {
                                        return receivedModelListTileCards[
                                            index];
                                      })
                                  : Text('No documents')
                            ],
                          ),
                        )
                      : Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(50, 300, 50, 200),
                            child: Text(
                              'Nothing to show',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: appColor),
                            ),
                          ),
                        ))
              : Loading();
        });
  }
}
