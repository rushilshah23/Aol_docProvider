class FolderModel {
  final dynamic userId;
  final dynamic parentId;
  final dynamic folderId;
  final dynamic documentType;
  final dynamic realFolderPath;
  final dynamic folderPath;
  final dynamic folderName;
  final dynamic createdAt;

  FolderModel(
      {this.userId,
      this.parentId,
      this.folderId,
      this.documentType,
      this.realFolderPath,
      this.folderPath,
      this.folderName,
      this.createdAt});

  // FolderModel.fromMap(Map snapshot, String folderId)
  //     : userId = snapshot['userId'] ?? '',
  //       pid = snapshot['pid'] ?? '',
  //       folderId = snapshot['folderId'] ?? '',
  //       type = snapshot['type'] ?? '',
  //       folderName = snapshot['folderName'] ?? '',
  //       createdAt = snapshot['created at'] ?? '';

  // FolderModel.fromJson(Map<String, dynamic> parsedJson)
  //     : userId = parsedJson['userId'] ?? '',
  //       pid = parsedJson['pid'] ?? '',
  //       folderId = parsedJson['folderId'] ?? '',
  //       type = parsedJson['type'] ?? '',
  //       folderName = parsedJson['folderName'] ?? '',
  //       createdAt = parsedJson['created at'] ?? '';
}
