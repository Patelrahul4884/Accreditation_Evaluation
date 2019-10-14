import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../model/sem_subject.dart';

class NewTaskPage extends StatefulWidget {
  final FirebaseUser user;

  NewTaskPage({Key key, this.user}) : super(key: key);
  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  Color pickerColor = Color(0xff6633ff);
  Color currentColor = Color(0xff6633ff);
  ValueChanged<Color> onColorChanged;
  Repository repo = Repository();
  List<String> _states = ["Select SEM"];
  List<String> _lgas = ["Select Subject"];
  String _selectedState = "Select SEM";
  String _selectedLGA = "Select Subject";
  bool _saving = false;
  bool _isLoading = false;
  bool _autovalidate = false;
  String _connectionStatus = 'Unknown';
  var _editList = NewList(
    id: null,
    sem: '',
    subject: '',
  );
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController listNameController = new TextEditingController();
  Container _getToolbar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, top: 40.0),
      child: BackButton(color: Colors.black),
    );
  }

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _isLoading = false;
      });
      _autovalidate = true;
      showInSnackBar('Please fix the errors before submitting.');
    } else {
      form.save();
      // addToFirebase();
      setState(() {
        _isLoading = true;
      });
    }
    Provider.of<NewLists>(context, listen: false).addList(_editList);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();

    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(value, textAlign: TextAlign.center),
      backgroundColor: currentColor,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _states = List.from(_states)..addAll(repo.getStates());
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result.toString();
      });
    });
  }

  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

  void addToFirebase() async {
    setState(() {
      _saving = true;
    });
    print(_connectionStatus);
    if (_connectionStatus == "ConnectivityResult.none") {
      showInSnackBar("No internet connection currently available");
      setState(() {
        _saving = false;
      });
    } else {
      bool isExist = false;

      QuerySnapshot query =
          await Firestore.instance.collection(widget.user.uid).getDocuments();

      query.documents.forEach((doc) {
        if (_selectedState == doc.documentID) {
          isExist = true;
        }
      });

      if (isExist == false && _selectedState.isNotEmpty) {
        await Firestore.instance
            .collection(widget.user.uid)
            .document(_selectedState.trim())
            .setData({
          "color": currentColor.value.toString(),
          "date": DateTime.now().millisecondsSinceEpoch
        });

        listNameController.clear();
        Navigator.of(context).pop();
      }
      if (isExist == true) {
        showInSnackBar("This list already exists");
        setState(() {
          _saving = false;
        });
      }
      if (_selectedState.isEmpty) {
        showInSnackBar("Please enter a name");
        setState(() {
          _saving = false;
        });
      }
    }
  }

  //Drop down
  void _onSelectedState(String value) {
    _editList = NewList(id: null, sem: value, subject: _editList.subject);
    setState(() {
      _selectedLGA = "Select Subject";
      _lgas = ["Select Subject"];
      _selectedState = value;
      _lgas = List.from(_lgas)..addAll(repo.getLocalByState(value));
    });
  }

  void _onSelectedLGA(String value) {
    _editList = NewList(id: null, sem: _editList.sem, subject: value);
    setState(() => _selectedLGA = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: Theme(
            data: Theme.of(context).copyWith(canvasColor: currentColor),
            child: ModalProgressHUD(
                child: Stack(
                  children: <Widget>[
                    _getToolbar(context),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.grey,
                                    height: 1.5,
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'New',
                                          style: new TextStyle(
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'List',
                                          style: new TextStyle(
                                              fontSize: 28.0,
                                              color: Colors.grey),
                                        )
                                      ],
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.grey,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 50.0, left: 20.0, right: 20.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      items: _states
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem),
                                        );
                                      }).toList(),
                                      onChanged: (value) =>
                                          _onSelectedState(value),
                                      value: _selectedState,
                                    ),
                                    DropdownButton<String>(
                                      items: _lgas
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem),
                                        );
                                      }).toList(),
                                      //onChanged: (value) => print(value),
                                      onChanged: (value) =>
                                          _onSelectedLGA(value),
                                      value: _selectedLGA,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ButtonTheme(
                                      //minWidth: double.infinity,

                                      child: RaisedButton(
                                        elevation: 3.0,
                                        onPressed: () {
                                          pickerColor = currentColor;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Pick a color!'),
                                                content: SingleChildScrollView(
                                                  child: ColorPicker(
                                                    pickerColor: pickerColor,
                                                    onColorChanged: changeColor,
                                                    enableLabel: true,
                                                    colorPickerWidth: 500.0,
                                                    pickerAreaHeightPercent:
                                                        0.7,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Got it'),
                                                    onPressed: () {
                                                      setState(() =>
                                                          currentColor =
                                                              pickerColor);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text('Card color'),
                                        color: currentColor,
                                        textColor: const Color(0xffffffff),
                                      ),
                                    ),
                                    RaisedButton(
                                      child: const Text(
                                        'Add',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: currentColor,
                                      elevation: 4.0,
                                      splashColor: Colors.deepPurple,
                                      onPressed: _handleSubmitted,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                inAsyncCall: _saving),
          ),
        ));
  }
}

class NewList with ChangeNotifier {
  final String id;
  final String sem;
  final String subject;

  NewList({this.id, this.sem, this.subject});
}

class NewLists with ChangeNotifier {
  List<NewList> _listData = [];
  Future<void> fetchAndSetList() async {
    const url = 'https://my-project-1534083261246.firebaseio.com/list.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)as Map<String,dynamic>;
      final List<NewList>loadedList=[];
      extractedData.forEach((listId,listData){
         loadedList.add(NewList(
           id: listId,
           sem: listData['sem'],
           subject: listData['subject'],
         ));
      });
      _listData=loadedList;
      notifyListeners();
      //print(json.decode(response.body));  
    } catch (error) {
      throw error;
    }
  }

  Future<void> addList(NewList newlist) async {
    const url = 'https://my-project-1534083261246.firebaseio.com/list.json';
    http.post(url,
        body: json.encode({'sem': newlist.sem, 'subject': newlist.subject}));
    final addlist = NewList(
        sem: newlist.sem,
        subject: newlist.subject,
        id: DateTime.now().toString());
    _listData.add(addlist);
    notifyListeners();
  }
}
