import 'package:Aol_docProvider/core/viewmodels/file.dart';
import 'package:Aol_docProvider/core/viewmodels/folders.dart';

import 'package:flutter/material.dart';

class ReceivedUserModel {
  final String receivedUserEmailId;
  final String receivedUserUid;
  final String userId;
  // List<FolderCard> folderModelList;
  // List<FileCard> fileModelList;

  // final DatabaseReference receiverRef;
  ReceivedUserModel({
    @required this.receivedUserEmailId,
    @required this.userId,
    // @required this.receiverRef,
    @required this.receivedUserUid,
    // this.fileModelList,
    // this.folderModelList,
  });
}
