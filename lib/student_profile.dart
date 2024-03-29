import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentProfile extends StatelessWidget {
  final String id;
  final String name;
  final String age;
  final String phone;
  final String gender;
  final String image;

  const StudentProfile({
    super.key,
    required this.image,
    required this.id,
    required this.name,
    required this.age,
    required this.phone,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[200],
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                   backgroundImage: NetworkImage(image),
                  radius: 70,
                ),
                const SizedBox(
                  height: 30,
                ),
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.cyan[400],
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(8)),
                            width: double.infinity,
                            child: Text(
                              "  NAME                      :  ${name.toUpperCase()}",
                              style: GoogleFonts.oswald(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(8)),
                            width: double.infinity,
                            child: Text(
                              "  AGE                         :  $age",
                              style: GoogleFonts.oswald(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(8)),
                            width: double.infinity,
                            child: Text(
                              "  GENDER                  :  ${gender.toUpperCase()}",
                              style: GoogleFonts.oswald(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(8)),
                            width: double.infinity,
                            child: Text(
                              " PHONE NUMBER     :  $phone",
                              style: GoogleFonts.oswald(),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
