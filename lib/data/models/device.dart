import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'package:flutter/material.dart';

class Device {
  final String name;
  final bool isAvailable;
  final User user;
  final DocumentReference reference;

  Device.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['is_available'] != null),
        assert(map['user'] != null),
        name = map['name'],
        isAvailable = map['is_available'],
        user = User.fromMap(map['user']);

  Device.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  String ownedBy(String currentUserId){
    if (isAvailable){
      return "Available";
    }
    if (user.id == currentUserId){
      return "You owned";
    }
    return user.name;
  }

  Color donutColor(String currentUserId){
    if (isAvailable){
      return Colors.green[500];
    }
    if (user.id == currentUserId){
      return Colors.blue[500];
    }
    return Colors.red[500];
  }

  @override
  String toString() => "Device<$name:$isAvailable>";
}