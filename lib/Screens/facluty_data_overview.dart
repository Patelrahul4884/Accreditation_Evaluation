import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';
import 'package:intl/intl.dart';

class DataOverview extends StatefulWidget {
  // final List<Profile> userData=[
  //   Profile(
  //     id: 'u1',
  //     name: 'Nital Mistry',
  //     designation: 'HOD',
  //     department: 'IT',
  //     doj: DateTime.now(),
  //     dob: DateTime.now(),
  //     panN0: 'ABCD12345',
  //     aadharNo: 000000000000,
  //     gtustaffcode: 00000000,
  //     mobileno: 9999999999,
  //     localAdd: 'Surat',
  //     perAdd: 'Surat',
  //     bloodG: 'A+',

  //   ),

  // ];
  @override
  _DataOverviewState createState() => _DataOverviewState();
}

class _DataOverviewState extends State<DataOverview> {
 final _focusnode=FocusNode();
 @override
  void dispose() {
    _focusnode.dispose();
    super.dispose();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _formWasEdited = false;
 void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
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
    if (value.length!=10)
      return 'Phone number must be of 10 digits.';
    return null;
  }
  String _validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if(!regExp.hasMatch(value)){
      return "Invalid Email";
    }else {
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
String id;
   String _name;
   String _email;
   String _designation;
   String _department;
   DateTime _doj;
   DateTime _dob;
   String _panN0;
   String _aadharNo;
   String _gtustaffcode;
   String _phoneno;
   String _localAdd;
   String _perAdd;
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
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

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
                      onSaved: (String value) {
                      _name = value;
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
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(_focusnode);
                    },
                    keyboardType: TextInputType.phone,
                    onSaved: (String value) {
                      _phoneno = value;
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
                    onSaved: (String value) {
                      _email = value;
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
                          onChanged: ((String newValue) {
                            setState(() {
                              _btn2SelectedVal = newValue;
                            });
                          }),
                          items: _dropDownMenudesignation,
                        ),
                        const SizedBox(width: 50.0),
                        DropdownButton(
                          value: _btn2SelectedVal2,
                          hint: Text('Department'),
                          onChanged: ((String newValue) {
                            setState(() {
                              _btn2SelectedVal2 = newValue;
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
                      hintText:
                          'Enter Your PAN Number',
                      //helperText: 'Keep it short, this is just a demo.',
                      labelText: 'PAN Number',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    maxLength: 12,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Enter Your Aadhar Number',
                      labelText: 'Aadhar Number',
                    ),
                  ),
                    const SizedBox(height: 24.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Enter Your GTU Staff Code',
                      labelText: 'GTU Staff Code',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Enter Your Full local Address',
                      labelText: 'Local Address',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24.0),
                   TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Enter Your Full Permanent Address',
                      labelText: 'Permanent Address',
                    ),
                    onFieldSubmitted: (_){
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
