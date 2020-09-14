import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
DatabaseReference globalRef = _firebaseDatabase.reference();
// .child('users')
// .child('DocumentManager')
// .reference();
