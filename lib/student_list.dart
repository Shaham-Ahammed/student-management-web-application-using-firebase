import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'student_add_page.dart';
import 'student_edit.dart';
import 'student_profile.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 125, 233, 255),
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "STUDENT LIST",
          style: GoogleFonts.alatsi(),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: students.orderBy('time', descending: true).snapshots(),
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data.docs.isEmpty) {
              return const Expanded(
                child:  Center(
                  child: Text("ADD STUDENTS TO DISPLAY HERE",
                     
                      style: TextStyle(
                      
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                ),
              );
            } else {
              if (snapshot.data.docs.every((studentSnap) =>
                  !studentSnap['name'].toLowerCase().contains(searchQuery))) {
                return Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 15),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: "search",
                          suffixIcon: Icon(Icons.search)),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child:  Text(
                        "No results found",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ]);
              } else {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 15),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.cyan, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            labelText: "search",
                            suffixIcon: Icon(Icons.search)),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot studentSnap =
                                snapshot.data.docs[index];
                            if (searchQuery.isNotEmpty &&
                                !studentSnap['name']
                                    .toLowerCase()
                                    .contains(searchQuery)) {
                              return Container(); 
                            }
                            return GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => StudentProfile(
                                            image: studentSnap['image url'],
                                            id: studentSnap.id,
                                            name: studentSnap['name'],
                                            age: studentSnap['age'],
                                            phone: studentSnap['phone'],
                                            gender: studentSnap['gender'],
                                          ))),
                              child: Card(
                                color: Colors.cyan[100],
                                margin: const EdgeInsets.all(15),
                                child: ListTile(
                                  title: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      studentSnap['name'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      studentSnap['age'].toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(90)),
                                    child: ClipOval(
                                      child: Image.network(
                                        studentSnap['image url'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentEdit(
                                                        id: studentSnap.id
                                                            .toString(),
                                                        name:
                                                            studentSnap['name'],
                                                        age: studentSnap['age'],
                                                        gender: studentSnap[
                                                            'gender'],
                                                        phone: studentSnap[
                                                            'phone'],
                                                        image: studentSnap[
                                                            'image url'],
                                                      )));
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteData(studentSnap.id,
                                              studentSnap['name'], context);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }
            }
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const StudentAdd()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //for deleting

  Future<void> deleteData(String id, String name, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              "DELETE $name ?",
              style: const TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("NO")),
              TextButton(
                  onPressed: () async {
                    students.doc(id).delete();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("DATA DELTED"),
                        duration: Duration(milliseconds: 800)));
                  },
                  child: const Text(
                    "YES",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
