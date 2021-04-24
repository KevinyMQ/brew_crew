import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/my_user.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:firebase_auth/firebase_auth.dart';
    class DatabaseService {

      final String uid;
      DatabaseService({this.uid});

      //collection reference
      final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

      Future updateUserData(String sugars, String name, int strength) async {
        return await brewCollection.doc(uid).set({
          'sugars': sugars,
          'name': name,
          'strength': strength
        });
      }

      //Brew list from Snapshot
      List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
        return snapshot.docs.map((doc){
          return Brew(
              name: doc.data()['name'].toString() ?? '',
              sugars: doc.data()['sugars'].toString() ?? '0',
              strength: doc.data()['strength'] ?? 0,
          );
        }).toList();
      }
      //User data from snapshot
      UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
        return UserData(
          uid: uid,
          name: snapshot.data()['name'],
          sugars: snapshot.data()['sugars'],
          strength: snapshot.data()['strength'],
        );
      }


      Stream<List<Brew>> get brews {
        return brewCollection.snapshots().map(_brewListFromSnapshot);
      }

      //get user doc stream
      Stream <UserData> get userData {
        return brewCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
      }


    }