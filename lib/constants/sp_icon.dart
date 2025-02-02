import 'package:flutter/material.dart';

class SPIcon extends StatelessWidget {
  final String assetName;
  final int? index;
  final int? currentIndex;
  final double? height;
  final double? width;
  const SPIcon({
    super.key,
    required this.assetName,
    this.index,
    this.currentIndex,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/iconimages/$assetName",
      height: height ?? 25,
      width: width ?? 25,
      color: index == currentIndex
          ? const Color.fromRGBO(43, 43, 43, 0.8)
          : Colors.grey,
    );
  }
}
