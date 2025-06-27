// ignore: file_names
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_movie_container.dart';
import 'package:kaushik_digital/Services/home_service.dart';

class ShowDetailScreen extends StatefulWidget {
  final int id;

  const ShowDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<ShowDetailScreen> createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  HomeService homeService = HomeService();
  @override
  Widget build(BuildContext context) {
    List tvList = [
      "assets/images/tv_poster1.jpg",
      "assets/images/tv_poster2.jpg",
      "assets/images/tv_poster3.jpg",
    ];
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: homeService.fetchShowDetails(
                  showId: widget.id, context: context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something Went Wrong '));
                } else if (snapshot.data!.showName.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final show = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: w,
                          height: h * 0.4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                show.showPoster,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  color: Colors.white,
                                  iconSize: 28,
                                  onPressed: () {
                                    // Handle back button action
                                  },
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.share),
                                  color: Colors.white,
                                  iconSize: 28,
                                  onPressed: () {
                                    // Handle share action
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 15),
                                child: Text(
                                  show.showName,
                                  style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                )),
                            // Spacer(),
                            Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                        right: 15, top: 10),
                                    child: GestureDetector(
                                      child: const Icon(
                                        Icons.thumb_up_outlined,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    )),
                                Container(
                                    margin: const EdgeInsets.only(
                                        right: 15, top: 10),
                                    child: GestureDetector(
                                      child: const Icon(
                                        Icons.download_outlined,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              const Text(
                                "Gener :",
                                style: TextStyle(fontSize: 16),
                              ),
                              Wrap(
                                // Adds spacing between chips
                                children: show.genreList
                                    .map(
                                      (genre) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0, vertical: 4.0),
                                        child: Text(
                                          genre.genreName,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 0),
                              child: Text(
                                "Language : ${show.showLang}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text("IMDB ${show.imdbRating}"),
                            )
                          ],
                        ),
                        const Divider(
                          color: Colors.grey, // Customize color if needed
                          thickness: 1.0, // Customize thickness if needed
                          height: 35.0, // Customize height if needed
                          indent: 15.0, // Customize left indent if needed
                          endIndent: 15.0, // Customize right indent if needed
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: const Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 15),
                                child: Text(
                                  show.showInfo,
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                )),
                            // Container(
                            //     padding:
                            //         const EdgeInsets.only(left: 20, right: 15),
                            //     child: const Text(
                            //       maxLines: 2,
                            //       "Cast: Ranbir Kapoor,Ranbir Kapoor,Ranbir Kapoor,Ranbir Kapoor,Ranbir Kapoor,",
                            //       style: TextStyle(
                            //           overflow: TextOverflow.ellipsis,
                            //           fontSize: 13,
                            //           fontWeight: FontWeight.w500),
                            //     )),
                          ],
                        ),
                        const Divider(
                          color: Colors.grey, // Customize color if needed
                          thickness: 1.0, // Customize thickness if needed
                          height: 23.0, // Customize height if needed
                          indent: 15.0, // Customize left indent if needed
                          endIndent: 15.0, // Customize right indent if needed
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: const Text(
                              'Season List',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: h * 0.4,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  show.seasonList.length, // Number of rows
                              itemBuilder: (context, rowIndex) {
                                return CustomMoviesContainer(
                                  h: h,
                                  moviePoster:
                                      show.seasonList[rowIndex].seasonPoster,
                                  w: w,
                                  onTap: () {},
                                  movieName:
                                      show.seasonList[rowIndex].seasonName,
                                  moviePrice: 0,
                                );
                              }),
                        ),
                        const Divider(
                          color: Colors.grey, // Customize color if needed
                          thickness: 1.0, // Customize thickness if needed
                          height: 10.0, // Customize height if needed
                          indent: 15.0, // Customize left indent if needed
                          endIndent: 15.0, // Customize right indent if needed
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: const Text(
                              'Related Shows',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: h * 0.4,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  show.relatedShows.length, // Number of rows
                              itemBuilder: (context, rowIndex) {
                                return CustomMoviesContainer(
                                  h: h,
                                  moviePoster:
                                      show.relatedShows[rowIndex].showPoster,
                                  w: w,
                                  onTap: () {},
                                  movieName:
                                      show.relatedShows[rowIndex].showTitle,
                                  moviePrice: 0,
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              })),
    );
  }
}
