class FileModel {
  final dynamic userId;
  final dynamic parentId;
  final dynamic fileId;
  final dynamic fileName;
  final dynamic filePath;
  final dynamic realFilePath;
  final dynamic documentType;
  final dynamic fileDownloadLink;
  // final dynamic fileSize;
  final dynamic createdAt;
  // final dynamic modifiedAt;

  FileModel(
      {this.userId,
      this.parentId,
      this.fileId,
      this.fileName,
      this.filePath,
      this.realFilePath,
      this.documentType,
      this.fileDownloadLink,
      this.createdAt});

  // FileModel.fromJson(Map<String, dynamic> parsedJson)
  //     : userId = parsedJson['userId'] ?? '',
  //       pid = parsedJson['pid'] ?? '',
  //       fileId = parsedJson['fileId'] ?? '',
  //       type = parsedJson['type'] ?? '',
  //       fileDownloadLink = parsedJson['fileDownloadLink'] ?? '',
  //       fileName = parsedJson['fileName'] ?? '',
  //       createdAt = parsedJson['created at'] ?? '';
}

// FileModel.fromMap(Map snapshot, String fileId)
//     : userId = snapshot['userId'] ?? '',
//       pid = snapshot['pid'] ?? '',
//       fileId = snapshot['fileId'] ?? '',
//       fileName = snapshot['fileName'] ?? '',
//       type = snapshot['type'] ?? '',
//       fileDownloadLink = snapshot['fileDownloadLink'] ?? '',
//       createdAt = snapshot['created at'] ?? '';

// toJson() {
//   return {
//     "userId": userId,
//     "pid": pid,
//     "fileId": fileId,
//     "fileName": fileName,
//     "type": type,
//     "fileDownloadLink": fileDownloadLink,
//     "createdAt": createdAt
//   };
// }
