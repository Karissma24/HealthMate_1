import 'package:flutter/material.dart';

class CardData {
  final String imagePath;
  final String title;
  final Color color1;
  final Color color2;
  final double imageWidth;
  final double imageHeight;
  final void Function(BuildContext)? onTap;

  CardData({
    required this.imagePath,
    required this.title,
    required this.color1,
    required this.color2,
    this.imageWidth = 150.0, 
    this.imageHeight = 150.0,
    this.onTap,
  });
}