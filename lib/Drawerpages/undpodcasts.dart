import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/Drawerpages/podcastsection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/db_services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:io' as io;

class Updatendeletepodcasts extends StatefulWidget {
  @override
  _UpdatendeletepodcastsState createState() => _UpdatendeletepodcastsState();
}

class _UpdatendeletepodcastsState extends State<Updatendeletepodcasts> {
  DbServices db = DbServices();
  List<DocumentSnapshot> podcast = List();
  PersistentBottomSheetController _controller; // <------ Instance variable
  final _scaffoldKey =
      GlobalKey<ScaffoldState>(); // <---- Another instance variable
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.orange,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Edit Podcasts",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Raleway",
            ),
          ),
        ),
        body: FutureBuilder(
          future: db.getSnapshotWithQuery('podcasts', 'uid', [user.uid]),
          builder: (context, snapshot) {
            ProgressDialog dialog = ProgressDialog(context);
            dialog.style(
                message: 'Please wait...',
                progressTextStyle: TextStyle(
                  fontFamily: "Raleway",
                ));
            if (snapshot.hasData) {
              podcast = snapshot.data;
              if (podcast.isEmpty) {
                return Center(
                  child: Text(
                    "You have no podcast yet!",
                    style: TextStyle(
                      fontFamily: "Raleway",
                    ),
                  ),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    TextEditingController name =
                        TextEditingController(text: podcast[index]['name']);
                    TextEditingController description = TextEditingController(
                        text: podcast[index]['description']);
                    PlatformFile thumbnail;

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 50,
                            child: podcast[index]['thumbnail'] == null
                                ? Icon(Icons.image)
                                : null,
                            backgroundImage: podcast[index]['thumbnail'] == null
                                ? null
                                : NetworkImage(podcast[index]['thumbnail']),
                          ),
                          title: Text(podcast[index]['name'] ?? ''),
                          subtitle: Text(podcast[index]['description'] ?? ''),
                          trailing: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      // actions: <Widget>[
                      //   IconSlideAction(
                      //     caption: 'Archive',
                      //     color: Colors.blue,
                      //     icon: Icons.archive,
                      //     onTap: () => Fluttertoast.showToast(msg: 'Archive'),
                      //   ),
                      //   IconSlideAction(
                      //     caption: 'Share',
                      //     color: Colors.indigo,
                      //     icon: Icons.share,
                      //     onTap: () => Fluttertoast.showToast(msg: 'Share'),
                      //   ),
                      // ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.black45,
                          icon: Icons.edit,
                          onTap: () async {
                            _controller =
                                await _scaffoldKey.currentState.showBottomSheet(
                              (context) {
                                return SingleChildScrollView(
                                  child: Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(40.0),
                                            topRight:
                                                const Radius.circular(50.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              FilePickerResult result =
                                                  await FilePicker.platform
                                                      .pickFiles();
                                              if (result != null) {
                                                _controller.setState(() {
                                                  thumbnail =
                                                      result.files.first;
                                                });
                                              } else {
                                                return Fluttertoast.showToast(
                                                    msg: 'No file selected!');
                                              }
                                            },
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundImage: thumbnail == null
                                                  ? NetworkImage(podcast[index]
                                                      ['thumbnail'])
                                                  : FileImage(
                                                      io.File(thumbnail.path)),
                                            ),
                                          ),
                                          makeInput(name, label: 'Title'),
                                          makeInput(description,
                                              label: 'Description'),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  new FlatButton(
                                                    onPressed: () async {
                                                      if (thumbnail == null &&
                                                          name.text ==
                                                              podcast[index]
                                                                  ['name'] &&
                                                          description.text ==
                                                              podcast[index][
                                                                  'description']) {
                                                        return Fluttertoast
                                                            .showToast(
                                                                msg:
                                                                    'Nothing to update!');
                                                      }
                                                      ProgressDialog dialog =
                                                          ProgressDialog(
                                                              context);
                                                      dialog.style(
                                                          message:
                                                              "Please wait...",
                                                          progressTextStyle:
                                                              TextStyle(
                                                            fontFamily:
                                                                "Raleway",
                                                          ));
                                                      await dialog.show();
                                                      String podcastUrl;
                                                      if (thumbnail == null) {
                                                        podcastUrl =
                                                            podcast[index]
                                                                ['thumbnail'];
                                                      } else {
                                                        db
                                                            .uploadFile(
                                                                'thumbnails',
                                                                io.File(
                                                                    thumbnail
                                                                        .path))
                                                            .then((value) =>
                                                                podcastUrl =
                                                                    value);
                                                        await db.deleteFile(
                                                            podcast[index]
                                                                ['thumbnail']);
                                                      }
                                                      db.updateDoc('podcasts',
                                                          podcast[index].id, {
                                                        'name': name.text,
                                                        'description':
                                                            description.text,
                                                        'podcast': podcastUrl
                                                      }).then((value) async {
                                                        await dialog.hide();
                                                        podcast[index].data()[
                                                            'name'] = name.text;
                                                        podcast[index].data()[
                                                                'description'] =
                                                            description.text;
                                                        podcast[index].data()[
                                                                'podcast'] =
                                                            podcastUrl;
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                        return Fluttertoast
                                                            .showToast(
                                                                msg:
                                                                    'Podcast Updated!');
                                                      });
                                                    },
                                                    child: new Text("Update",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "Raleway",
                                                        )),
                                                    color: Colors.blueAccent
                                                        .withOpacity(0.8),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            ProgressDialog dialog = ProgressDialog(context);
                            dialog.style(
                                message: 'Please wait...',
                                progressTextStyle: TextStyle(
                                  fontFamily: "Raleway",
                                ));
                            await dialog.show();
                            try {
                              db
                                  .deleteFile(podcast[index]['thumbnail'])
                                  .then((value) {
                                db
                                    .deleteFile(podcast[index]['podcast'])
                                    .then((value) {
                                  db
                                      .deleteDoc('podcasts', podcast[index].id)
                                      .then((value) async {
                                    podcast.removeAt(index);
                                    await dialog.hide();
                                    setState(() {});
                                  });
                                });
                              });
                              // Navigator.pop(context);  // pop current page
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => Updatendeletepodcasts()));
                            } on Exception catch (error) {
                              await dialog.hide();
                              print(error);
                            }
                          },
                        ),
                      ],
                    );
                  },
                  itemCount: podcast.length);
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            // ignore: missing_return
            // dialog.show().then((value){return Container();});
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}

Widget makeInput(controller, {label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
          fontFamily: "Raleway",
        ),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        style: TextStyle(
          fontFamily: "Raleway",
        ),
        onChanged: (value) => {},
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.orange,
        decoration: InputDecoration(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])),
        ),
      ),
      SizedBox(
        height: 30,
      ),
    ],
  );
}
