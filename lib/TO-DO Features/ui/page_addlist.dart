import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
class NewTaskPage extends StatefulWidget {
  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  Color pickerColor = Color(0xff6633ff);
  Color currentColor = Color(0xff6633ff);
  ValueChanged<Color> onColorChanged;
  bool _saving = false;
 bool _isLoading=false;
  bool _autovalidate = false;
  String _connectionStatus = 'Unknown';
  var _editList=NewList(
      id:null,
      listName: '',
  );
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController listNameController = TextEditingController();
  Container _getToolbar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, top: 40.0),
      child: BackButton(color: Colors.black),
    );
  }

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }
   void _handleSubmitted(){
     final FormState form = _formKey.currentState;
       if (!form.validate()) {
      setState(() {
        _isLoading = false;
      });
      _autovalidate = true; 
     showInSnackBar('Please fix the errors before submitting.');
   }
      else {
      form.save();
      setState(() {
        _isLoading = true;
      });
    }
     Provider.of<NewLists>(context,listen: false).addList(_editList);
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

  String _validateName(String value) {
    if (value.isEmpty) {
      return 'Please Add list';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
                key: _formKey,
                autovalidate: _autovalidate,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          fontSize: 28.0, color: Colors.grey),
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
                        padding:
                            EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.teal)),
                                  labelText: "List name",
                                  contentPadding: EdgeInsets.only(
                                      left: 16.0,
                                      top: 20.0,
                                      right: 16.0,
                                      bottom: 5.0)),
                              controller: listNameController,
                              autofocus: true,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              maxLength: 20,
                              validator: _validateName,
                              onSaved: (value){
                                _editList=NewList(
                                  id: null,
                                  listName: value,
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            title: const Text('Pick a color!'),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                pickerColor: pickerColor,
                                                onColorChanged: changeColor,
                                                enableLabel: true,
                                                colorPickerWidth: 500.0,
                                                pickerAreaHeightPercent: 0.7,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Got it'),
                                                onPressed: () {
                                                  setState(() =>
                                                      currentColor = pickerColor);
                                                  Navigator.of(context).pop();
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
                                  color: Colors.blue,
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
    );
  }
}
class NewList with ChangeNotifier{
  final String id;
  final String listName;

  NewList({this.id,this.listName});
}
class NewLists with ChangeNotifier{
  List<NewList>_listData=[];
  void addList(NewList newlist){
    const url='https://my-project-1534083261246.firebaseio.com/list.json';
    http.post(url,body:json.encode({
      'listName':newlist.listName,
    }));
    final addlist=NewList(
      listName: newlist.listName,
      id: DateTime.now().toString()
    );
    _listData.add(addlist);
    notifyListeners();
  }
}