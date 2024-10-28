import 'package:flutter/material.dart';

double gheight(BuildContext context, double scale) {
  return MediaQuery.of(context).size.height * scale;
}

double gwidth(BuildContext context, double scale) {
  return MediaQuery.of(context).size.width * scale;
}
