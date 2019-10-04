import 'package:flutter/foundation.dart';
class Profile {
  final String image;
  final String id;
  final String name;
  final String designation;
  final String department;
  final DateTime doj;
  final DateTime dob;
  final String panN0;
  final int aadharNo;
  final int gtustaffcode;
  final int mobileno;
  final String localAdd;
  final String perAdd;
  final String bloodG;
  Profile(
      {this.image,
    @required  this.id,
     @required  this.name,
     @required this.designation,
     @required this.department,
     @required this.doj,
     @required this.dob,
     @required this.panN0,
     @required this.aadharNo,
     @required this.gtustaffcode,
     @required this.mobileno,
     @required this.localAdd,
     @required this.perAdd,
     @required this.bloodG});
}
