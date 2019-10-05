import 'package:flutter/foundation.dart';
class Profile with ChangeNotifier {
  final String id;
  final String name;
  final String designation;
  final String department;
  final String email;
  final DateTime doj;
  final DateTime dob;
  final String panN0;
  final int aadharNo;
  final int gtustaffcode;
  final int mobileno;
  final String localAdd;
  final String perAdd;
  Profile(
      {
    @required  this.id,
     @required  this.name,
     @required this.designation,
     @required this.department,
     @required this.email,
     @required this.doj,
     @required this.dob,
     @required this.panN0,
     @required this.aadharNo,
     @required this.gtustaffcode,
     @required this.mobileno,
     @required this.localAdd,
     @required this.perAdd,
    });
}
