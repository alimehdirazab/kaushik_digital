import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Screens/Login/widgets/custom_textfield.dart';
import 'package:kaushik_digital/Screens/Profile/widgets/custom_dob_textfield.dart';
import 'package:kaushik_digital/Screens/Profile/widgets/gender_selection.dart';
import 'package:kaushik_digital/Screens/Profile/widgets/language_selection_container.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';

import '../Navbar/navbar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int selectedIndex = -1; // -1 means no avatar is selected
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final List<String> items = [
      "Hindi",
      "Urdu",
      "English",
      "Gujrati",
      "Punjabi",
      "Russian",
      "Telegu",
      "Marathi",
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: h * 0.07,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Edit Your Profile",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 19,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              padding: const EdgeInsets.all(10),
              child: Row(
                children: List.generate(10, (index) {
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: CircleAvatar(
                        backgroundColor:
                            isSelected ? Colors.green : Colors.blue,
                        radius: isSelected
                            ? 45
                            : 40, // Increased radius if selected
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomTextField(
                labelText: "Name",
                controller: nameController,
                textColor: Colors.black,
                borderColor: Colors.black,
                labelColor: Colors.black,
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            DateOfBirthPicker(
              controller: dobController,
              onTap: () {},
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Text(
                    "Select Your Gender",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: w * 0.02,
                  ),
                  const Icon(Icons.info_outline_rounded)
                ],
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GenderSelection(
                    name: 'Male',
                    onTap: () {},
                  ),
                  GenderSelection(
                    name: 'Female',
                    onTap: () {},
                  ),
                  GenderSelection(
                    name: 'Prefer Not To Say',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Choose Your Preffered Content Language",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: h * 0.013),
              child: Wrap(
                spacing: 10, // Horizontal spacing between items
                runSpacing: 10, // Vertical spacing between rows
                children: items.map((item) {
                  return LanguageSelectionContainer(name: item, onTap: () {});
                }).toList(),
              ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const MyNavBar()));
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
                      'Update',
                      style: GoogleFonts.namdhinggo(
                        textStyle: TextStyle(fontSize: 18, color: whiteColor),
                      ),
                    )),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
