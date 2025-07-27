import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Providers/home_data_provider.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_bottom_sheet.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_home_slider.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_movie_container.dart';
import 'package:kaushik_digital/Services/home_service.dart';
import 'package:provider/provider.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  HomeService homeService = HomeService();
  bool _didFetch = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: Brightness.light, // For white icons
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
            backgroundColor: const Color(0xffFBFCF8),
            body: Consumer<HomeDataProvider>(builder: (
              context,
              movie,
              child,
            ) {
              // Fetch movies if not already fetched and not loading
              if (!_didFetch &&
                  movie.videoStreamingApp == null &&
                  !movie.isLoading) {
                _didFetch = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  movie.fetchVideoStreamingData(context: context);
                });
              }
              if (movie.isLoading || movie.videoStreamingApp == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final movieData = movie.videoStreamingApp!;

              return

                  //  FutureBuilder<Map<String, dynamic>>(
                  //   future: homeService.getMovies(context: context),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(child: Text('Error: ${snapshot.error}'));
                  //     } else if (snapshot.data!.isEmpty) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasData) {
                  //       final data = snapshot.data?['VIDEO_STREAMING_APP'];
                  //       return
                  SingleChildScrollView(
                      child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHomeSlider(
                        h: h,
                        w: w,
                        slider: movieData.slider,
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5),
                          child: Text(
                            "Latest Movies",
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          )),
                      SizedBox(
                          height: h * 0.3,
                          child: movieData.latestMovies.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No movies available.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: movieData
                                      .latestMovies.length, // Number of rows
                                  padding: const EdgeInsets.only(left: 10),
                                  itemBuilder: (context, rowIndex) {
                                    var latestmovies =
                                        movieData.latestMovies[rowIndex];

                                    return CustomMoviesContainer(
                                      h: h * 0.7,
                                      moviePoster: latestmovies.moviePoster,
                                      w: w * 0.65,
                                      onTap: () {
                                        print(latestmovies);
                                        showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16.0)),
                                          ),
                                          builder: (BuildContext context) {
                                            return MovieBottomSheet(
                                              context: context,
                                              movieName:
                                                  latestmovies.movieTitle,
                                              duration:
                                                  latestmovies.movieDuration,
                                              moviePoster:
                                                  latestmovies.moviePoster,
                                              moviePrice:
                                                  latestmovies.moviePrice,
                                              movieId:
                                                  latestmovies.movieId,
                                              movieUrl:
                                                  latestmovies.movieUrl,
                                            );
                                          },
                                        );

                                        // showMovieBottomSheet(
                                        //   context: context,
                                        //   movieName: latestmovies.movieTitle,
                                        //   duration: latestmovies.movieDuration,
                                        //   moviePoster: latestmovies.moviePoster,
                                        //   // onPayNow: _startPayment,
                                        // );
                                      },
                                      movieName: latestmovies.movieTitle,
                                      moviePrice: latestmovies.moviePrice,
                                    );
                                  },
                                )

                          // ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount:
                          //         data["latest_movies"].length, // Number of rows
                          //     itemBuilder: (context, rowIndex) {
                          //       return CustomMoviesContainer(
                          //         h: h,
                          //         moviePoster: data["latest_movies"][rowIndex]
                          //             ['movie_poster'],
                          //         w: w,
                          //         onTap: () {
                          //           print(data["latest_movies"][rowIndex]);
                          //         },
                          //       );
                          //     }),
                          ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5),
                        child: Text(
                          "Latest Shows",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: h * 0.3,
                          child: movieData.latestShows.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No movies available.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: movieData
                                      .latestShows.length, // Number of rows
                                  padding: const EdgeInsets.only(left: 10),
                                  itemBuilder: (context, rowIndex) {
                                    var latestShows =
                                        movieData.latestShows[rowIndex];
                                    return CustomMoviesContainer(
                                      h: h * 0.7,
                                      moviePoster: latestShows.showPoster,
                                      w: w * 0.65,
                                      onTap: () {
                                        print(latestShows);
                                        // var movie =                                               .videoStreamingApp!
                                        //     .latestShows[rowIndex];
                                        showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16.0)),
                                          ),
                                          builder: (BuildContext context) {
                                            return MovieBottomSheet(
                                              context: context,
                                              movieName: latestShows.showTitle,
                                              duration: "1h 15m",
                                              moviePoster:
                                                  latestShows.showPoster,
                                              moviePrice: latestShows.showPrice,
                                              movieId: latestShows.showId,
                                              movieUrl: null, // Shows don't have URLs in the current API
                                            );
                                          },
                                        );
                                        // showMovieBottomSheet(
                                        //   context: context,
                                        //   movieName: latestShows.showTitle,
                                        //   duration: "1h 15m",
                                        //   moviePoster: latestShows.showPoster,
                                        //   // onPayNow: _startPayment,
                                        // );

                                        // ShowDetailScreen(
                                        //     id:  homeProvider.videoStreamingApp!
                                        //         .latestShows[
                                        //             rowIndex]
                                        //         .showId)
                                      },
                                      movieName: latestShows.showTitle,
                                      moviePrice: latestShows.showPrice,
                                    );
                                  },
                                )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5),
                        child: Text(
                          "Popular Movies",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: h * 0.3,
                          child: movieData.popularMovies.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No movies available.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: movieData
                                      .popularMovies.length, // Number of rows
                                  padding: const EdgeInsets.only(left: 10),
                                  itemBuilder: (context, rowIndex) {
                                    var popularMovie =
                                        movieData.popularMovies[rowIndex];
                                    return CustomMoviesContainer(
                                      h: h * 0.7,
                                      moviePoster: popularMovie.moviePoster,
                                      w: w * 0.65,
                                      onTap: () {
                                        print(popularMovie);

                                        // var movie = homeProvider
                                        //     .videoStreamingApp!
                                        //     .popularMovies[rowIndex];

                                        showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16.0)),
                                          ),
                                          builder: (BuildContext context) {
                                            return MovieBottomSheet(
                                              context: context,
                                              movieName:
                                                  popularMovie.movieTitle,
                                              duration:
                                                  popularMovie.movieDuration,
                                              moviePoster:
                                                  popularMovie.moviePoster,
                                              moviePrice:
                                                  popularMovie.moviePrice,
                                              movieId:
                                                  popularMovie.movieId,
                                              movieUrl:
                                                  popularMovie.movieUrl,
                                            );
                                          },
                                        );
                                        // showMovieBottomSheet(
                                        //   context: context,
                                        //   movieName: popularMovie.movieTitle,
                                        //   duration: popularMovie.movieDuration,
                                        //   moviePoster: popularMovie.moviePoster,
                                        //   // onPayNow: _startPayment,
                                        // );
                                        // ShowDetailScreen(
                                        //     id:  homeProvider.videoStreamingApp!
                                        //         .popularMovies[
                                        //             rowIndex]
                                        //         .movieId)
                                      },
                                      movieName: popularMovie.movieTitle,
                                      moviePrice: popularMovie.moviePrice,
                                    );
                                  },
                                )

                          //  ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount:
                          //         data["popular_movies"].length, // Number of rows
                          //     itemBuilder: (context, rowIndex) {
                          //       return CustomMoviesContainer(
                          //         h: h,
                          //         moviePoster: data["popular_movies"][rowIndex]
                          //             ['movie_poster'],
                          //         w: w,
                          //         onTap: () {},
                          //       );
                          //     }),
                          ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5),
                        child: Text(
                          "Popular Shows",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.3,
                        child: movieData.popularShows.isEmpty
                            ? const Center(
                                child: Text(
                                  "No movies available.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: movieData
                                    .popularShows.length, // Number of rows
                                padding: const EdgeInsets.only(left: 10),
                                itemBuilder: (context, rowIndex) {
                                  var popularShows =
                                      movieData.popularShows[rowIndex];
                                  return CustomMoviesContainer(
                                    h: h * 0.7,
                                    moviePoster: popularShows.showPoster,
                                    w: w * 0.65,
                                    onTap: () {
                                      print(popularShows);

                                      // var movie = homeProvider
                                      //     .videoStreamingApp!
                                      //     .popularShows[rowIndex];

                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16.0)),
                                        ),
                                        builder: (BuildContext context) {
                                          return MovieBottomSheet(
                                            context: context,
                                            movieName: popularShows.showTitle,
                                            duration: "1h 15m",
                                            moviePoster:
                                                popularShows.showPoster,
                                            moviePrice: popularShows.showPrice,
                                            movieId: popularShows.showId,
                                            movieUrl: null, // Shows don't have URLs in the current API
                                          );
                                        },
                                      );

                                      // showMovieBottomSheet(
                                      //   context: context,
                                      //   movieName: popularShows.showTitle,
                                      //   duration: "1h 15m",
                                      //   moviePoster: popularShows.showPoster,
                                      //   // onPayNow: _startPayment,
                                      // );

                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ShowDetailScreen(
                                      //                 id: homeProvider
                                      //                     .videoStreamingApp!
                                      //                     .popularShows[
                                      //                         rowIndex]
                                      //                     .showId)));
                                    },
                                    movieName: popularShows.showTitle,
                                    moviePrice: popularShows.showPrice,
                                  );
                                },
                              ),

                        // ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount:
                        //         data["popular_shows"].length, // Number of rows
                        //     itemBuilder: (context, rowIndex) {
                        //       return CustomMoviesContainer(
                        //         h: h,
                        //         moviePoster: data["popular_shows"][rowIndex]
                        //             ['show_poster'],
                        //         w: w,
                        //         onTap: () {},
                        //       );
                        //     }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5),
                        child: Text(
                          "Recently Watched",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: h * 0.3,
                      //   child:  homeProvider.videoStreamingApp!..isEmpty
                      //       ? Center(
                      //           child: Text(
                      //             "No Movies Watched.",
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //         )
                      //       : ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           itemCount: data["recently_watched"]
                      //               .length, // Number of rows
                      //           itemBuilder: (context, rowIndex) {
                      //             return CustomMoviesContainer(
                      //               h: h,
                      //               moviePoster: data["recently_watched"][rowIndex]
                      //                   ['show_poster'],
                      //               w: w,
                      //               onTap: () {
                      //                 print(data["popular_shows"][rowIndex]);
                      //               },
                      //             );
                      //           },
                      //         ),
                      //   //  ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: moviePoster.length, // Number of rows
                      //     itemBuilder: (context, rowIndex) {
                      //       return CustomMoviesContainer(
                      //         h: h,
                      //         moviePoster: moviePoster[rowIndex],
                      //         w: w,
                      //         onTap: () {},
                      //       );
                      //     }),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5),
                        child: Text(
                          "Shows",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      // CustomSeriesContainer(
                      //   h: h,
                      //   imageList: imageList,
                      //   w: w,
                      //   onTap: () {},
                      // ),
                      FutureBuilder<Map<String, dynamic>>(
                          future: homeService.getShows(
                              context: context), // Your asynchronous function
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Show a loading spinner while waiting for data
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              // Handle errors
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              // Handle empty data
                              return const Center(
                                child: Text('No data available'),
                              );
                            } else {
                              // Data is available, show it in a ListView
                              final items =
                                  snapshot.data!["VIDEO_STREAMING_APP"];
                              return SizedBox(
                                height: h * 0.3,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: items.length, // Number of rows
                                    padding: const EdgeInsets.only(left: 10),
                                    itemBuilder: (context, rowIndex) {
                                      return CustomMoviesContainer(
                                        h: h * 0.7,
                                        moviePoster: items[rowIndex]
                                            ['show_poster'],
                                        w: w * 0.65,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          16.0)),
                                            ),
                                            builder: (BuildContext context) {
                                              return MovieBottomSheet(
                                                context: context,
                                                movieName: items[rowIndex]
                                                    ['show_title'],
                                                duration: '1h 23min',
                                                moviePoster: items[rowIndex]
                                                    ['show_poster'],
                                                moviePrice: items[rowIndex]
                                                    ['price'],
                                                movieId: items[rowIndex]
                                                    ['show_id'],
                                                movieUrl: null, // Shows don't have URLs in the current API
                                              );
                                            },
                                          );
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ShowDetailScreen(
                                          //                 id: items[rowIndex]
                                          //                     ["show_id"])));
                                          print(items[rowIndex]);
                                          // homeService.getShowDetails(
                                          //     showId: items[rowIndex]["show_id"],
                                          //     context: context);
                                        },
                                        movieName: items[rowIndex]
                                            ['show_title'],
                                        moviePrice: items[rowIndex]['price'],
                                      );
                                    }),
                              );
                            }
                            // ListView.builder(
                            //   itemCount: items.length,
                            //   itemBuilder: (context, index) {
                            //     return ListTile(
                            //       title: Text(items[index]),
                            //       leading: const Icon(Icons.list),
                            //       onTap: () {
                            //         print('Tapped on: ${items[index]}');
                            //       },
                            //     );
                            //   },
                            // );
                            //     }
                          })
                      // ),
                    ]),
              ));
            })
            //   }
            //   return const SizedBox();
            // },
            ),
      ),
    );
  }
}
