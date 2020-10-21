import 'package:Aol_docProvider/core/models/usermodel.dart';
import 'package:Aol_docProvider/core/services/authenticationService.dart';
import 'package:Aol_docProvider/core/services/database.dart';
import 'package:Aol_docProvider/ui/screens/Authentication/authentication.dart';
import 'package:Aol_docProvider/ui/screens/home/shared.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:Aol_docProvider/ui/widgets/loading.dart';
import 'package:Aol_docProvider/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget homeDrawer(BuildContext context) {
  var user = Provider.of<UserModel>(context, listen: false);
  isLoading = false;
  final AuthenticationService _auth = AuthenticationService();
  return isLoading
      ? Loading()
      : Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                          child: Text(
                        user.userEmail ?? user.userPhoneNo ?? 'null',
                        style: TextStyle(),
                      )),
                    ],
                  ),
                  decoration: colorBox),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.cloud_off),
                    SizedBox(
                      width: 50,
                    ),
                    Text('SignOut'),
                  ],
                ),
                onTap: () async {
                  isLoading = true;

                  AuthenticationService().signoutEmailId().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Wrapper();
                    }));
                  });

                  isLoading = false;
                  // Navigator.pop(context);
                  // _auth.signoutEmailId();
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.folder_shared),
                    SizedBox(
                      width: 50,
                    ),
                    Text('Shared with Me'),
                  ],
                ),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SharedPage();
                  }));
                },
              ),
            ],
          ),
        );
}
