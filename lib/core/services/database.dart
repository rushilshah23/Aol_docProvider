import 'dart:io';

import 'package:Aol_docProvider/core/models/filemodel.dart';
import 'package:Aol_docProvider/core/models/foldermodel.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../ui/widgets/popUps.dart';

class DatabaseService {
  final String userID;
  final String userEmail;
  final String realFolderPath;

  DatabaseService({this.userID, this.userEmail, this.realFolderPath});

  FirebaseDatabase _db = FirebaseDatabase.instance;
  StorageReference _dbStorage = FirebaseStorage.instance.ref();

  List<FileModel> fileCards = [];
  List<FolderModel> folderCards = [];

  Future updateUserData({String folderName}) async {
    DatabaseReference _createUserDrive = _db.reference();
    await _createUserDrive.reference().child('users').child(userID).set({
      'folderName': userEmail,
      'userId': userID,
    });
  }

  // Future getFolderPath(String folderId) async {
  //   String pathlist = '';
  //   String parentIdBuffer = '';

  //   while (folderId != userID) {
  //     var foldRef = await _db
  //         .reference()
  //         .child('users')
  //         .child(userID)
  //         .child('documentManager')
  //         .child(folderId)
  //         .once()
  //         .then((snapshot) {
  //       parentIdBuffer = snapshot.value['parentId'];
  //       print("parentBuffer = $parentIdBuffer");
  //       pathlist = pathlist + '/' + (snapshot.value['parentId']).toString();
  //       folderId = parentIdBuffer;
  //     });
  //   }
  //   print("parentPath = $pathlist");
  // }

  getFoldersList(String realFolderPath) {
    List<FolderModel> foldersList = [];
    _db
        .reference()
        .child(realFolderPath)
        .reference()
        // .child('users')
        // .child(userID)
        // .child('documentManager')
        .once()
        .then((snapshot) {
      var data = snapshot.value;
      var keys = snapshot.value.keys;
      foldersList.clear();

      for (var key in keys) {
        if ((data[key]['parentId']) != null) {
          FolderModel folderCard = new FolderModel(
            userId: data[key]['userId'],
            parentId: data[key]['parentId'],
            folderId: data[key]['folderId'],
            folderName: data[key]['folderName'],
            createdAt: data[key]['created at'],
            documentType: data[key]['type'],
            folderPath: data[key]['folderPath'],
            realFolderPath: data[key]['realFolderPath'],

            // userId: data[key]['userId'] ?? '',
            // parentId: data[key]['parentId'] ?? '',
            // folderId: data[key]['folderId'] ?? '',
            // folderName: data[key]['folderName'] ?? '',
            // createdAt: data[key]['created at'] ?? '',
            // documentType: data[key]['type'] ?? '',
            // folderPath: data[key]['folderPath'] ?? '',
            // realFolderPath: data[key]['realFolderPath'] ?? '',
          );
          foldersList.add(folderCard);
        }
      }
    });

    print(foldersList);
    return foldersList;
  }

  // Stream<List<FolderModel>> get folders {
  //   return _db
  //       .reference()
  //       .child('users')
  //       .child(userID)
  //       .child('documentManager')
  //       .once()
  //       .then((snapshot) => _getFoldersList(snapshot))
  //       .asStream();
  // }

  // List<FileModel> _getFilesList(DataSnapshot snapshot) {
  //   List<FileModel> filesList;
  //   var data = snapshot.value;
  //   var keys = snapshot.value.keys;

  //   for (var key in keys) {
  //     FileModel fileCard = new FileModel(
  //       userId: data[key]['userId'] ?? '',
  //       parentId: data[key]['parentId'] ?? '',
  //       fileId: data[key]['fileId'] ?? '',
  //       fileName: data[key]['fileName'] ?? '',
  //       filePath: data[key]['filePath'] ?? '',
  //       createdAt: data[key]['created at'] ?? '',
  //       documentType: data[key]['type'] ?? '',
  //       fileDownloadLink: data[key]['fileDownloadLink'] ?? '',
  //     );
  //     filesList.add(fileCard);
  //   }
  //   return filesList;
  // }

  // Stream<List<FileModel>> get files {
  //   return _db
  //       .reference()
  //       .child('users')
  //       .child(userID)
  //       .child('files')
  //       .once()
  //       .then((snapshot) => _getFilesList(snapshot))
  //       .asStream();
  // }

  // Stream<List<FolderModel>> getDirectoryFolders({String folderId}) {}

  // Stream<List<FileModel>> getDirectoryFiles({String folderId}) {}

  Future createFolder(
      {String parentId,
      String folderName,
      documentType type,
      String parentPath,
      String realParentPath}) async {
    // var newKey = _users.doc(userID).collection('documentManager').doc();
    var newKey = _db
        .reference()
        // .child(realParentPath)
        .child('users')
        .child(userID)
        .child('documentManager')
        .push()
        .key;
    await _db
        .reference()
        // .child(realParentPath)
        .child('users')
        .child(userID)
        .child('documentManager')
        .child(newKey)
        .set({
      'userId': userID,
      'parentId': parentId,
      'folderId': newKey,
      'documentType': type.toString(),
      'folderName': folderName,
      'folderPath': "$parentPath$folderName/",
      // 'realFolderPath': "$realParentPath$newKey/$folderName/",
      'realFolderPath': "$realParentPath$newKey/",

      'createdAt': Timestamp.now().toDate().toIso8601String(),
    }).then((value) => foldercreatedpopup(context));
  }

  // Future deleteFolder({String folderId}) {}
  Future chooseFile(
      {String parentId,
      String parentPath,
      String realParentPath,
      documentType documentType}) async {
    File file = await FilePicker.getFile(type: FileType.custom);

    String fileName = file.path.split('/').last;
    StorageUploadTask uploadTask =
        _dbStorage.child(parentPath).child(fileName).putFile(file);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    var newKey = _db.reference().child(realParentPath).push().key;
    await _db.reference().child(realParentPath).child(newKey).set({
      'userId': userID,
      'parentId': parentId,
      'fileId': newKey,
      'fileName': fileName,
      'filePath': "$parentPath$fileName",
      'realFilePath': '$realParentPath$newKey/$fileName',
      'documentType': (documentType.toString()),
      'fileDownloadLink': url,
      'createdAt': Timestamp.now().toDate().toIso8601String(),
    }).then((value) => fileuploadedpopup(context));
  }

  // Future deleteFolder({String folderId}) async {
  //   await _db
  //       .reference()
  //       .child('users')
  //       .child(userID)
  //       .child('documentManager')
  //       .child(folderId)
  //       .remove();
  //       await _db
  //       .reference()
  //       .child('users')
  //       .child(userID)
  //       .child('documentManager').once().then((snapshot){
  //         var keys = snapshot.value.keys;
  //         var data = snapshot.value;

  //         for(var key in keys){
  //           if (data[key]['parentId']==folderId){
  //             data[key]
  //           }
  //         }
  //       })
  // }

  Future renameFolder({
    String newFolderName,
    String parentPath,
    String realparentPath,
    String folderName,
    String folderId,
  }) async {
    // List<Map<String,dynamic>>torename = [];

    await _db
        .reference()
        .child('users')
        .child(userID)
        .child('documentManager')
        .child(folderId)
        .update({
      'userId': userID,
      'folderName': newFolderName,
      'folderPath':
          "$parentPath".toString().replaceAll(folderName, newFolderName),
      'modifiedAt': Timestamp.now().toDate().toIso8601String(),
    });

    // await _db
    //     .reference()
    //     .child('users')
    //     .child(userID)
    //     .child('documentManager')
    //     .child(folderId)
    //     .once()
    //     .then((snapshot) {
    //   var keys = snapshot.value.keys;
    //   var data = snapshot.value;
    //   for (var key in keys) {
    //     if (data[key]['documentType'] == 'documentType.folder') {
    //       if (data[key]['parentId'] == folderId) {
    //         torename.add({folderIdtoRename:data[key]['folderId']},);

    //         // String newFolderPath = data[key]['folderPath'];
    //         // newFolderPath.replaceAll(folderName, newFolderName);
    //         // data[key]['folderPath'] = newFolderPath;
    //       }
    //     }
    //   }
    // });

    // for(var x=1;x<= torename.length;x++){
    //   _db.reference().child('users').child(userID).child('documentManager').child(torename[x]).update({
    //     'folderPath':
    //   })
    // }
  }

  Future deleteFolder() async {}

  // Document snapshot

  // FileModel from snapshots
  //  _getFilesFromSnapshot(DataSnapshot snapshot) {
  //   var keys = snapshot.value.key;
  //   var data = snapshot.value;
  //   for (var key in keys) {
  //     if (data[key]['documentType'] == 'documentType.folder') {
  //       return FileModel(
  //         userId: data[key]['userId'] ?? '',
  //         parentId: data[key]['parentId'] ?? '',
  //         fileId: data[key]['fileId'] ?? '',
  //         fileName: data[key]['fileName'] ?? '',
  //         filePath: data[key]['filePath'] ?? '',
  //         createdAt: data[key]['created at'] ?? '',
  //         documentType: data[key]['type'] ?? '',
  //         fileDownloadLink: data[key]['fileDownloadLink'] ?? '',
  //       );
  //     }
  //   }
  // }

  Stream<Event> get documentStream {
    return _db
        .reference()
        // .child(realFolderPath)
        // .reference()
        .child('users')
        .child(userID)
        .child('documentManager')
        .reference()
        .onValue;
  }

  _getFoldersFromSnapshot(DataSnapshot snapshot) {
    var keys = snapshot.value.key;
    var data = snapshot.value;
    for (var key in keys) {
      if (data[key]['documentType'] == 'documentType.folder') {
        FolderModel folderModelCard = new FolderModel(
          userId: data[key]['userId'] ?? '',
          parentId: data[key]['parentId'] ?? '',
          folderId: data[key]['fileId'] ?? '',
          folderName: data[key]['fileName'] ?? '',
          folderPath: data[key]['filePath'] ?? '',
          createdAt: data[key]['created at'] ?? '',
          documentType: data[key]['type'] ?? '',
        );
        folderCards.add(folderModelCard);
      }
    }
  }

  _getFilesFromSnapshot(DataSnapshot snapshot) {
    var keys = snapshot.value.key;
    var data = snapshot.value;
    for (var key in keys) {
      if (data[key]['documentType'] == 'documentType.folder') {
        FileModel fileModelCard = new FileModel(
          fileDownloadLink: data[key]['fileDownloadLink'],
          realFilePath: data[key]['realFilePath'],
          userId: data[key]['userId'] ?? '',
          parentId: data[key]['parentId'] ?? '',
          fileId: data[key]['fileId'] ?? '',
          fileName: data[key]['fileName'] ?? '',
          filePath: data[key]['filePath'] ?? '',
          createdAt: data[key]['created at'] ?? '',
          documentType: data[key]['type'] ?? '',
        );
        fileCards.add(fileModelCard);
      }
    }
  }

  Stream<FileModel> get filemodel {
    return _db
        .reference()
        .child('users')
        .child(userID)
        .child('documentManager')
        .once()
        .then((snapshot) {
      return _getFilesFromSnapshot(snapshot);
    }).asStream();
  }

  Stream<FolderModel> get foldermodel {
    return _db
        .reference()
        .child('users')
        .child(userID)
        .child('documentManager')
        .once()
        .then((snapshot) {
      return _getFoldersFromSnapshot(snapshot);
    }).asStream();
  }

  // Stream<List<dynamic>>get documents{
  //   List<FolderModel> folderModelCards = [];
  //   List<FileModel> fileModelCards = [];
  //   return _db.reference().child('users').child(userID).child('documentManager').once().then((snapshot){
  //     var keys =snapshot.value.keys;
  //     var data = snapshot.value;
  //     for(var key in keys){
  //       if(data[key]['documentType']=='documentType.folder'){

  //       }else if(data[key]['documentType']=='documentType.file'){

  //       }
  //     }
  //   })
  // }

  // TODO
  // Stream<QuerySnapshot> get files {
  //   return _db.collection('collectionPath').snapshots();
  // }

  // Stream<QuerySnapshot> get folders {
  //   return _folders.snapshots();
  // }

}
