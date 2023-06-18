import 'dart:io';

import 'package:blogapp60211/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  bool showSpinner = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final blogRef = FirebaseDatabase.instance.ref().child('Blogs');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  void dialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImageCamera();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getImageGallery();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Gallery"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImageGallery() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print("no image selected");
      }
    });
  }

  Future getImageCamera() async {
    final PickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print("no image selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload your blogs"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: _image != null
                          ? ClipRect(
                              child: Image.file(
                                _image!.absolute,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.purple,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLength: 15,
                        decoration: InputDecoration(
                            hintText: 'Enter your title',
                            label: Text("Title"),
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                        validator: (value) {
                          return value!.isEmpty ? 'Enter your title' : null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: descController,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 4,
                        maxLength: 150,
                        decoration: InputDecoration(
                            hintText: 'Enter your description',
                            label: Text("Description"),
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Enter your description'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RoundButton(
                    title: "Upload Blog",
                    onpress: () async {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          int date = DateTime.now().microsecondsSinceEpoch;
                          firebase_storage.Reference ref = firebase_storage
                              .FirebaseStorage.instance
                              .ref('/blogApp$date');
                          UploadTask uploadTask = ref.putFile(_image!.absolute);
                          await Future.value(uploadTask);
                          var newUrl = await ref.getDownloadURL();

                          final User? user = _auth.currentUser;
                          blogRef
                              .child('Blog List')
                              .child(date.toString())
                              .set({
                            'bId': date.toString(),
                            'bImage': newUrl.toString(),
                            'bTime': date.toString(),
                            'bTitle': titleController.text.toString(),
                            'bDescription': descController.text.toString(),
                            'uEmail': user!.email.toString(),
                            'uId': user.uid.toString(),
                          }).then((value) {
                            toastMessage("Blog Published");
                            setState(() {
                              showSpinner = false;
                            });
                          }).onError((error, stackTrace) {
                            toastMessage(error.toString());
                            setState(() {
                              showSpinner = false;
                            });
                          });
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          toastMessage(e.toString());
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.purple,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
