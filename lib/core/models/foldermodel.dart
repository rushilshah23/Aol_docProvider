class FolderModel {
  final dynamic userId;
  final dynamic pid;
  final dynamic folderId;
  final dynamic type;
  final dynamic folderName;
  final dynamic createdAt;

  FolderModel(
      {this.userId,
      this.pid,
      this.folderId,
      this.type,
      this.folderName,
      this.createdAt});

  // FolderModel.fromMap(Map snapshot, String folderId)
  //     : userId = snapshot['userId'] ?? '',
  //       pid = snapshot['pid'] ?? '',
  //       folderId = snapshot['folderId'] ?? '',
  //       type = snapshot['type'] ?? '',
  //       folderName = snapshot['folderName'] ?? '',
  //       createdAt = snapshot['created at'] ?? '';

  FolderModel.fromJson(Map<String, dynamic> parsedJson)
      : userId = parsedJson['userId'] ?? '',
        pid = parsedJson['pid'] ?? '',
        folderId = parsedJson['folderId'] ?? '',
        type = parsedJson['type'] ?? '',
        folderName = parsedJson['folderName'] ?? '',
        createdAt = parsedJson['created at'] ?? '';
}
