import 'package:flutter/material.dart';

class CustomSeriesContainer extends StatelessWidget {
  const CustomSeriesContainer({
    super.key,
    required this.h,
    required this.imageList,
    required this.w,
    required this.onTap,
  });

  final double h;
  final void Function() onTap;
  final List imageList;
  final double w;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageList.length, // Number of rows
        itemBuilder: (context, rowIndex) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: w * 0.65, // Width of each container
                height: h * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage(imageList[rowIndex]), fit: BoxFit.fill),
                  color: Colors.blue, // Assign colors
                ), // Height of each container
              ),
            ),
          );
        },
      ),
    );
  }
}
