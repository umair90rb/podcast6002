import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/Dashboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import './const.dart';
import './full_photo.dart';
import './loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  final String peerId;
  // final String peerAvatar;
  final String id;

  Chat({Key key, @required this.peerId, this.id}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // StreamSubscription session;
  // stream(){
  //   session = FirebaseFirestore.instance
  //       .collection('session')
  //       .where('sessionTo', isEqualTo: widget.id)
  //       .snapshots().listen((event) {
  //         if(event.docs.isEmpty) return;
  //         print(Timestamp.now().toDate());
  //         print(event.docs.first['timestamp'].toDate());
  //         Duration dif = Timestamp.now().toDate().difference(event.docs.first['timestamp'].toDate());
  //         print(dif.inSeconds);
  //         if(dif.inSeconds <= 10){
  //           FirebaseFirestore.instance
  //               .collection('session').doc(event.docs.first.id).delete().then((value){
  //              return Navigator.pop(context);
  //           });
  //         }
  //   });
  // }

  @override
  void initState() {
    // stream();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    clipBehavior: Clip.hardEdge,
                    // titlePadding: EdgeInsets.all(10),
                    // contentPadding: EdgeInsets.all(10),
                    title: Text(
                      'Confirm!',
                      style: TextStyle(
                        fontFamily: "Raleway",
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to end session?',
                      style: TextStyle(
                        fontFamily: "Raleway",
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Color(0xFF1A3A77),
                              fontFamily: "Raleway",
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);

                            return Navigator.pop(context);
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Raleway",
                            ),
                          )),
                    ],
                  );
                });
          },
        ),
        backgroundColor: Colors.orange,
        title: Text(
          'Chatting Session',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: "Raleway",
          ),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
        peerId: widget.peerId,
        // peerAvatar: peerAvatar,
        id: widget.id,
      )
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  // final String peerAvatar;
  final String id;

  ChatScreen({Key key, @required this.peerId, @required this.id})
      : super(key: key);

  @override
  State createState() => ChatScreenState(peerId: peerId, id: id);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.id});

  String peerId;
  // String peerAvatar;
  String id;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  String imageUrl;
  File file;
  String fileUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    groupChatId = '';

    isLoading = false;
    // isShowSticker = false;
    imageUrl = '';

    readLocal();
    print(widget.peerId);
    print(widget.id);
    // putRequest();
  }

  putRequest() async {
    return await FirebaseFirestore.instance
        .collection('msgRequest')
        .add({'to': widget.peerId, 'from': widget.id});
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        // isShowSticker = false;
      });
    }
  }

  readLocal() async {
    // prefs = await SharedPreferences.getInstance();
    // id = prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    // FirebaseFirestore.instance
    //     .collection('profile')
    //     .doc(id)
    //     .update({'chattingWith': peerId});

    // setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile(imageFile, imageUrl, 1, 'This file is not an image');
    }
  }

  Future getFile() async {

    FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: false,);
    file = File(result.files.first.path);

    if (file != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile(file, fileUrl, 3, 'This file is not a file');
    }
  }


  Future uploadFile(File file, String url, int type, String error) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot storageTaskSnapshot =
        await uploadTask.whenComplete(() => null);
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      url = downloadUrl;
      setState(() {
        isLoading = false;
        if(type == 3){
          onSendMessage(url, type, file: basename(file.path));
        } else {
          onSendMessage(url, type);
        }
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: error);
    });
  }

  void onSendMessage(String content, int type, {String file}) {
    // type: 0 = text, 1 = image, 2 = sticker, 3 = file
    if (content.trim() != '') {
      textEditingController.clear();
      Map<String, dynamic> data = {
        'idFrom': id,
        'idTo': peerId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': content,
        'type': type
      };
      if(type == 3){
        data['file'] = file;
      }
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          data,
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  buildItem(int index, DocumentSnapshot document, BuildContext context,
      String groupId) {
    if (document.data()['idFrom'] == id) {
      if(document.data()['type'] == 4 && document.data()['idFrom'] != widget.id){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(document.data()['content'])
          ],
        );
      }
      // Right (my message)
      return Row(
        children: <Widget>[
          document.data()['type'] == 0
              // Text
              ? Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(
                      color: primaryColor,
                      fontFamily: "Raleway",
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document.data()['type'] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document.data()['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(
                                      url: document.data()['content'])));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : document.data()['type'] == 3
                  ? InkWell(
            onTap: () async {
              final status = await Permission.storage.request();

              if (status.isGranted) {
                final externalDir = await getExternalStorageDirectory();

                // final id = await FlutterDownloader.enqueue(
                //   url:
                //   document.data()['content'],
                //   savedDir: externalDir.path,
                //   fileName: document.data()['file'],
                //   showNotification: true,
                //   openFileFromNotification: true,
                // );


              } else {
                print("Permission denied");
              }
            },
                    child: Container(
            child: Row(
              children: [
                Icon(Icons.insert_drive_file),
                SizedBox(width:5),
                SizedBox(
                    width: 120,
                    child: Text(
                      document.data()['file'],
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: "Raleway",
                      ),
                    ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: greyColor2,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          ),
                  )
                  : document.data()['type'] != 4 ? Container(
            child: Image.asset(
              'images/${document.data()['content']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          ) : Container(),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      if(document.data()['type'] == 4){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(document.data()['content'])
          ],
        );
      }
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // isLastMessageLeft(index)
                //     ?
                // // Material(
                // //   child: CachedNetworkImage(
                // //     placeholder: (context, url) => Container(
                // //       child: CircularProgressIndicator(
                // //         strokeWidth: 1.0,
                // //         valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                // //       ),
                // //       width: 35.0,
                // //       height: 35.0,
                // //       padding: EdgeInsets.all(10.0),
                // //     ),
                // //     imageUrl: peerAvatar,
                // //     width: 35.0,
                // //     height: 35.0,
                // //     fit: BoxFit.cover,
                // //   ),
                // //   borderRadius: BorderRadius.all(
                // //     Radius.circular(18.0),
                // //   ),
                // //   clipBehavior: Clip.hardEdge,
                // // )
                //     : Container(width: 35.0),
                document.data()['type'] == 0
                    ? Container(
                        child: Text(
                          document.data()['content'],
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Raleway",
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document.data()['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          themeColor),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document.data()['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: document.data()['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : document.data()['type'] == 3
                    ? InkWell(
                  onTap: () async {
                    final status = await Permission.storage.request();

                    if (status.isGranted) {
                      final externalDir = await getExternalStorageDirectory();

                      // final id = await FlutterDownloader.enqueue(
                      //   url:
                      //   document.data()['content'],
                      //   savedDir: externalDir.path,
                      //   fileName: document.data()['file'],
                      //   showNotification: true,
                      //   openFileFromNotification: true,
                      // );

                    } else {
                      print("Permission deined");
                    }
                  },
                      child: Container(
                  child: Row(
                      children: [
                        Icon(Icons.insert_drive_file),
                        SizedBox(width:5),
                        SizedBox(
                          width: 120,
                          child: Text(
                            document.data()['file'],
                            style: TextStyle(
                              color: primaryColor,
                              fontFamily: "Raleway",
                            ),
                          ),
                        ),
                      ],
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                        color: greyColor2,
                        borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                        right: 10.0),
                ),
                    ) : document.data()['type'] != 4 ? Container(
                            child: Image.asset(
                              'images/${document.data()['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ) : Container(),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document.data()['timestamp']))),
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 12.0,
                        fontFamily: "Raleway",
                      ),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }


  Future<bool> onBackPress(BuildContext context) {

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            clipBehavior: Clip.hardEdge,
            // titlePadding: EdgeInsets.all(10),
            // contentPadding: EdgeInsets.all(10),
            title: Text(
              'Confirm!',
              style: TextStyle(
                fontFamily: "Raleway",
              ),
            ),
            content: Text(
              'Are you sure you want to end session?',
              style: TextStyle(
                fontFamily: "Raleway",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Color(0xFF1A3A77),
                      fontFamily: "Raleway",
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('profile').doc(id).update({
                      'chattingWith': null,
                    });
                    Navigator.pop(context);
                    return Navigator.pop(context);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Raleway",
                    ),
                  )),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<User>(context);
    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance
    //       .collection('session')
    //       .where('sessionTo', isEqualTo: widget.id)
    //       .snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       QuerySnapshot query = snapshot.data;
    //       List<DocumentSnapshot> docs = query.docs;
    //       if (docs.isNotEmpty) {
    //         FirebaseFirestore.instance
    //             .collection('session')
    //             .doc(docs.first.id)
    //             .delete()
    //             .then((value) {
    //           return Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => Dashboard(user),
    //             ),
    //           );
    //         });
    //       }
    //     }
        return WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  buildListMessage(),
                  buildInput(),
                ],
              ),

              // Loading
              buildLoading()
            ],
          ),
          onWillPop: () => onBackPress(context),
        );

    // );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: getFile,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    color: greyColor,
                    fontFamily: "Raleway",
                  ),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  // .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else if (snapshot.data != null) {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(
                        index, snapshot.data.docs[index], context, groupChatId),
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                } else {
                  return Center(
                    child: Text(
                      'No msg yet!',
                      style: TextStyle(
                        fontFamily: "Raleway",
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }

  @override
  void dispose() {
    onSendMessage('Session Ended by Mentor', 4);
    listScrollController.dispose();
    super.dispose();
  }

}
