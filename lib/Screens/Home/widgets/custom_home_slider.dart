import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Models/home_api_model.dart';
import 'package:kaushik_digital/Providers/user_provider.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_bottom_sheet.dart';
import 'package:kaushik_digital/Services/home_service.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:provider/provider.dart';

class CustomHomeSlider extends StatefulWidget {
  const CustomHomeSlider({
    super.key,
    required this.h,
    required this.slider,
    required this.w,
  });

  final double h;
  final List<SliderItem> slider;
  final double w;

  @override
  State<CustomHomeSlider> createState() => _CustomHomeSliderState();
}

class _CustomHomeSliderState extends State<CustomHomeSlider> {
  SliderItem? currentIndex;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    HomeService homeService = HomeService();
    final sliderHeight = widget.h * 0.50;
    return Stack(
      children: [
        SizedBox(
          height: sliderHeight,
          width: double.infinity,
          child: CarouselSlider.builder(
            itemCount: widget.slider.length,
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: true,
              height: sliderHeight,
              aspectRatio: 1.5,
              onPageChanged: (index, reason) {
                final SliderItem sliderIdx = widget.slider[index];
                setState(() {
                  currentIndex = sliderIdx;
                  _currentPage = index;
                });
              },
            ),
            itemBuilder: (context, index, realIdx) {
              final sliderIdx = widget.slider[index];
              return CachedNetworkImage(
                imageUrl: sliderIdx.sliderImage,
                fit: BoxFit.fill,
                width: double.infinity,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
            },
          ),
        ),

        // Shadow covering bottom 30% of slider
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              height: sliderHeight * 0.7,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black26,
                    Colors.black54,
                    Colors.black87,
                    Colors.black,
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: widget.h * 0.40,
          width: widget.w,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (currentIndex == null) return;

                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                    builder: (BuildContext context) {
                      return MovieBottomSheet(
                        context: context,
                        movieName: currentIndex!.sliderTitle,
                        duration: '1h 30min',
                        moviePoster: currentIndex!.sliderImage,
                      );
                    },
                  );

                  print(currentIndex!.sliderTitle);
                  print(currentIndex!.sliderPostId);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: whiteColor,
                            size: 28,
                          ),
                          Text("Watch Now",
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.slider.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? primaryColor
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Buy Elite Button
// Search TextField
// Positioned(
//   top: h * 0.099,
//   left: 10,
//   right: 10,
//   child: SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(
//           5, // Three containers per row
//           (colIndex) => Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: GenderSelection(
//               name: 'Category',
//               onTap: () {},
//               bgcolor: primaryColor,
//               textColor: whiteColor,
//             ),
//           ),
//         ),
//       )),
// ),
