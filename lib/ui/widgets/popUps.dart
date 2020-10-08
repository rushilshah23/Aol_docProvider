import 'package:Aol_docProvider/core/models/filemodel.dart';
import 'package:Aol_docProvider/core/models/foldermodel.dart';
import 'package:Aol_docProvider/core/models/usermodel.dart';
import 'package:Aol_docProvider/core/services/database.dart';
import 'package:Aol_docProvider/core/services/validators.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

shareWithPopUp(
  BuildContext context, {
  FocusNode focusNode,
  FolderModel folderModel,
  FileModel fileModel,
  documentType documentType,
  // String docId,
  // DatabaseReference yourRef,
  // String docName,
  // String userId,
  // String senderEmailId,
  // documentType documentType
}) {
  TextEditingController _sharerControllerName = new TextEditingController();
  GlobalKey<FormState> _sharerKeyName = new GlobalKey<FormState>();
  return showDialog(
    context: context,
    builder: (context) {
      UserModel _userModel = Provider.of<UserModel>(context);
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Enter emailId of the person to Share with"),
        content: Form(
          key: _sharerKeyName,
          child: TextFormField(
              cursorColor: Color(0xFF02DEED),
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                labelStyle: TextStyle(
                    color:
                        focusNode.hasFocus ? Colors.black : Color(0xFF02DEED),
                    fontSize: 10.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[500],
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF02DEED)),
                ),
              ),
              focusNode: focusNode,
              autofocus: true,
              controller: _sharerControllerName,
              validator: emailValidator
              // validator: passwordValidator,
              ),
        ),
        actions: [
          FlatButton(
              color: Colors.white,
              onPressed: () async {
                if (_sharerKeyName.currentState.validate()) {
                  await DatabaseService(
                    // userID: folderModel.userId,

                    // userID: folderModel.userId ?? fileModel.userId,
                    // userID: fileModel.userId,

                    userID: _userModel.uid,

                    // driveRef: folderModel.globalRef
                  ).shareWith(
                    docType: documentType,
                    receiverEmailId: _sharerControllerName.text,
                    folderModel: folderModel ?? null,
                    fileModel: fileModel ?? null,

                    // docId: docId,
                    // sharePath: yourRef,
                    // docName: docName,
                    // senderEmailId: senderEmailId,
                    // documentType: documentType
                  );
                }
              },
              child: Text(
                "Share",
                style: TextStyle(color: Color(0xFF02DEED)),
              )),
          FlatButton(
              onPressed: () {
                _sharerControllerName.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ))
        ],
      );
    },
  );
}
