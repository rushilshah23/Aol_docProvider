import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class DatabaseService {
  final String userID;

  DatabaseService({this.userID});
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _files =
      FirebaseFirestore.instance.collection('files');
  final CollectionReference _folders =
      FirebaseFirestore.instance.collection('folders');

  Future updateUserData({String folderName}) async {
    return await _users.doc(userID).set({
      'folderName': folderName,
      'userId': userID,
    });
  }

  Stream<QuerySnapshot> getDirectoryDocuments({String folderId}) {
    return FirebaseFirestore.instance
        .collection('folders')
        .where('userId', isEqualTo: userID)
        .where('parentId', isEqualTo: folderId)
        .orderBy('created at', descending: true)
        .snapshots();
  }

  // TODO
  Stream<QuerySnapshot> get files {
    return _files.snapshots();
  }

  Stream<QuerySnapshot> get folders {
    return _folders.snapshots();
  }

// Folder Functions

  createFolder({String parentID, String folderName, String type}) async {
    // var newKey = _users.doc(userID).collection('documentManager').doc();
    var newKey = _folders.doc();
    _folders.doc(newKey.id).set({
      'userId': userID,
      'parentId': parentID,
      'folderId': newKey.id,
      'type': type,
      'folderName': folderName,
      'created at': Timestamp.now().toDate().toIso8601String(),
    });
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

  Future<void> chooseFile() async {
    // TODO UPLOAD FILE

    File file = await FilePicker.getFile(type: FileType.custom);
    String fileName = file.path.split('/').last;
    print("This is filename  $fileName");
    // uploadFile(userId: userID,file: file,fileName: fileName,folderId: )
  }

  Future<void> uploadFile(
      {String userId, String folderId, String fileName, File file}) {}

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
