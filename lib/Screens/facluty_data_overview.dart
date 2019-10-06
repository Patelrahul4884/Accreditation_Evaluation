import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile.dart';
import '../providers/profiles.dart';
import 'package:intl/intl.dart';
import './main_screen.dart';

class DataOverview extends StatefulWidget {
   static const routeName='/profile';
  @override
  _DataOverviewState createState() => _DataOverviewState();
}

class _DataOverviewState extends State<DataOverview> {

  final _focusnode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _editProfile = Profile(
      id: null,
      name: '',
      designation: '',
      department: '',
      email: '',
      doj: DateTime.now(),
      dob: DateTime.now(),
      panN0: '',
      aadharNo: null,
      gtustaffcode: null,
      mobileno: null,
      localAdd: '',
      perAdd: '');
  @override
  void dispose() {
    _focusnode.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;
  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      Provider.of<Profiles>(context, listen: false).addProfile(_editProfile);
      Navigator.of(context).pushNamed(MainScreen.routeName);
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    if (value.length != 10) return 'Phone number must be of 10 digits.';
    return null;
  }

  String _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate()) return true;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('This form has errors'),
              content: const Text('Really leave this form?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static const designation = <String>[
    'Ass. Prof.',
    'HOD',
    'Associate Prof.',
  ];
  static const department = <String>[
    'IT',
    'CSE',
  ];
  final List<DropdownMenuItem<String>> _dropDownMenudesignation = designation
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  final List<DropdownMenuItem<String>> _dropDownMenudepartment = department
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  String _btn2SelectedVal;
  String _btn2SelectedVal2;

  DateTime _selectedDate;
  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return Text('Please Select Date');
      } else {
        _editProfile = Profile(
            id: null,
            name: _editProfile.name,
            designation: _editProfile.designation,
            department: _editProfile.department,
            email: _editProfile.email,
            doj: pickedDate,
            dob: _editProfile.dob,
            panN0: _editProfile.panN0,
            aadharNo: _editProfile.aadharNo,
            gtustaffcode: _editProfile.gtustaffcode,
            mobileno: _editProfile.mobileno,
            localAdd: _editProfile.localAdd,
            perAdd: _editProfile.perAdd);
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }
   static const routeName='/profile-data';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _handleSubmitted,
          )
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          onWillPop: _warnUserAboutInvalidData,
          child: Scrollbar(
            child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      hintText: 'What do people call you?',
                      labelText: 'Name *',
                    ),
                    onSaved: (value) {
                      _editProfile = Profile(
                          id: null,
                          name: value,
                          designation: _editProfile.designation,
                          department: _editProfile.department,
                          email: _editProfile.email,
                          doj: _editProfile.doj,
                          dob: _editProfile.dob,
                          panN0: _editProfile.panN0,
                          aadharNo: _editProfile.aadharNo,
                          gtustaffcode: _editProfile.gtustaffcode,
                          mobileno: _editProfile.mobileno,
                          localAdd: _editProfile.localAdd,
                          perAdd: _editProfile.perAdd);
                    },
                    validator: _validateName,
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      const SizedBox(width: 15.0),
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                _selectedDate == null
                                    ? 'Date of Join'
                                    : DateFormat.yMd().format(_selectedDate),
                                //style: TextStyle(fontSize: 15),
                              ),
                              onPressed: _presentDatePicker,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40.0),
                      Icon(Icons.calendar_today),
                      const SizedBox(width: 15.0),
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                _selectedDate == null
                                    ? 'Date of Birth'
                                    : DateFormat.yMd().format(_selectedDate),

                                //style: TextStyle(fontSize: 15),
                              ),
                              onPressed: _presentDatePicker,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    maxLength: 10,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.phone),
                      hintText: 'Where can we reach you?',
                      labelText: 'Phone Number *',
                      prefixText: '+91',
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_focusnode);
                    },
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      _editProfile = Profile(
                          id: null,
                          name: _editProfile.name,
                          designation: _editProfile.designation,
                          department: _editProfile.department,
                          email: _editProfile.email,
                          doj: _editProfile.doj,
                          dob: _editProfile.dob,
                          panN0: _editProfile.panN0,
                          aadharNo: _editProfile.aadharNo,
                          gtustaffcode: _editProfile.gtustaffcode,
                          mobileno: int.parse(value),
                          localAdd: _editProfile.localAdd,
                          perAdd: _editProfile.perAdd);
                    },
                    validator: _validatePhoneNumber,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.email),
                      hintText: 'Your email address',
                      labelText: 'E-mail',
                    ),
                    focusNode: _focusnode,
                    onSaved: (value) {
                      _editProfile = Profile(
                          id: null,
                          name: _editProfile.name,
                          designation: _editProfile.designation,
                          department: _editProfile.department,
                          email: value,
                          doj: _editProfile.doj,
                          dob: _editProfile.dob,
                          panN0: _editProfile.panN0,
                          aadharNo: _editProfile.aadharNo,
                          gtustaffcode: _editProfile.gtustaffcode,
                          mobileno: _editProfile.mobileno,
                          localAdd: _editProfile.localAdd,
                          perAdd: _editProfile.perAdd);
                    },
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(width: 30.0),
                        DropdownButton(
                          value: _btn2SelectedVal,
                          hint: Text('Designation'),
                          onChanged: ((value) {
                            _editProfile = Profile(
                                id: null,
                                name: _editProfile.name,
                                designation: value,
                                department: _editProfile.department,
                                email: _editProfile.email,
                                doj: _editProfile.doj,
                                dob: _editProfile.dob,
                                panN0: _editProfile.panN0,
                                aadharNo: _editProfile.aadharNo,
                                gtustaffcode: _editProfile.gtustaffcode,
                                mobileno: _editProfile.mobileno,
                                localAdd: _editProfile.localAdd,
                                perAdd: _editProfile.perAdd);
                            setState(() {
                              _btn2SelectedVal = value;
                            });
                          }),
                          items: _dropDownMenudesignation,
                        ),
                        const SizedBox(width: 50.0),
                        DropdownButton(
                          value: _btn2SelectedVal2,
                          hint: Text('Department'),
                          onChanged: ((value) {
                            _editProfile = Profile(
                                id: null,
                                name: _editProfile.name,
                                designation: _editProfile.designation,
                                department: value,
                                email: _editProfile.email,
                                doj: _editProfile.doj,
                                dob: _editProfile.dob,
                                panN0: _editProfile.panN0,
                                aadharNo: _editProfile.aadharNo,
                                gtustaffcode: _editProfile.gtustaffcode,
                                mobileno: _editProfile.mobileno,
                                localAdd: _editProfile.localAdd,
                                perAdd: _editProfile.perAdd);
                            setState(() {
                              _btn2SelectedVal2 = value;
                            });
                          }),
                          items: _dropDownMenudepartment,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    maxLength: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your PAN Number',
                      //helperText: 'Keep it short, this is just a demo.',
                      labelText: 'PAN Number',
                    ),
                    onSaved: (value) {
                      _editProfile = Profile(
                          id: null,
                          name: _editProfile.name,
                          designation: _editProfile.designation,
                          department: _editProfile.department,
                          email: _editProfile.email,
                          doj: _editProfile.doj,
                          dob: _editProfile.dob,
                          panN0: value,
                          aadharNo: _editProfile.aadharNo,
                          gtustaffcode: _editProfile.gtustaffcode,
                          mobileno: _editProfile.mobileno,
                          localAdd: _editProfile.localAdd,
                          perAdd: _editProfile.perAdd);
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    maxLength: 12,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your Aadhar Number',
                      labelText: 'Aadhar Number',
                    ),
                    onSaved: (value) {
                      _editProfile = Profile(
                          id: null,
                          name: _editProfile.name,
                          designation: _editProfile.designation,
                          department: _editProfile.department,
                          email: _editProfile.email,
                          doj: _editProfile.doj,
                          dob: _editProfile.dob,
                          panN0: _editProfile.panN0,
                          aadharNo: int.parse(value),
                          gtustaffcode: _editProfile.gtustaffcode,
                          mobileno: _editProfile.mobileno,
                          localAdd: _editProfile.localAdd,
                          perAdd: _editProfile.perAdd);
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your GTU Staff Code',
                      labelText: 'GTU Staff Code',
                    ),
                    onSaved: (value) {
                      _editProfile = Profile(
                          id: null,
                          name: _editProfile.name,
                          designation: _editProfile.designation,
                          department: _editProfile.department,
                          email: _editProfile.email,
                          doj: _editProfile.doj,
                          dob: _editProfile.dob,
                          panN0: _editProfile.panN0,
                          aadharNo: _editProfile.aadharNo,
                          gtustaffcode: int.parse(value),
                          mobileno: _editProfile.mobileno,
                          localAdd: _editProfile.localAdd,
                          perAdd: _editProfile.perAdd);
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your Full local Address',
                      labelText: 'Local Address',
                    ),
                    maxLines: 3,
                    onSaved: (value) {
                      _editProfile = Profile(
                          id: null,
                          name: _editProfile.name,
                          designation: _editProfile.designation,
                          department: _editProfile.department,
                          email: _editProfile.email,
                          doj: _editProfile.doj,
                          dob: _editProfile.dob,
                          panN0: _editProfile.panN0,
                          aadharNo: _editProfile.aadharNo,
                          gtustaffcode: _editProfile.gtustaffcode,
                          mobileno: _editProfile.mobileno,
                          localAdd: value,
                          perAdd: _editProfile.perAdd);
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your Full Permanent Address',
                      labelText: 'Permanent Address',
                    ),
                    onSaved: (value) {
                      _editProfile = Profile(
                          id: null,
                          name: _editProfile.name,
                          designation: _editProfile.designation,
                          department: _editProfile.department,
                          email: _editProfile.email,
                          doj: _editProfile.doj,
                          dob: _editProfile.dob,
                          panN0: _editProfile.panN0,
                          aadharNo: _editProfile.aadharNo,
                          gtustaffcode: _editProfile.gtustaffcode,
                          mobileno: _editProfile.mobileno,
                          localAdd: _editProfile.localAdd,
                          perAdd: value);
                    },
                    onFieldSubmitted: (_) {
                      _handleSubmitted();
                    },
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    '* indicates required field',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
