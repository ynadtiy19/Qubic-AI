import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color withOpacity(double opacity) {
    return withValues(alpha: opacity);
  }
}
