import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Screens/Profile/add_profile_screen.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';

class CustomSelectProfiles extends StatelessWidget {
  final String name;
  final String image;
  const CustomSelectProfiles({
    super.key,
    required this.h,
    required this.name,
    required this.image,
  });

  final double h;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of items per row
        crossAxisSpacing: 10, // Horizontal spacing
        mainAxisSpacing: 10, // Vertical spacing
      ),
      itemCount: 2, // Number of items including the black CircleAvatar
      itemBuilder: (context, index) {
        if (index == 1) {
          // Add a black CircleAvatar as the last item
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProfileScreen()));
                },
                child: CircleAvatar(
                  backgroundColor: whiteColor,
                  backgroundImage: AssetImage(addProfileImage),
                  radius: 55,
                ),
              ),
              SizedBox(
                height: h * 0.005,
              ),
              Text("Add Profile",
                  style: GoogleFonts.abel(
                    textStyle: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          );
        }
        // Regular CircleAvatar items
        return Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              backgroundImage: AssetImage(
                image,
              ),
              radius: 55,
            ),
            SizedBox(
              height: h * 0.005,
            ),
            Text(name,
                style: GoogleFonts.abel(
                  textStyle: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        );
      },
      padding: const EdgeInsets.all(10),
    );
  }
}
