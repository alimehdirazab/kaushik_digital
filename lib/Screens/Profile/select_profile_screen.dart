import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Screens/Profile/edit_profile_screen.dart';
import 'package:kaushik_digital/Screens/Profile/widgets/custom_select_profile.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';

class SelectProfileScreen extends StatelessWidget {
  const SelectProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: h * 0.07,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Select Profile",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 23,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  SizedBox(
                      height: h * 0.7,
                      child: CustomSelectProfiles(
                          h: h, name: 'Drashti', image: profileImage)),
                  // SizedBox(
                  //   height: h * 0.02,
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen()));
                          // Handle login logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: GoogleFonts.namdhinggo(
                            textStyle:
                                TextStyle(fontSize: 18, color: whiteColor),
                          ),
                        )),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
