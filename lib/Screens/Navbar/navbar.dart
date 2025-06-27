// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Screens/Account%20Screen/account_screen.dart';
import 'package:kaushik_digital/Screens/Home/home_screen.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';

import '../My List/my_list_screen.dart';
import '../Search Screen/search_screen.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  int currentIndex = 0;
  List<Widget> screens = [
    const MyHomeScreen(),
    const SearchScreen(),
    const MyListScreen(),
    const AccountScreen(),
  ];
  final PageController pageController = PageController(initialPage: 0);

  Future<bool> _onWillPop() async {
    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
        pageController.jumpToPage(0);
      });
      return false;
    } else {
      bool? exit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Exit App"),
          content: const Text("Do you really want to exit the app?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text("Exit"),
            ),
          ],
        ),
      );
      return exit ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: BottomAppBar(
          elevation: 3,
          height: MediaQuery.of(context).size.height * 0.1,
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                      pageController.jumpToPage(0);
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.home_outlined,

                        size: h * 0.038,
                        color: currentIndex == 0
                            ? primaryColor
                            : const Color.fromARGB(255, 129, 129, 129),

                        // color: Colors.amber,
                      ),
                      // const SizedBox(
                      //   height: 2,
                      // ),
                      Text("Home",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: h * 0.016,
                              fontWeight: FontWeight.w900,
                              color: currentIndex == 0
                                  ? primaryColor
                                  : const Color.fromARGB(255, 129, 129, 129),
                            ),
                          ))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                      pageController.jumpToPage(1);
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.search,
                        size: h * 0.038,
                        color: currentIndex == 1
                            ? primaryColor
                            : const Color.fromARGB(255, 129, 129, 129),
                      ),
                      // const SizedBox(
                      //   height: 2,
                      // ),
                      Text("Search",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: h * 0.016,
                              fontWeight: FontWeight.w900,
                              color: currentIndex == 1
                                  ? primaryColor
                                  : const Color.fromARGB(255, 129, 129, 129),
                            ),
                          )),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 2;
                      pageController.jumpToPage(2);
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/news_icon.png',
                        height: h * 0.038,
                        width: 28,
                        color: currentIndex == 2
                            ? primaryColor
                            : const Color.fromARGB(255, 129, 129, 129),

                        // color: Colors.amber,
                      ),
                      Text("My List",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: h * 0.016,
                              fontWeight: FontWeight.w900,
                              color: currentIndex == 2
                                  ? primaryColor
                                  : const Color.fromARGB(255, 129, 129, 129),
                            ),
                          ))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 3;
                      pageController.jumpToPage(3);
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.account_circle_outlined, size: h * 0.038,
                        color: currentIndex == 3
                            ? primaryColor
                            : const Color.fromARGB(255, 129, 129, 129),

                        // color: Colors.amber,
                      ),
                      Text("Account",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: h * 0.016,
                              fontWeight: FontWeight.w900,
                              color: currentIndex == 3
                                  ? primaryColor
                                  : const Color.fromARGB(255, 129, 129, 129),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: screens,
        ),
        //  screens[currentIndex],
      ),
    );
  }
}
