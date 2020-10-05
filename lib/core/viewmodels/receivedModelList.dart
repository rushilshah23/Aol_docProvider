import 'package:Aol_docProvider/core/models/receivedusermodel.dart';

import 'package:Aol_docProvider/ui/screens/home/shareddrive.dart';

import 'package:flutter/material.dart';

class ReceivedModelListTile extends StatefulWidget {
  final ReceivedUserModel receivedUserModel;
  ReceivedModelListTile({@required this.receivedUserModel});
  @override
  _ReceivedModelListTileState createState() => _ReceivedModelListTileState();
}

class _ReceivedModelListTileState extends State<ReceivedModelListTile> {
  // FirebaseDatabase _fb = FirebaseDatabase.instance;
  // DatabaseReference _databaseReference;

  // List<ReceivedModel> receivedModelDocListTileCards = [];
  void initState() {
    // _databaseReference = _fb
    //     .reference()
    //     .child('shared')
    //     .child('users')
    //     .child(widget.receivedUserModel.receivedUserUid)
    //     .reference();
    super.initState();
  }

  // getReceivedModelListTileList() async {
  //   // _fbdb = FirebaseDatabase.instance;
  //   // _shareRef = _fbdb.reference();

  //   await _databaseReference.once().then((snapshot) {
  //     if (snapshot.value != null) {
  //       var keys = snapshot.value.keys;
  //       var data = snapshot.value;
  //       receivedModelDocListTileCards.clear();
  //       for (var key in keys) {
  //         if (data[key][''])
  //           setState(() {
  //             ReceivedModel receivedModelCard = new ReceivedModel(
  //                 docId: data[key]['docId'],
  //                 senderId: data[key]['senderId'],
  //                 senderEmailId: data[key]['senderEmailId'],
  //                 shareId: data[key]['shareId'],
  //                 sharePath: data[key]['sharePath'],
  //                 sharePathName: data[key]['sharePathName'],
  //                 userId: data[key]['userId'],
  //                 documentType: data[key]['documentType']);

  //             receivedModelDocListTileCards.add(receivedModelCard);
  //           });
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(Icons.person),
          SizedBox(
            width: 50,
          ),
          Text(widget.receivedUserModel.receivedUserEmailId),
        ],
      ),
      onTap: () async {
        // return ShareDrivePage(
        //   receivedUserModel: widget.receivedUserModel,
        // );
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ShareDrivePage(
            receivedUserModel: widget.receivedUserModel,
          );
        }));
      },
    );
  }
}
