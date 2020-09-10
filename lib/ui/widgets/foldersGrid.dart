import 'package:Aol_docProvider/core/models/foldermodel.dart';
import 'package:Aol_docProvider/ui/widgets/folders.dart';
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

    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return FolderCard(folderModel: folders[index]);
        });
  }
}
