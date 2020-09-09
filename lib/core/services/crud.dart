import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class Crud extends ChangeNotifier {
  // Folder Functions

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

  // Future<void> uploadFile(
  //     {String userId, String folderId, String fileName, File file}) {}

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
