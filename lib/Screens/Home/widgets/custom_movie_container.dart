import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMoviesContainer extends StatelessWidget {
  const CustomMoviesContainer({
    super.key,
    required this.h,
    required this.movieName,
    required this.w,
    required this.onTap,
    required this.moviePoster,
    required this.moviePrice,
  });

  final double h;
  final void Function() onTap;
  final String moviePoster;
  final String movieName;
  final num? moviePrice;
  final double w;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: "$movieName - Price: $moviePrice",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: w * 0.48,
              height: h * 0.3,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: moviePoster,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      Text('Image not available'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: h * 0.015),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 0),
              child: SizedBox(
                width: w * 0.45,
                child: Text(
                  movieName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.namdhinggo(
                    fontSize: h * 0.021,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: h * 0.005),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SizedBox(
                width: w * 0.45,
                child: Row(
                  children: [
                    Text(
                      "Price: ${moviePrice ?? 0}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.namdhinggo(
                        fontSize: h * 0.021,
                        fontWeight: FontWeight.w800,
                        color: const Color.fromARGB(255, 69, 160, 72),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      "assets/images/INR-icon.png",
                      height: 11,
                      color: const Color.fromARGB(255, 69, 160, 72),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomMoviesComntainer extends StatelessWidget {
//   const CustomMoviesComntainer({
//     super.key,
//     required this.h,
//     required this.movieName,
//     required this.w,
//     required this.onTap,
//     required this.moviePoster,
//     required this.moviePrice,
//   });

//   final double h;
//   final void Function() onTap;
//   final String moviePoster;
//   final String movieName;
//   final String moviePrice;
//   final double w;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             // color: const Color.fromARGB(255, 228, 227, 227),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: w * 0.48, // Width of each container
//                   height: h * 0.3,
//                   decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 235, 234, 234),
//                     borderRadius:
//                         BorderRadius.circular(20), // Add border radius
//                   ),
//                   clipBehavior: Clip
//                       .antiAlias, // Ensure the image respects the border radius
//                   child: CachedNetworkImage(
//                     imageUrl: moviePoster,
//                     fit: BoxFit.fill, // Similar to DecorationImage fit property
//                     placeholder: (context, url) => const Center(
//                       child:
//                           CircularProgressIndicator(), // Placeholder while loading
//                     ),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error), // Error icon
//                   ),
//                 ),
//                 SizedBox(
//                   height: h * 0.015,
//                 ),
//                 SizedBox(
//                   width: w * 0.45,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 10.0),
//                     child: Text(
//                       movieName,
//                       maxLines: 2,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.namdhinggo(
//                         textStyle: TextStyle(
//                             fontSize: h * 0.021,
//                             fontWeight: FontWeight.w800,
//                             color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: h * 0.005,
//                 ),
//                 SizedBox(
//                   width: w * 0.45,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 10.0),
//                     child: Text(
//                       "Price : 10",
//                       maxLines: 1,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.namdhinggo(
//                         textStyle: TextStyle(
//                             fontSize: h * 0.021,
//                             fontWeight: FontWeight.w800,
//                             color: const Color.fromARGB(255, 69, 160, 72)),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//           // Height of each container
//           ),
//     );
//   }
// }
