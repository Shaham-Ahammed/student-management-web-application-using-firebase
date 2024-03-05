// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'student_list.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StudentAdd extends StatefulWidget {
  const StudentAdd({Key? key}) : super(key: key);

  @override
  State<StudentAdd> createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAdd> {
  final CollectionReference student =
      FirebaseFirestore.instance.collection('students');

  Future<String?> uploadImage(Uint8List imageData, String fileName) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('student images')
          .child(fileName);
      final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(imageData, metadata);

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
     
      return null;
    }
  }

  Future<void> selectImage() async {
   
    var picked = await FilePicker.platform.pickFiles();

    if (picked != null) {
    
      setState(() {
        imagePath = picked.files.first.name;
        selectedImageInBytes = picked.files.first.bytes;
        _isPhotoSelected = true;
        photoerrorVisible = false;
      });
    }
  }

  void addStudent(
      String name, String age, String phone, String gender, Timestamp time,String url) {
    final data = {
      'name': name,
      'age': age,
      'phone': phone,
      'gender': gender,
      'time': time,
      'image url':url
    };
    student.add(data);
  }

  String? groupValue;
  String? imagePath;
  Uint8List? selectedImageInBytes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isPhotoSelected = false;
  bool photoerrorVisible = false;
  bool genderErrorVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: Text(
          "ADD STUDENT",
          style: GoogleFonts.alatsi(),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
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
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.cyan,
            ),
            child: selectedImageInBytes == null
                ? Image.network(
                    'https://st4.depositphotos.com/11574170/25191/v/450/depositphotos_251916955-stock-illustration-user-glyph-color-icon.jpg',
                    fit: BoxFit.cover,
                  )
                : Image.memory(selectedImageInBytes!,  fit: BoxFit.cover,),
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
          child:Icon(Icons.add_a_photo),
        ),
      ],
    ),
          const SizedBox(
            height: 15,
          ),
          if (photoerrorVisible && imagePath == null)
            const Text(
              'Please add a photo',
              style: TextStyle(color: Colors.red),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    ],
                    maxLength: 2,
                    controller: ageController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              style: myStyle(12, FontWeight.bold, Colors.black))
                        ],
                      ),
                    ],
                  ),
                  if (genderErrorVisible && groupValue == null)
                    const Text(
                      'Please select a gender',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan)),
              onPressed: () async {
                if (!_isPhotoSelected) {
                  setState(() {
                    photoerrorVisible = true;
                  });
                }
                if (groupValue == null) {
                  setState(() {
                    genderErrorVisible = true;
                  });
                }
                if (_formKey.currentState!.validate() &&
                    _isPhotoSelected == true &&
                    groupValue != null) {
                       showLoadingDialog(context);
                  final Timestamp time = Timestamp.now();
                  String? url =
                      await uploadImage(selectedImageInBytes!, imagePath!);
                  addStudent(nameController.text, ageController.text,
                      phoneController.text, groupValue!, time,url!);
                       Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const StudentList()),
                      (route) => false);
                } else {
                  return;
                }
              },
              child: Text(
                "ADD STUDENT",
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
       child:  CircularProgressIndicator(color: Colors.blue,),
     );
   },
 );
}
 
}

myStyle(double size, FontWeight weight, Color clr) {
  return TextStyle(fontSize: size, fontWeight: weight, color: clr);
}
