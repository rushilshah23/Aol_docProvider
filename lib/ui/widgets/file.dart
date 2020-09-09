import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FileCard extends StatefulWidget {
  final DatabaseReference globalRefDB;
  final String fileKey;
  final String fileName;
  final String fileDownloadLink;
  FileCard(
      {this.globalRefDB, this.fileKey, this.fileName, this.fileDownloadLink});
  @override
  _FileCardState createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  TextEditingController _renameFileController = new TextEditingController();
  GlobalKey<FormState> _renameFileKey = new GlobalKey<FormState>();

  void initState() {
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
                    return "Enter a newfolder name";
                }),
          ),
          actions: [
            FlatButton(
                onPressed: () async {
                  if (_renameFileKey.currentState.validate()) {
                    Navigator.pop(context);
                    //TODO RENAME FILE
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
                      //  TODO DOWNLOAD FILE
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete File"),
                    onTap: () {
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
                  FontAwesomeIcons.fileAlt,
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
