import 'dart:io';
import 'package:Aol_docProvider/ui/Widgets/folders.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:Aol_docProvider/ui/widgets/file.dart';

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
  final String userEmail;
  final DatabaseReference globalRef;
  final String folderId;

  DatabaseService({
    @required this.userID,
    @required this.globalRef,
    this.userEmail,
    @required this.folderId,
  });

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  StorageReference _dbStorage = FirebaseStorage.instance.ref();

  List<FileCard> filesCard = [];
  List<FolderCard> foldersCard = [];

  Future updateUserData({String folderName}) async {
    // DatabaseReference _createUserDrive = _db.reference();
    // await _createUserDrive.reference().child('users').child(userID)
    await globalRef.set({
      'folderName': userEmail,
      'userId': userID,
    });
  }

  Future<List<FolderCard>> getFoldersList() async {
    await globalRef.reference().once().then((snapshot) {
      var data = snapshot.value;
      var keys = snapshot.value.keys ?? 0;
      foldersCard.clear();

      for (var key in keys) {
        if ((data[key]['documentType']) == 'documentType.folder') {
          if (data[key]['parentId'] == folderId) {
            FolderCard folderCard = new FolderCard(
              globalRef: globalRef,
              userId: data[key]['userId'],
              parentId: data[key]['parentId'],
              folderId: data[key]['folderId'],
              folderName: data[key]['folderName'],
              createdAt: data[key]['createdAt'],
              documentType: data[key]['documentType'],
            );
            foldersCard.add(folderCard);
          }
        }
      }
    });
    return foldersCard;
  }

  Future<List<FileCard>> getFilesList() async {
    await globalRef.reference().reference().once().then((snapshot) {
      var data = snapshot.value;
      var keys = snapshot.value.keys ?? 0;
      filesCard.clear();

      for (var key in keys) {
        if ((data[key]['documentType']) == 'documentType.file') {
          if (data[key]['parentId'] == folderId) {
            FileCard fileCard = new FileCard(
              userId: data[key]['userId'],
              parentId: data[key]['parentId'],
              fileId: data[key]['fileId'],
              fileName: data[key]['fileName'],
              createdAt: data[key]['createdAt'],
              documentType: data[key]['documentType'],
              fileDownloadLink: data[key]['fileDownloadLink'],
            );
            filesCard.add(fileCard);
          }
        }
      }
    });
    return filesCard;
  }

  Future createFolder({
    String parentId,
    String folderName,
    documentType documentType,
  }) async {
    var newKey = globalRef.push().key;
    // var newKey = globalRef.reference().push().key;

    await globalRef.child(newKey).set({
      'userId': userID,
      'parentId': parentId,
      'folderId': newKey,
      'documentType': documentType.toString(),
      'folderName': folderName,
      'createdAt': Timestamp.now().toDate().toIso8601String(),
    });
  }

  // Future deleteFolder({String folderId}) {}
  Future chooseFile({String parentId, documentType documentType}) async {
    File file = await FilePicker.getFile(type: FileType.custom);

    String fileName = file.path.split('/').last;
    // StorageUploadTask uploadTask =
    //     _dbStorage.child(parentPath).child(fileName).putFile(file);
    // String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    var newKey = globalRef.push().key;
    // var newKey = globalRef.reference().push().key;

    StorageUploadTask uploadTask = _dbStorage
        .child(globalRef.toString())
        .child(newKey)
        .child(fileName)
        .putFile(file);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    await globalRef.child(newKey).set({
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
  }) async {
    await globalRef.child(folderId).update({
      'folderName': newFolderName,
      'modifiedAt': Timestamp.now().toDate().toIso8601String(),
    });
  }

  Future deleteFolder({
    String folderId,
  }) async {
    String ifexist = globalRef.child(folderId).path;
    // globalRef.reference().child(folderId).path;

    await globalRef.child(folderId).remove();
    // await globalRef.reference().child(folderId).remove();

    // String ifexist =
    //     // _dbStorage.child(globalRef.toString()).child(folderId).path;
    //     globalRef.reference().child(folderId).path;

    print("ifexists path = $ifexist");
    // if (ifexist != null) {
    //   await _dbStorage.child(globalRef.toString()).child(folderId).delete();
    // }

    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(folderPath).getParent();
    // var deleteTask = storageReference.child(folderName).delete();
  }

  Future renameFile({String newFileName, String fileId}) async {
    await globalRef.child(fileId).update({
      'fileName': newFileName,
    });
  }

  Future deleteFile({String fileName, String fileId}) async {
    await globalRef.child(fileId).remove();
    await _dbStorage
        .child(globalRef.toString())
        .child(fileId)
        .child(fileName)
        .delete();

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
    return _db
        .reference()
        .child('users')
        .child(userID)
        .child('documentManager')
        .onValue;
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
}
