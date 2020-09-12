import 'package:Aol_docProvider/core/models/foldermodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderGrid extends StatefulWidget {
  @override
  _FolderGridState createState() => _FolderGridState();
}

class _FolderGridState extends State<FolderGrid> {
  @override
  Widget build(BuildContext context) {
    final folders = Provider.of<List<FolderModel>>(context);

    return Container();
  }
}
