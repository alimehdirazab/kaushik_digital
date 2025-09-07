import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Providers/home_data_provider.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_bottom_sheet.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_home_slider.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_movie_container.dart';
import 'package:kaushik_digital/Services/home_service.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kaushik_digital/Screens/Detail%20screen/sampleplayer.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  HomeService homeService = HomeService();
  bool _didFetch = false;
  int _currentSliderIndex = 0;
  Future<Map<String, dynamic>>? _showsFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the future once to prevent rebuilds
    _showsFuture ??= homeService.getShows(context: context);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
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
                  NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: h * 0.75,
                      floating: false,
                      pinned: true,
                      backgroundColor: Colors.black,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Carousel Banner Slider
                            CarouselSlider.builder(
                              itemCount: movieData.slider.length,
                              options: CarouselOptions(
                                height: h * 0.75,
                                viewportFraction: 1.0,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 4),
                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                scrollPhysics: const BouncingScrollPhysics(),
                                pauseAutoPlayOnTouch: true,
                                pauseAutoPlayOnManualNavigate: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentSliderIndex = index;
                                  });
                                },
                              ),
                              itemBuilder: (context, index, realIndex) {
                                final sliderItem = movieData.slider[index];
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(sliderItem.sliderImage),
                                      fit: BoxFit.fill,
                                      onError: (error, stackTrace) {
                                        print('Error loading image: $error');
                                      },
                                    ),
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.black26,
                                          Colors.black54,
                                        ],
                                        stops: [0.0, 0.5, 0.8, 1.0],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Enhanced Gradient Overlay for better text visibility
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black38,
                                    Colors.black87,
                                    Colors.black,
                                  ],
                                  stops: [0.0, 0.4, 0.6, 0.85, 1.0],
                                ),
                              ),
                            ),
                            // Netflix-style overlay content
                            Positioned(
                              bottom: 50,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                 
                                  // Series/Movie title (Dynamic based on current slide)
                                  Text(
                                    movieData.slider.isNotEmpty 
                                      ? movieData.slider[_currentSliderIndex].sliderTitle
                                      : 'Featured Content',
                                    style: GoogleFonts.inter(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Subtitle/Description
                                  Text(
                                    'Drama • Thriller • Action',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Netflix-style buttons
                                  Row(
                                    children: [
                                      // Play Button
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle play action for slider
                                            if (movieData.slider.isNotEmpty) {
                                              final currentSlider = movieData.slider[_currentSliderIndex];
                                              
                                              // For sliders, directly navigate to video player since they're typically free
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => VideoPlayerScreen(
                                                    movieTitle: currentSlider.sliderTitle,
                                                    movieId: currentSlider.sliderPostId,
                                                    movieUrl: null, // Will use fallback video URL
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.black,
                                                  size: 28,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Play',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // My List Button
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800]!.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'My List',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Info Button
                                      Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800]!.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.info_outline,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Carousel Indicators
                            Positioned(
                              bottom: 15,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: movieData.slider.asMap().entries.map((entry) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: _currentSliderIndex == entry.key ? 24 : 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: _currentSliderIndex == entry.key
                                          ? const Color(0xffE50914)
                                          : Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            // Top gradient for status bar
                            Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black54,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Netflix-style app bar
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'For You',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Movies',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'TV Shows',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // change tab to search
                           
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.person, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Latest Movies Section
                      _buildSectionTitle("Latest Movies"),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: h * 0.28,
                        child: movieData.latestMovies.isEmpty
                            ? _buildEmptyState("No movies available.")
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 16),
                                itemCount: movieData.latestMovies.length,
                                itemBuilder: (context, rowIndex) {
                                  var latestmovies = movieData.latestMovies[rowIndex];
                                  return _buildNetflixCard(
                                    imageUrl: latestmovies.moviePoster,
                                    title: latestmovies.movieTitle,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return MovieBottomSheet(
                                            context: context,
                                            movieName: latestmovies.movieTitle,
                                            duration: latestmovies.movieDuration,
                                            moviePoster: latestmovies.moviePoster,
                                            moviePrice: latestmovies.moviePrice,
                                            movieId: latestmovies.movieId,
                                            movieUrl: latestmovies.movieUrl,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Latest Shows Section
                      _buildSectionTitle("Latest Shows"),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: h * 0.28,
                        child: movieData.latestShows.isEmpty
                            ? _buildEmptyState("No shows available.")
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 16),
                                itemCount: movieData.latestShows.length,
                                itemBuilder: (context, rowIndex) {
                                  var latestShows = movieData.latestShows[rowIndex];
                                  return _buildNetflixCard(
                                    imageUrl: latestShows.showPoster,
                                    title: latestShows.showTitle,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return MovieBottomSheet(
                                            context: context,
                                            movieName: latestShows.showTitle,
                                            duration: "1h 15m",
                                            moviePoster: latestShows.showPoster,
                                            moviePrice: latestShows.showPrice,
                                            movieId: latestShows.showId,
                                            movieUrl: null,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Popular Movies Section
                      _buildSectionTitle("Popular Movies"),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: h * 0.28,
                        child: movieData.popularMovies.isEmpty
                            ? _buildEmptyState("No movies available.")
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 16),
                                itemCount: movieData.popularMovies.length,
                                itemBuilder: (context, rowIndex) {
                                  var popularMovie = movieData.popularMovies[rowIndex];
                                  return _buildNetflixCard(
                                    imageUrl: popularMovie.moviePoster,
                                    title: popularMovie.movieTitle,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return MovieBottomSheet(
                                            context: context,
                                            movieName: popularMovie.movieTitle,
                                            duration: popularMovie.movieDuration,
                                            moviePoster: popularMovie.moviePoster,
                                            moviePrice: popularMovie.moviePrice,
                                            movieId: popularMovie.movieId,
                                            movieUrl: popularMovie.movieUrl,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Popular Shows Section
                      _buildSectionTitle("Popular Shows"),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: h * 0.28,
                        child: movieData.popularShows.isEmpty
                            ? _buildEmptyState("No shows available.")
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 16),
                                itemCount: movieData.popularShows.length,
                                itemBuilder: (context, rowIndex) {
                                  var popularShows = movieData.popularShows[rowIndex];
                                  return _buildNetflixCard(
                                    imageUrl: popularShows.showPoster,
                                    title: popularShows.showTitle,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return MovieBottomSheet(
                                            context: context,
                                            movieName: popularShows.showTitle,
                                            duration: "1h 15m",
                                            moviePoster: popularShows.showPoster,
                                            moviePrice: popularShows.showPrice,
                                            movieId: popularShows.showId,
                                            movieUrl: null,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // All Shows Section
                      _buildSectionTitle("All Shows"),
                      const SizedBox(height: 12),
                      FutureBuilder<Map<String, dynamic>>(
                        future: _showsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator(color: Color(0xffE50914))),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return _buildEmptyState('No data available');
                          } else {
                            final items = snapshot.data!["VIDEO_STREAMING_APP"];
                            return SizedBox(
                              height: h * 0.28,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 16),
                                itemCount: items.length,
                                itemBuilder: (context, rowIndex) {
                                  return _buildNetflixCard(
                                    imageUrl: items[rowIndex]['show_poster'],
                                    title: items[rowIndex]['show_title'],
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return MovieBottomSheet(
                                            context: context,
                                            movieName: items[rowIndex]['show_title'],
                                            duration: '1h 23min',
                                            moviePoster: items[rowIndex]['show_poster'],
                                            moviePrice: items[rowIndex]['price'],
                                            movieId: items[rowIndex]['show_id'],
                                            movieUrl: null,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
        }
      )
    )
    );
    }
  }

  // Netflix-style section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Netflix-style empty state
  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  // Netflix-style card widget
  Widget _buildNetflixCard({
    required String imageUrl,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.movie,
                              color: Colors.white54,
                              size: 50,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffE50914),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                      // Hover effect overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Movie title
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

