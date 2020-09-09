import 'package:Aol_docProvider/core/models/filemodel.dart';
import 'package:Aol_docProvider/core/models/foldermodel.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:flutter/foundation.dart';

class DatabaseService {
  final String userID;

  DatabaseService({this.userID});

  FirebaseDatabase _db = FirebaseDatabase.instance;

  Future updateUserData({String folderName}) async {
    DatabaseReference _createUserDrive = _db.reference();
    await _createUserDrive.reference().child('users').child(userID).set({
      'folderName': folderName,
      'userId': userID,
    });
  }

  // Stream<List<FolderModel>> getDirectoryFolders({String folderId}) {}

  // Stream<List<FileModel>> getDirectoryFiles({String folderId}) {}

  Future createFolder(
      {String parentId, String folderName, documentType type}) async {
    // var newKey = _users.doc(userID).collection('documentManager').doc();
    var newKey = _db.reference().child('folders').push().key;
    await _db.reference().child('folders').child(newKey).set({
      'userId': userID,
      'parentId': parentId,
      'folderId': newKey,
      'type': type.toString(),
      'folderName': folderName,
      'created at': Timestamp.now().toDate().toIso8601String(),
    });
  }

  // Future deleteFolder({String folderId}) {}

  // TODO
  // Stream<QuerySnapshot> get files {
  //   return _db.collection('collectionPath').snapshots();
  // }

  // Stream<QuerySnapshot> get folders {
  //   return _folders.snapshots();
  // }
}
