import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class Crud extends ChangeNotifier {
  // Folder Functions

  deleteFolder() {}

  renameFolder({String pid, String fol}) {}

  moveFolder() {}

// File Functions

  Future<void> chooseFile() async {
    File file = await FilePicker.getFile(type: FileType.custom);
    String fileName = file.path.split('/').last;
    print("This is filename  $fileName");
    // uploadFile(userId: userID,file: file,fileName: fileName,folderId: )
  }

  // Future<void> uploadFile(
  //     {String userId, String folderId, String fileName, File file}) {}

  deleteFile() {}

  renameFile() {}

  moveFile() {}

  downloadFile() {}

  viewFile() {}

  void loadFirebaseData({String folderId}) {}
}
