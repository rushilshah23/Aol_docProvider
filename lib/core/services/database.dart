import 'package:Aol_docProvider/core/models/filemodel.dart';
import 'package:Aol_docProvider/core/models/foldermodel.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_database/firebase_database.dart";

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

  Future getFolderPath(String folderId) async {
    String pathlist = '';
    String parentIdBuffer = '';

    while (folderId != userID) {
      var foldRef = await _db
          .reference()
          .child('users')
          .child(userID)
          .child('folders')
          .child(folderId)
          .once()
          .then((snapshot) {
        parentIdBuffer = snapshot.value['parentId'];
        print("parentBuffer = $parentIdBuffer");
        pathlist = pathlist + '/' + (snapshot.value['parentId']).toString();
        folderId = parentIdBuffer;
      });
    }
    print("parentPath = $pathlist");
  }

  List<FolderModel> _getFoldersList(DataSnapshot snapshot) {
    List<FolderModel> foldersList;
    var data = snapshot.value;
    var keys = snapshot.value.keys;

    for (var key in keys) {
      if ((data[key]['parentId'] != null)) {
        FolderModel folderCard = new FolderModel(
          userId: data[key]['userId'] ?? '',
          parentId: data[key]['parentId'] ?? '',
          folderId: data[key]['folderId'] ?? '',
          folderName: data[key]['folderName'] ?? '',
          createdAt: data[key]['created at'] ?? '',
          type: data[key]['type'] ?? '',
        );
        foldersList.add(folderCard);
      }
    }
    return foldersList;
  }

  Stream<List<FolderModel>> get folders {
    return _db
        .reference()
        .child('users')
        .child(userID)
        .child('folders')
        .once()
        .then((snapshot) => _getFoldersList(snapshot))
        .asStream();
  }

  List<FileModel> _getFilesList(DataSnapshot snapshot) {
    List<FileModel> filesList;
    var data = snapshot.value;
    var keys = snapshot.value.keys;

    for (var key in keys) {
      FileModel fileCard = new FileModel(
        userId: data[key]['userId'] ?? '',
        parentId: data[key]['parentId'] ?? '',
        fileId: data[key]['fileId'] ?? '',
        fileName: data[key]['fileName'] ?? '',
        createdAt: data[key]['created at'] ?? '',
        type: data[key]['type'] ?? '',
        fileDownloadLink: data[key]['fileDownloadLink'] ?? '',
      );
      filesList.add(fileCard);
    }
    return filesList;
  }

  Stream<List<FileModel>> get files {
    return _db
        .reference()
        .child('users')
        .child(userID)
        .child('files')
        .once()
        .then((snapshot) => _getFilesList(snapshot))
        .asStream();
  }

  // Stream<List<FolderModel>> getDirectoryFolders({String folderId}) {}

  // Stream<List<FileModel>> getDirectoryFiles({String folderId}) {}

  Future createFolder(
      {String parentId, String folderName, documentType type}) async {
    String parentPath = await getFolderPath(parentId);
    // var newKey = _users.doc(userID).collection('documentManager').doc();
    var newKey = _db
        .reference()
        .child('users')
        .child(userID)
        .child('folders')
        .push()
        .key;
    await _db
        .reference()
        .child('users')
        .child(userID)
        .child('folders')
        .child(newKey)
        .set({
      'userId': userID,
      'parentId': parentId,
      'folderId': newKey,
      'type': type.toString(),
      'folderName': folderName,
      'folderPath': '${parentPath + newKey}',
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
