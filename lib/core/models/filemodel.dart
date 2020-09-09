class FileModel {
  final dynamic userId;
  final dynamic pid;
  final dynamic fileId;
  final dynamic fileName;
  final dynamic fileDownloadLink;
  final dynamic createdAt;

  FileModel(
      {this.userId,
      this.pid,
      this.fileId,
      this.fileName,
      this.fileDownloadLink,
      this.createdAt});
}
