import 'dart:io';
import 'package:Aol_docProvider/core/models/filemodel.dart';
import 'package:Aol_docProvider/core/models/foldermodel.dart';
import 'package:Aol_docProvider/core/services/pathnavigator.dart';

import 'package:Aol_docProvider/ui/shared/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabaseService {
  final String userID;
  // final String userEmail;
  final DatabaseReference driveRef;
  // final String folderId;

  DatabaseService({
    this.userID,
    this.driveRef,
    // this.userEmail,
    // @required this.folderId,
  });

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  StorageReference _dbStorage = FirebaseStorage.instance.ref();

  List<FileModel> filesCard = [];
  List<FolderModel> foldersCard = [];

  Future updateUserData({String folderName}) async {
    DatabaseReference _createUserDrive = _db.reference();
    // await _createUserDrive
    //     .reference()
    //     .child('users')
    //     .child(userID)
    //     .child('documentManager')
    //     .reference()

    globalRef
        .reference()
        .child('users')
        .child(userID)
        .child('documentManager')
        .set({
      'folderName': folderName,
      'userId': userID,
    });

    // shareRef.reference().child('users').child(userID).child('shared');

    // await databaseReference
    //     // .reference()
    //     // .child('users')
    //     // .child(userID)
    //     // .child('documentManager')
    //     // .reference()
    // await globalRef

    // globalRef.reference().set({
    //   'folderName': userEmail,
    //   'userId': userID,
    // });
  }

  Future createFolder({
    String parentId,
    String folderName,
    documentType documentType,
    DatabaseReference driveRef,
  }) async {
    var newKey = driveRef.reference().push().key;
    print(newKey);
    // var newKey = globalRef.reference().push().key;

    await driveRef.child(newKey).set({
      'userId': userID,
      'parentId': parentId,
      'folderId': newKey,
      'documentType': documentType.toString(),
      'folderName': folderName,
      'createdAt': Timestamp.now().toDate().toIso8601String(),
      'globalRef': driveRef.reference().path,
    });
  }

  Future chooseFile(
      {String parentId,
      documentType documentType,
      DatabaseReference driveRef}) async {
    File file = await FilePicker.getFile(type: FileType.custom);

    String fileName = file.path.split('/').last;
    // StorageUploadTask uploadTask =
    //     _dbStorage.child(parentPath).child(fileName).putFile(file);
    // String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    var newKey = driveRef.reference().push().key;
    // var newKey = globalRef.reference().push().key;

    StorageUploadTask uploadTask = _dbStorage
        .child(driveRef.reference().path)
        .child(newKey)
        .child(newKey)
        .putFile(file);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    await driveRef.child(newKey).set({
      'userId': userID,
      'parentId': parentId,
      'fileId': newKey,
      'fileName': fileName,
      'documentType': (documentType.toString()),
      'fileDownloadLink': url,
      'createdAt': Timestamp.now().toDate().toIso8601String(),
    });
  }

  Future renameFolder({
    String newFolderName,
    String folderId,
    DatabaseReference driveRef,
  }) async {
    // await driveRef.reference().child(folderId).update({
    await driveRef.reference().update({
      'folderName': newFolderName,
      'modifiedAt': Timestamp.now().toDate().toIso8601String(),
    });
  }

  Future deleteFolder({
    String folderId,
    DatabaseReference driveRef,
  }) async {
    // String ifexist = globalRef.reference().child(folderId).path;
    // globalRef.reference().child(folderId).path;

    // TODO at the end refer this
    // await driveRef.reference().child(folderId).remove();
    await driveRef.reference().remove();

    var storage =
        // _dbStorage.child(driveRef.reference().path).child(folderId).delete();
        _dbStorage.child(driveRef.reference().path).delete();

    // await globalRef.reference().child(folderId).remove();

    // String ifexist =
    //     // _dbStorage.child(globalRef.toString()).child(folderId).path;
    //     globalRef.reference().child(folderId).path;

    // print("ifexists path = $ifexist");
    // if (ifexist != null) {
    //   await _dbStorage.child(globalRef.toString()).child(folderId).delete();
    // }

    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(driveRef.reference().path);
    // var deleteTask = storageReference.child(folderId).delete();

    // TODO solve in a update

    // var deleteRef = driveRef.reference().child(folderId).reference();

    // while (deleteRef.reference() != null) {
    //   await deleteRef.once().then((DataSnapshot snapshot) async {
    //     try {
    //       var keys = snapshot.value.key;
    //       var data = snapshot.value;

    //       for (var key in keys) {
    //         while (data[key]['documentType'] != 'documentType.file') {
    //           deleteRef = deleteRef.child(data[key]['folderId']).reference();

    //           deleteFolder(
    //             driveRef: deleteRef,
    //           );
    //         }
    //         await _dbStorage
    //             .child(deleteRef.reference().path)
    //             .child(data[key]['fileId'])
    //             .child(data[key]['fileName'])
    //             .delete();
    //       }
    //       await deleteRef.reference().child(folderId).remove();
    //     } catch (e) {
    //       print(e.toString());
    //     }
    //   });
    // }
  }

  Future renameFile(
      {String newFileName, String fileId, DatabaseReference driveRef}) async {
    // await driveRef.reference().child(fileId).update({
    await driveRef.reference().update({
      'fileName': newFileName,
      'modifiedAt': Timestamp.now().toDate().toIso8601String(),
    });
  }

  Future deleteFile(
      {String fileName, String fileId, DatabaseReference driveRef}) async {
    // await driveRef.reference().child(fileId).remove();
    await driveRef.reference().remove();
    print("delete path ${driveRef.path}");

    // await _dbStorage
    //     .child(driveRef.reference().path)
    //     .child(fileId)
    //     .child(fileName)
    //     .delete();

    await _dbStorage.child(driveRef.reference().path).child(fileName).delete();

    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(filePath).getParent();
    // var deleteTask = storageReference.child(fileName).delete();
  }

  Future<void> downloadFile({String fileDownloadLink, String fileName}) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final dir = await getExternalStorageDirectory();
      final downloadId = FlutterDownloader.enqueue(
          url: fileDownloadLink,
          savedDir: dir.path,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true);
    } else {
      print("Please grant the permission");
    }
  }

  Stream<Event> get documentStream {
    // return _db
    //     .reference()
    //     .child('users')
    //     .child(userID)
    //     .child('documentManager')
    //     .onValue;

    return driveRef.onValue;
  }

  // _getFoldersFromSnapshot(DataSnapshot snapshot) {
  //   var keys = snapshot.value.key;
  //   var data = snapshot.value;
  //   for (var key in keys) {
  //     if (data[key]['documentType'] == 'documentType.folder') {
  //       FolderModel folderModelCard = new FolderModel(
  //         userId: data[key]['userId'] ?? '',
  //         parentId: data[key]['parentId'] ?? '',
  //         folderId: data[key]['fileId'] ?? '',
  //         folderName: data[key]['fileName'] ?? '',
  //         folderPath: data[key]['filePath'] ?? '',
  //         createdAt: data[key]['created at'] ?? '',
  //         documentType: data[key]['type'] ?? '',
  //       );
  //       // folderCards.add(folderModelCard);
  //     }
  //   }
  // }

  // _getFilesFromSnapshot(DataSnapshot snapshot) {
  //   var keys = snapshot.value.key;
  //   var data = snapshot.value;
  //   for (var key in keys) {
  //     if (data[key]['documentType'] == 'documentType.folder') {
  //       FileModel fileModelCard = new FileModel(
  //         fileDownloadLink: data[key]['fileDownloadLink'],
  //         realFilePath: data[key]['realFilePath'],
  //         userId: data[key]['userId'] ?? '',
  //         parentId: data[key]['parentId'] ?? '',
  //         fileId: data[key]['fileId'] ?? '',
  //         fileName: data[key]['fileName'] ?? '',
  //         filePath: data[key]['filePath'] ?? '',
  //         createdAt: data[key]['created at'] ?? '',
  //         documentType: data[key]['type'] ?? '',
  //       );
  //       // fileCards.add(fileModelCard);
  //     }
  //   }
  // }

  // Stream<FileModel> get filemodel {
  //   return _db
  //       .reference()
  //       .child('users')
  //       .child(userID)
  //       .child('documentManager')
  //       .once()
  //       .then((snapshot) {
  //     return _getFilesFromSnapshot(snapshot);
  //   }).asStream();
  // }

  // Stream<FolderModel> get foldermodel {
  //   return _db
  //       .reference()
  //       .child('users')
  //       .child(userID)
  //       .child('documentManager')
  //       .once()
  //       .then((snapshot) {
  //     return _getFoldersFromSnapshot(snapshot);
  //   }).asStream();
  // }

  Future<String> getuserIdfromEmailId({String emailId}) async {
    String receiverId;
    try {
      var getuserId = await _db
          .reference()
          .child('users')
          .reference()
          .once()
          .then((snapshot) {
        if (snapshot.value != null) {
          var data = snapshot.value;
          var keys = snapshot.value.keys;
          // if (data != null) {
          for (var key in keys) {
            if (data[key]['documentManager'] != null) {
              print(
                  "Searched email id ${data[key]['documentManager']['folderName']}");
              if (data[key]['documentManager']['folderName'] == emailId) {
                print(
                    "searching userid is ${data[key]['documentManager']['userId']}");
                receiverId = data[key]['documentManager']['userId'];
              }
            } else
              return null;
            // return Scaffold.of(context).showSnackBar(
            //     SnackBar(content: Text("Email id: $emailId doesn't exists")));
          }
        }

        // }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return receiverId ?? null;
  }

  Future<String> getEmailIdfromUserId({String userId}) async {
    String receiverEmailId;
    try {
      var getEmailId = await _db
          .reference()
          .child('users')
          .reference()
          .once()
          .then((snapshot) {
        if (snapshot.value != null) {
          var data = snapshot.value;
          var keys = snapshot.value.keys;
          // if (data != null) {
          for (var key in keys) {
            if (data[key]['documentManager'] != null) {
              // print(
              //     "Searched email id ${data[key]['documentManager']['folderName']}");
              if (data[key]['documentManager']['userId'] == userId) {
                // print(
                //     "searching userid is ${data[key]['documentManager']['userId']}");
                receiverEmailId = data[key]['documentManager']['folderName'];
              }
            } else
              return null;
            // return Scaffold.of(context).showSnackBar(
            //     SnackBar(content: Text("Email id: $emailId doesn't exists")));
          }
        }

        // }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return receiverEmailId ?? null;
  }

  shareWith({
    @required String receiverEmailId,
    FolderModel folderModel,
    FileModel fileModel,
    @required documentType docType,
    // String senderEmailId,
    // String docId,
    // DatabaseReference sharePath,
    // String docName,
    // documentType documentType
  }) async {
    FirebaseDatabase _fbdb = FirebaseDatabase.instance;
    DatabaseReference _db = _fbdb.reference();
    var receiverId = await getuserIdfromEmailId(emailId: receiverEmailId);

    if (receiverId != null) {
      print('before push');
      var shareId = _db
          .reference()
          .child('shared')
          .child('users')
          .child(userID)
          .child('send')
          .child(receiverId)
          // .reference()
          .push()
          .key;
      print('after push');

      if (docType == documentType.folder) {
        await _db
            .reference()
            .child('shared')
            .child('users')
            .child(userID)
            .child('send')
            .child(receiverId)
            .child(shareId)
            .reference()
            // .reference()
            // .child(receiverId)
            .set({
          'receiverEmailId': receiverEmailId,
          'folderSenderId': folderModel.userId ?? null,
          'folderId': folderModel.folderId ?? null,
          'folderParentId': folderModel.parentId ?? null,
          'folderDocumentType': folderModel.documentType ?? null,
          'folderGlobalRef': folderModel.globalRef.toString() ?? null,
          'folderName': folderModel.folderName ?? null,
          'folderCreatedAt': folderModel.createdAt ?? null,
        });
        print('surpassed');

        await _db
            .reference()
            .child('shared')
            .child('users')
            .child(receiverId)
            .child('received')
            .child(userID)
            .child(shareId)
            .reference()
            // // .reference()
            // .child(receiverId)
            .set({
          'receiverEmailId': receiverEmailId,
          'folderSenderId': folderModel.userId ?? null,
          'folderId': folderModel.folderId ?? null,
          'folderParentId': folderModel.parentId ?? null,
          'folderDocumentType': folderModel.documentType ?? null,
          'folderGlobalRef': folderModel.globalRef.toString() ?? null,
          'folderName': folderModel.folderName ?? null,
          'folderCreatedAt': folderModel.createdAt ?? null,
        });
      }

      if (docType == documentType.file) {
        await _db
            .reference()
            .child('shared')
            .child('users')
            .child(userID)
            .child('send')
            .child(receiverId)
            .child(shareId)
            .reference()
            // .reference()
            // .child(receiverId)
            .set({
          'receiverEmailId': receiverEmailId,
          'fileSenderId': fileModel.userId ?? null,
          'fileParentId': fileModel.parentId ?? null,
          'fileId': fileModel.fileId ?? null,
          'fileName': fileModel.fileName ?? null,
          'fileGlobalRef': fileModel.globalRef ?? null,
          'fileDownloadLink': fileModel.fileDownloadLink ?? null,
          'fileCreatedAt': fileModel.createdAt ?? null,
        });

        await _db
            .reference()
            .child('shared')
            .child('users')
            .child(receiverId)
            .child('received')
            .child(userID)
            .child(shareId)
            .reference()
            // // .reference()
            // .child(receiverId)
            .set({
          'receiverEmailId': receiverEmailId,
          'fileSenderId': fileModel.userId ?? null,
          'fileParentId': fileModel.parentId ?? null,
          'fileId': fileModel.fileId ?? null,
          'fileName': fileModel.fileName ?? null,
          'fileGlobalRef': fileModel.globalRef ?? null,
          'fileDownloadLink': fileModel.fileDownloadLink ?? null,
          'fileCreatedAt': fileModel.createdAt ?? null,
        });
      }

      // await shareRef
      //     .reference()
      //     .child('shared')
      //     .child('users')
      //     .child(userID)
      //     .child('send')
      //     .child(receiverId)
      //     // .reference()
      //     // .reference()
      //     // .child(receiverId)
      //     .set({
      //   'receiverEmailId': receiverEmailId,
      //   'folderSenderId': folderModel.userId ?? null,
      //   'folderId': folderModel.folderId ?? null,
      //   'folderParentId': folderModel.parentId ?? null,
      //   'folderDocumentType': folderModel.documentType ?? null,
      //   'folderGlobalRef': folderModel.globalRef.toString() ?? null,
      //   'folderName': folderModel.folderName ?? null,
      //   'folderCreatedAt': folderModel.createdAt ?? null,
      //   'fileSenderId': fileModel.userId ?? null,
      //   'fileParentId': fileModel.parentId ?? null,
      //   'fileId': fileModel.fileId ?? null,
      //   'fileName': fileModel.fileName ?? null,
      //   'fileGlobalRef': fileModel.globalRef ?? null,
      //   'fileDownloadLink': fileModel.fileDownloadLink ?? null,
      //   'fileCreatedAt': fileModel.createdAt ?? null,
      // });

      // await shareRef
      //     .reference()
      //     .child('shared')
      //     .child('users')
      //     .child(receiverId)
      //     .child('received')
      //     .child(userID)
      //     // .reference()
      //     // // .reference()
      //     // .child(receiverId)
      //     .set({
      //   'receiverEmailId': receiverEmailId,
      //   'folderSenderId': folderModel.userId ?? null,
      //   'folderId': folderModel.folderId ?? null,
      //   'folderParentId': folderModel.parentId ?? null,
      //   'folderDocumentType': folderModel.documentType ?? null,
      //   'folderGlobalRef': folderModel.globalRef.toString() ?? null,
      //   'folderName': folderModel.folderName ?? null,
      //   'folderCreatedAt': folderModel.createdAt ?? null,
      //   'fileSenderId': fileModel.userId ?? null,
      //   'fileParentId': fileModel.parentId ?? null,
      //   'fileId': fileModel.fileId ?? null,
      //   'fileName': fileModel.fileName ?? null,
      //   'fileGlobalRef': fileModel.globalRef ?? null,
      //   'fileDownloadLink': fileModel.fileDownloadLink ?? null,
      //   'fileCreatedAt': fileModel.createdAt ?? null,
      // });
      print("finsihed");
    } else
      debugPrint('receievr id not found');
  }
}
