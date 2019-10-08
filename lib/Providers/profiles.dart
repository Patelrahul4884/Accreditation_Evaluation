import 'dart:convert';
import 'package:flutter/material.dart';
import './profile.dart';
import 'package:http/http.dart' as http;


class Profiles with ChangeNotifier {
  List<Profile>_data=[

  ];
  Future<void> addProfile(Profile profile)async {
    const url='https://my-project-1534083261246.firebaseio.com/profile.json';
    try {
      final response=await http.post(url,body:json.encode({
      'name':profile.name,
      'designation':profile.designation,
      'department':profile.department,
      'email':profile.email,
      'doj':profile.doj.toString(),
      'dob':profile.dob.toString(),
      'panNo':profile.panN0,
      'aadharNo':profile.aadharNo,
      'gtustaffcode':profile.gtustaffcode,
      'mobileno': profile.mobileno,
        'localAdd': profile.localAdd,
        'perAdd': profile.perAdd,
    } ));
    final newProfile = Profile(
      id:json.decode(response.body)['name'],
        name: profile.name,
        designation: profile.designation,
        department: profile.department,
        email: profile.email,
        doj: profile.doj,
        dob: profile.dob,
        panN0: profile.panN0,
        aadharNo: profile.aadharNo,
        gtustaffcode: profile.gtustaffcode,
        mobileno: profile.mobileno,
        localAdd: profile.localAdd,
        perAdd: profile.perAdd);
        _data.add(newProfile) ;
        notifyListeners();
    }catch(error){
      throw error;
    }
        
}
}