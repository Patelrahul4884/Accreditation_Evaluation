import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/element.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils/diamond_fab.dart';
class PageDetail extends StatefulWidget {
  final FirebaseUser user;
  final int i;
  final Map<String, List<ElementTask>> currentList;
  final String color;
  PageDetail({Key key, this.user, this.i, this.currentList, this.color})
      : super(key: key);

  @override
  _PageDetailState createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  Color pickerColor;
  Color currentColor;
  ValueChanged<Color> onColorChanged;

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }
  Padding _getToolbar(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 12.0),
      child:
          new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            new Image(
                width: 35.0,
                height: 35.0,
                fit: BoxFit.cover,
                image: new AssetImage('assets/list.png')
            ),
        RaisedButton(
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
                      colorPickerWidth: 1000.0,
                      pickerAreaHeightPercent: 0.7,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Got it'),
                      onPressed: () {

                        Firestore.instance
                            .collection(widget.user.uid)
                            .document(
                            widget.currentList.keys.elementAt(widget.i))
                            .updateData(
                            {"color": pickerColor.value.toString()});

                        setState(
                                () => currentColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Color'),
          color: currentColor,
          textColor: const Color(0xffffffff),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: new Icon(
            Icons.close,
            size: 40.0,
            color: currentColor,
          ),
        ),
      ]),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementTask> listElement = new List();
    int nbIsDone = 0;

    if (widget.user.uid.isNotEmpty) {
      snapshot.data.documents.map<Column>((f) {
        if (f.documentID == widget.currentList.keys.elementAt(widget.i)) {
          f.data.forEach((a, b) {
            if (b.runtimeType == bool) {
              listElement.add(new ElementTask(a, b));
            }
          });
        }
      }).toList();

      listElement.forEach((i) {
        if (i.isDone) {
          nbIsDone++;
        }
      });

      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 50.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          widget.currentList.keys.elementAt(widget.i),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35.0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: Text("Delete: " + widget.currentList.keys.elementAt(widget.i).toString()),
                                content: Text(
                                    "Are you sure you want to delete this list?", style: TextStyle(fontWeight: FontWeight.w400),),
                                actions: <Widget>[
                                  ButtonTheme(
                                    //minWidth: double.infinity,
                                    child: RaisedButton(
                                      elevation: 3.0,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),
                                      color: currentColor,
                                      textColor: const Color(0xffffffff),
                                    ),
                                  ),
                                  ButtonTheme(
                                    //minWidth: double.infinity,
                                    child: RaisedButton(
                                      elevation: 3.0,
                                      onPressed: () {
                                        Firestore.instance
                                            .collection(widget.user.uid)
                                            .document(widget.currentList.keys
                                            .elementAt(widget.i))
                                            .delete();
                                        Navigator.pop(context);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('YES'),
                                      color: currentColor,
                                      textColor: const Color(0xffffffff),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(
                          FontAwesomeIcons.trash,
                          size: 25.0,
                          color: currentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 50.0),
                  child: Row(
                    children: <Widget>[
                      new Text(
                        nbIsDone.toString() +
                            " of " +
                            listElement.length.toString() +
                            " tasks",
                        style: TextStyle(fontSize: 18.0, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 50.0),
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: <Widget>[
                      Container(color: Color(0xFFFCFCFC),child:
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 350,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: listElement.length,
                            itemBuilder: (BuildContext ctxt, int i) {
                              return  Slidable(
                                delegate: new SlidableBehindDelegate(),
                                actionExtentRatio: 0.25,
                                child: GestureDetector(
                                  onTap: () {
                                    Firestore.instance
                                        .collection(widget.user.uid)
                                        .document(widget.currentList.keys
                                            .elementAt(widget.i))
                                        .updateData({
                                      listElement.elementAt(i).name:
                                          !listElement.elementAt(i).isDone
                                    });
                                  },
                                  child: Container(
                                    height: 50.0,
                                    color: listElement.elementAt(i).isDone
                                        ? Color(0xFFF0F0F0)
                                        : Color(0xFFFCFCFC),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 50.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            listElement.elementAt(i).isDone
                                                ? FontAwesomeIcons.checkSquare
                                                : FontAwesomeIcons.square,
                                            color: listElement
                                                    .elementAt(i)
                                                    .isDone
                                                ? currentColor
                                                : Colors.black,
                                            size: 20.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 30.0),
                                          ),
                                          Flexible(
                                            child: Text(
                                              listElement.elementAt(i).name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: listElement
                                                      .elementAt(i)
                                                      .isDone
                                                  ? TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: currentColor,
                                                      fontSize: 27.0,
                                                    )
                                                  : TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 27.0,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                secondaryActions: <Widget>[
                                  new IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () {
                                        Firestore.instance
                                            .collection(widget.user.uid)
                                            .document(widget.currentList.keys
                                            .elementAt(widget.i))
                                            .updateData({
                                          listElement.elementAt(i).name:
                                          ""
                                        });
                                    },
                                  ),
                                ],
                              );
                            }),
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[
          _getToolbar(context),
          Container(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(widget.user.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return new Center(
                          child: CircularProgressIndicator(
                        backgroundColor: currentColor,
                      ));
                    return new Container(
                      child: getExpenseItems(snapshot),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

