import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userID;
  DatabaseService({this.userID});
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  // final CollectionReference files =
  //     FirebaseFirestore.instance.collection('files');
  // final CollectionReference folders =
  //     FirebaseFirestore.instance.collection('folders');

  Future updateUserData({String folderName}) async {
    return await users.doc(userID).set({
      'folderName': folderName,
      'userId': userID,
    });
  }

  Stream<QuerySnapshot> get details {
    return users.snapshots();
  }
// Folder Functions

  Future createFolder({String parentID, String folderName, String type}) async {
    var newKey = users.doc(userID).collection('documentManager').doc();
    await newKey.set({
      'userId': userID,
      'parentId': parentID,
      'folderId': newKey.id,
      'type': type,
      'folderName': folderName,
      'created at': Timestamp.now().toDate().toIso8601String(),
    });
    return;
  }

  deleteFolder() {
    // TODO DELETE FOLDER
  }

  renameFolder({String pid, String fol}) {
    // RENAME FOLDER
  }

  moveFolder() {
    // MOVE FOLDER
  }

// File Functions

  uploadFile() {
    // TODO UPLOAD FILE
  }

  deleteFile() {
    // TODO DELETE FILE
  }

  renameFile() {
    // TODO RENAME FILE
  }

  moveFile() {
    // TODO MOVE FILE
  }

  downloadFile() {
    // TODO DOWNLOAD FILE
  }

  viewFile() {
    // TODO VIEW FILE
  }

  void loadFirebaseData({String folderId}) {
    // TODO LOAD FIREBASE DATA
  }
}
