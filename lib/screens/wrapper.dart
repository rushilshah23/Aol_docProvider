import 'package:Aol_docProvider/models/usermodel.dart';
import 'package:Aol_docProvider/screens/Authentication/authentication.dart';
import 'package:Aol_docProvider/screens/home/drive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      return Authenticate();
    } else
      return DrivePage(
        uid: user.uid,
        pid: user.uid,
      );
  }
}
