import 'package:Aol_docProvider/core/models/filemodel.dart';
import 'package:Aol_docProvider/core/models/foldermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userID;

  DatabaseService({this.userID});

  FirebaseFirestore _db = FirebaseFirestore.instance;
  // final CollectionReference _users =
  //     FirebaseFirestore.instance.collection('users');
  // final CollectionReference _files =
  //     FirebaseFirestore.instance.collection('files');
  // final CollectionReference _folders =
  //     FirebaseFirestore.instance.collection('folders');

  Future updateUserData({String folderName}) async {
    return await _db.collection('users').doc(userID).set({
      'folderName': folderName,
      'userId': userID,
    });
  }

  Stream<List<FolderModel>> getDirectoryFolders({String folderId}) {
    return _db
        .collection('folders')
        .where('userId', isEqualTo: userID)
        .where('parentId', isEqualTo: folderId)
        .orderBy('created at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FolderModel.fromJson(doc.data()))
            .toList());
    // .snapshots().map((snapshot) => snapshot.docs.asMap().)
  }

  Stream<List<FileModel>> getDirectoryFiles({String folderId}) {
    return _db
        .collection('ffiles')
        .where('userId', isEqualTo: userID)
        .where('parentId', isEqualTo: folderId)
        .orderBy('created at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FileModel.fromJson(doc.data()))
            .toList());
  }

  createFolder({String parentID, String folderName, String type}) async {
    // var newKey = _users.doc(userID).collection('documentManager').doc();
    var newKey = _db.collection('folders').doc();
    _db.collection('folders').doc(newKey.id).set({
      'userId': userID,
      'parentId': parentID,
      'folderId': newKey.id,
      'type': type,
      'folderName': folderName,
      'created at': Timestamp.now().toDate().toIso8601String(),
    });
  }
  // TODO
  // Stream<QuerySnapshot> get files {
  //   return _db.collection('collectionPath').snapshots();
  // }

  // Stream<QuerySnapshot> get folders {
  //   return _folders.snapshots();
  // }
}
