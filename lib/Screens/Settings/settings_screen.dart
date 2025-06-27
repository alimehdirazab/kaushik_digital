import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Screens/Account%20Screen/widgets/custom_listtile.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: h * 0.2,
                padding: EdgeInsets.only(top: h * 0.08, left: 15, right: 15),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                          25,
                        ),
                        bottomRight: Radius.circular(25))),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Settings",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: whiteColor),
                      ),
                    ),
                    Switch(
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = value;
                        });
                      },
                      activeColor: whiteColor,
                      activeTrackColor: Colors.black,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: whiteColor,
                    ),
                  ],
                )),
              ),
              SizedBox(
                height: h * 0.08,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: h * 0.03),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 225, 227, 230)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomListtile(
                      icon: Icons.location_on_outlined,
                      text: "Location",
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    CustomListtile(
                      icon: Icons.history,
                      text: "History",
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    CustomListtile(
                      icon: Icons.lock_outline,
                      text: "Change Password",
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    CustomListtile(
                      icon: Icons.email_outlined,
                      text: "Change Email or Phone",
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    CustomListtile(
                      icon: Icons.delete_forever_outlined,
                      text: "Delete Account",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.08,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
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
                        'Log Out',
                        style: GoogleFonts.namdhinggo(
                          textStyle: TextStyle(fontSize: 18, color: whiteColor),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
    //
  }
}
