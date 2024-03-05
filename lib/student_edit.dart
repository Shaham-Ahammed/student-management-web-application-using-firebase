import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:webapp_student_list/student_list.dart';

class StudentEdit extends StatefulWidget {
  final String id;
  final String name;
  final String age;
  final String image;
  final String gender;
  final String phone;
  const StudentEdit(
      {super.key,
      required this.image,
      required this.id,
      required this.name,
      required this.age,
      required this.gender,
      required this.phone});

  @override
  State<StudentEdit> createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? imagePath;
  String? groupValue;
  Uint8List? imageInBytes;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    ageController = TextEditingController(text: widget.age);
    groupValue = widget.gender;
    phoneController = TextEditingController(text: widget.phone);

    super.initState();
  }

  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  updateStudent(String id, [String? url]) {
    final data = {
      'name': nameController.text,
      'age': ageController.text,
      'gender': groupValue,
      'phone': phoneController.text,
      if (url != null) 'image url': url
    };
    students.doc(id).update(data).then((value) {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const StudentList()),
          (route) => false);
    });
  }

  selectImage() async {
    var image = await FilePicker.platform.pickFiles();
    if (image != null) {
      setState(() {
        imageInBytes = image.files.first.bytes;
        imagePath = image.files.first.name;
      });
    }
  }

  Future<String?> uploadImage(Uint8List imageData, String fileName) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('student images')
          .child(fileName);
      final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(imageData, metadata);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: Text(
          "EDIT STUDENT",
          style: GoogleFonts.alatsi(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: Container(
                  width:160,
                  height: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                  child: imageInBytes == null
                      ? Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(imageInBytes!,fit: BoxFit.cover,),
                ),
              ),
               const Positioned(
          right: 0,
          top: 120,
          child: CircleAvatar(
            radius: 17,
            backgroundColor: Color.fromARGB(255, 10, 199, 251),
          ),
        ),
        const Positioned(
            right: 5,
          top: 127,
          child: Icon(Icons.edit),
        ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Form(
            key: _formKey,
            child: SizedBox(
                width: double.infinity,
                height: 360,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: "Name"),
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      validator: (value) {
                        if (value == "") {
                          return "please enter your name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: "Age"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
                      controller: ageController,
                      validator: (value) {
                        if (value == "") {
                          return "please enter your age";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: "Phone Number"),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      controller: phoneController,
                      validator: (value) {
                        if (value == "") {
                          return "please enter your phone Number";
                        } else if (value!.length != 10) {
                          return "phone number not valid";
                        } else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select Gender :',
                          style: myStyle(16, FontWeight.bold, Colors.black),
                        ),
                        Row(
                          children: [
                            Radio(
                                activeColor: Colors.red,
                                value: 'Male',
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    groupValue = value;
                                  });
                                }),
                            Text('Male',
                                style:
                                    myStyle(12, FontWeight.bold, Colors.black)),
                            Radio(
                                activeColor: Colors.red,
                                value: 'Female',
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    groupValue = value;
                                  });
                                }),
                            Text('Female',
                                style:
                                    myStyle(12, FontWeight.bold, Colors.black))
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  showLoadingDialog(context);
                  if (imageInBytes != null) {
                    String? imageUrl =
                        await uploadImage(imageInBytes!, imagePath!);
                    updateStudent(widget.id, imageUrl!);
                  } else {
                    updateStudent(widget.id);
                  }
                }
              },
              child: Text(
                "EDIT STUDENT",
                style: GoogleFonts.akayaKanadaka(),
              ))
        ]),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
      },
    );
  }
}

myStyle(double size, FontWeight weight, Color clr) {
  return TextStyle(fontSize: size, fontWeight: weight, color: clr);
}
