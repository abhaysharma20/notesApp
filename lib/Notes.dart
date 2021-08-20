import 'dart:io';

import 'package:NotesApp/Payment.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/NotesPage.dart';

class NotesPage extends StatefulWidget {
  NotesPage({Key key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var _formKey = GlobalKey<FormState>();
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    getHeading();
    getDescription();
    notesDescriptionMaxLength =
        notesDescriptionMaxLines * notesDescriptionMaxLines;
  }

  @override
  void dispose() {
    noteDescriptionController.dispose();
    noteHeadingController.dispose();
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }
  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
  Future<File> writeContent() async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(noteHeading.first);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: notesHeader(context),
      ),
      body: noteHeading.length > 0
          ? buildNotes()
          : Center(
              child: Text(
              "Add Notes...",
              style: TextStyle(fontSize: 20, color: Colors.black45),
            )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            FloatingActionButton(
              tooltip: "Add a Note",
              child: GestureDetector(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onTap: () {
                  _settingModalBottomSheet(context);
                },
              ),
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              tooltip: "Payment",
              child: GestureDetector(
                child: Icon(
                  Icons.payment,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentsPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveHeading() {
    String heading = noteHeadingController.text;
    setHeading(heading);
  }

  saveDescription() {
    String description = noteDescriptionController.text;
    setDescription(description);
  }

  Future<bool> setHeading(String heading) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("heading", noteHeadingController.text);
    return prefs.commit();
  }

  Future<String> getHeading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String heading = prefs.getString("heading");
    return heading;
  }

  Future<bool> setDescription(String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("description", noteDescriptionController.text);
    return prefs.commit();
  }

  Future<String> getDescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String description = prefs.getString("description");
    return description;
  }

  Widget buildNotes() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: new ListView.builder(
        itemCount: noteHeading.length,
        itemBuilder: (context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.5),
            child: new Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) async {
                // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                setState(() {
                  // sharedPreferences.clear();
                  deletedNoteHeading = noteHeading[index];
                  deletedNoteDescription = noteDescription[index];
                  noteHeading.removeAt(index);
                  noteDescription.removeAt(index);
                  Scaffold.of(context).showSnackBar(
                    new SnackBar(
                      backgroundColor: noteMarginColor[(index % noteMarginColor.length).floor()],
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text(
                            "Note Deleted",
                            style: TextStyle(),
                          ),
                          deletedNoteHeading != ""
                              ? GestureDetector(
                                  onTap: () async {
                                    print("undo");

                                    saveHeading();
                                    saveDescription();

                                    setState(() {
                                      if (deletedNoteHeading != "") {
                                        noteHeading.add(deletedNoteHeading);
                                        noteDescription
                                            .add(deletedNoteDescription);
                                      }
                                      deletedNoteHeading = "";
                                      deletedNoteDescription = "";
                                    });
                                  },
                                  child: new Text(
                                    "Undo",
                                    style: TextStyle(),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  );
                });
              },
              background: ClipRRect(
                borderRadius: BorderRadius.circular(5.5),
                child: Container(
                  color: noteMarginColor[(index % noteMarginColor.length).floor()],
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              secondaryBackground: ClipRRect(
                borderRadius: BorderRadius.circular(5.5),
                child: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: noteList(index),
            ),
          );
        },
      ),
    );
  }

  Widget noteList(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.5),
      child: GestureDetector(onTap: (){},
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: noteColor[(index % noteColor.length).floor()],
            borderRadius: BorderRadius.circular(5.5),
          ),
          height: 120,
          child: Center(
            child: Row(
              children: [
                new Container(
                  color:
                      noteMarginColor[(index % noteMarginColor.length).floor()],
                  width: 3.5,
                  height: double.infinity,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Text(
                            noteHeading[index],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.00,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.5,
                        ),
                        Flexible(
                          child: Container(
                            height: double.infinity,
                            child: AutoSizeText(
                              "${(noteDescription[index])}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.00,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 50,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 100, top: 50),
                child: new Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add a New Note",
                          style: TextStyle(
                            fontSize: 20.00,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            writeContent();
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                noteHeading.add(noteHeadingController.text);
                                noteDescription
                                    .add(noteDescriptionController.text);
                                noteHeadingController.clear();
                                noteDescriptionController.clear();
                              });
                              Navigator.pop(context);
                            }

                            if (noteHeadingController.text.isNotEmpty &&
                                noteDescriptionController.text.isNotEmpty) {
                              Fluttertoast.showToast(
                                msg: 'Note Added Successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            }
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 20.00,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.blueAccent,
                      thickness: 2.5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLength: notesHeaderMaxLength,
                      controller: noteHeadingController,
                      decoration: InputDecoration(
                        hintText: "Note Heading",
                        hintStyle: TextStyle(
                          fontSize: 15.00,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(Icons.text_fields),
                      ),
                      validator: (String noteHeading) {
                        if (noteHeading.isEmpty) {
                          return "Please enter Note Heading";
                        } else if (noteHeading.startsWith("  ")) {
                          return "Avoid whitespaces in Notes Heading";
                        }
                        return null;
                      },
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context)
                            .requestFocus(textSecondFocusNode);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        margin: EdgeInsets.all(1),
                        height: 6 * 24.0,
                        child: TextFormField(
                            focusNode: textSecondFocusNode,
                            maxLines: notesDescriptionMaxLines,
                            maxLength: notesDescriptionMaxLength,
                            controller: noteDescriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                fontSize: 15.00,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            validator: (String noteDescription) {
                              if (noteDescription.isEmpty) {
                                return "Please enter Note Desc";
                              } else if (noteDescription.startsWith("  ")) {
                                return "Please avoid whitespaces";
                              }
                              return null;
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget notesHeader(context) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 20,
      left: 10,
      right: 10,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.notes,
              color: Colors.black45,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "My Notes",
              style: TextStyle(
                color: Colors.black38,
                fontSize: 25.00,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.black26,
          thickness: 2.5,
        ),
      ],
    ),
  );
}
