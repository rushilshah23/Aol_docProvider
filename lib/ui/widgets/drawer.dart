import 'package:Aol_docProvider/core/services/authenticationService.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:Aol_docProvider/ui/widgets/loading.dart';
import 'package:flutter/material.dart';

Widget homeDrawer(BuildContext context) {
  isLoading = false;
  final AuthenticationService _auth = AuthenticationService();
  return isLoading
      ? Loading()
      : Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(child: Text('Drawer Header'), decoration: colorBox),
              ListTile(
                title: Text('SignOut'),
                onTap: () async {
                  isLoading = true;
                  _auth.signoutEmailId();
                  isLoading = false;
                  Navigator.pop(context);
                },
              ),
              // ListTile(
              //   title: Text('Item 2'),
              //   onTap: () {

              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        );
}
