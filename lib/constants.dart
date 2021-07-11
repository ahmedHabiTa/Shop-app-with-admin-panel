import 'package:flutter/material.dart';

bool adminToken ;
Widget cardPrice(Widget child, Color color) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: color,
    ),
    height: 25,
    width: 80,
    alignment: Alignment.topLeft,
    child: Center(child: child),
  );
}
int carouselSliderDotIndex = 0;
carouselSliderDot({int index}) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(right: 5),
    height: 6,
    width: carouselSliderDotIndex == index ? 10 : 5,
    decoration: BoxDecoration(
      color: carouselSliderDotIndex == index ? Colors.blue[900] : Colors.grey,
      borderRadius: BorderRadius.circular(3),
    ),
  );
}