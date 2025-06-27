import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_movie_container.dart';

import '../../utils/constants/constants.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    List imageList = [
      "assets/images/poster1.jpg",
      "assets/images/poster2.jpg",
      "assets/images/poster3.jpg",
    ];

    List cricketList = [
      "assets/images/cricket_poster1.jpg",
      "assets/images/cricket_poster2.jpg",
      "assets/images/cricket_poster3.jpg",
    ];
    List tvList = [
      "assets/images/tv_poster1.jpg",
      "assets/images/tv_poster2.jpg",
      "assets/images/tv_poster3.jpg",
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: Brightness.dark, // For white icons
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
          body: Padding(
            padding:
                const EdgeInsets.only(top: 26, left: 8, right: 8, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: h * 0.07),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: whiteColor,
                            backgroundImage: AssetImage(profileImage),
                            radius: 55,
                          ),
                          SizedBox(
                            height: h * 0.005,
                          ),
                          Text("Drishti",
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 5),
                    child: Text("My List",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    height: h * 0.3,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageList.length, // Number of rows
                        itemBuilder: (context, rowIndex) {
                          return CustomMoviesContainer(
                            h: h * 0.7,
                            moviePoster: imageList[rowIndex],
                            w: w * 0.65,
                            onTap: () {},
                            movieName: '',
                            moviePrice: 0,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 5),
                    child: Text("Continue Watching",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    height: h * 0.3,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cricketList.length, // Number of rows
                        itemBuilder: (context, rowIndex) {
                          return CustomMoviesContainer(
                            h: h * 0.7,
                            moviePoster: cricketList[rowIndex],
                            w: w * 0.65,
                            onTap: () {},
                            movieName: '',
                            moviePrice: 0,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 5),
                    child: Text("Trailer You've Watched",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    height: h * 0.3,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageList.length, // Number of rows
                        itemBuilder: (context, rowIndex) {
                          return CustomMoviesContainer(
                            h: h * 0.7,
                            moviePoster: imageList[rowIndex],
                            w: w * 0.65,
                            onTap: () {},
                            movieName: '',
                            moviePrice: 0,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 5),
                    child: Text("Continue Watching",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    height: h * 0.3,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tvList.length, // Number of rows
                        itemBuilder: (context, rowIndex) {
                          return CustomMoviesContainer(
                            h: h * 0.7,
                            moviePoster: tvList[rowIndex],
                            w: w * 0.65,
                            onTap: () {},
                            movieName: '',
                            moviePrice: 0,
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
