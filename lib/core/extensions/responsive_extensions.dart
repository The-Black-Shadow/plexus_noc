import 'package:flutter/material.dart';

// Standard design width (iPhone 11/12/13/14 Pro is usually 390.0 or 375.0)
const double _kDesignRef = 375.0; 

extension ResponsiveExt on num {
  double responsive(BuildContext context) {
    // We use 'shortestSide' so it works on Phones (Width) AND Tablets (Height in landscape)
    // This prevents the logo from becoming massive on an iPad.
    final scaleFactor = MediaQuery.of(context).size.shortestSide / _kDesignRef;
    
    return this * scaleFactor;
  }
}