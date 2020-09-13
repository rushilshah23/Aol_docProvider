import 'package:Aol_docProvider/core/services/database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FileCard extends StatefulWidget {
  final dynamic userId;
  final dynamic parentId;
  final dynamic fileId;
  final dynamic fileName;
  final DatabaseReference globalRef;
  // final dynamic filePath;
  // final dynamic realFilePath;
  final dynamic documentType;
  final dynamic fileDownloadLink;
  // final dynamic fileSize;
  final dynamic createdAt;
  // final dynamic modifiedAt;

  FileCard(
      {this.userId,
      this.parentId,
      this.fileId,
      this.fileName,
      this.globalRef,
      // this.filePath,
      // this.realFilePath,
      this.documentType,
      this.fileDownloadLink,
      this.createdAt});
  @override
  _FileCardState createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  TextEditingController _renameFileController = new TextEditingController();
  GlobalKey<FormState> _renameFileKey = new GlobalKey<FormState>();

  void initState() {
    // _renameFileController.text = widget.fileName;
    super.initState();
  }

  _launchURL(String fileurl) async {
    String url = fileurl;
    print("url going to launch is $url");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  renameFilePopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter folder name"),
          content: Form(
            key: _renameFileKey,
            child: TextFormField(
                autofocus: true,
                controller: _renameFileController,
                validator: (String content) {
                  if (content.length != 0) {
                    if (content.contains("#") ||
                        content.contains("[") ||
                        content.contains("]") ||
                        content.contains("*") ||
                        content.contains("/") ||
                        content.contains("?")) {
                      return "enter valid file name";
                      // "Folder name should not contains invalid characters like #,[,],*,?";
                    } else
                      return null;
                  } else
                    return "Enter a new file name";
                }),
          ),
          actions: [
            FlatButton(
                onPressed: () async {
                  if (_renameFileKey.currentState.validate()) {
                    Navigator.pop(context);
                    DatabaseService(
                            folderId: widget.parentId,
                            globalRef: widget.globalRef,
                            userID: widget.userId)
                        .renameFile(
                      newFileName: _renameFileController.text,
                      fileId: widget.fileId,
                    );

                    _renameFileController.clear();
                  }
                },
                child: Text("Ok")),
            FlatButton(
                onPressed: () {
                  _renameFileController.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"))
          ],
        );
      },
    );
  }

  void fileOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    topRight: const Radius.circular(30),
                  )),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.cloud_download),
                    title: Text("Download File"),
                    onTap: () async {
                      DatabaseService(
                              folderId: widget.parentId,
                              globalRef: widget.globalRef,
                              userID: widget.userId)
                          .downloadFile(
                              fileName: widget.fileName,
                              fileDownloadLink: widget.fileDownloadLink);
                      //  TODO DOWNLOAD FILE
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete File"),
                    onTap: () async {
                      DatabaseService(
                              folderId: widget.parentId,
                              globalRef: widget.globalRef,
                              userID: widget.userId)
                          .deleteFile(
                        fileId: widget.fileId,
                        fileName: widget.fileName,
                      );
                      // delete file
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.label),
                    title: Text("Rename File"),
                    onTap: () {
                      Navigator.pop(context);
                      renameFilePopUp(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      // color: Colors.red,
      child: FittedBox(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                iconSize: 60,
                icon: FaIcon(
                  FontAwesomeIcons.solidFileAlt,
                  size: 60,
                ),
                onPressed: () async {
                  await _launchURL(widget.fileDownloadLink);
                },
              ),
              // SizedBox(
              //   height: 2,
              // ),

              Container(
                margin: EdgeInsets.only(left: 3),
                width: 70,
                padding: EdgeInsets.only(left: 13),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 120,
                        child: AutoSizeText(
                          "${widget.fileName}",
                          maxLines: 2,
                          minFontSize: 28,
                          maxFontSize: 28,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                          icon: FaIcon(FontAwesomeIcons.ellipsisH),
                          onPressed: () {
                            fileOptions(context);
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
