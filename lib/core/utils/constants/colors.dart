import 'package:flutter/material.dart';

class ColorManager {
  const ColorManager._();

  static Color dark = Colors.grey.shade900;
  static Color grey = Colors.grey;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color purple = Colors.purple;
  static Color? error = Colors.red[700];
  static Color? codeBg = Colors.grey[800];

  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  // Code theme code colors
  // static const Color codeBg = Color(0xFF1E1E1E); // Editor background
  static const Color codeHeaderBg = Color(0xFF2D2D2D); // Code block header
  static const Color codeHeaderText = Color(0xFF858585); // Language label
  static const Color codeComment = Color(0xFF6A9955); // Comments
  static const Color codeKeyword =
      Color(0xFF569CD6); // Keywords (var, final, etc.)
  static const Color codeLiteral = Color(0xFF4FC1FF); // Literals (true, false)
  static const Color codeNumber = Color(0xFFB5CEA8); // Numbers
  static const Color codeString = Color(0xFFCE9178); // Strings
  static const Color codeTitle = Color(0xFFDCDCAA); // Class names
  static const Color codeType = Color(0xFF4EC9B0); // Types (int, String)
  static const Color codeSymbol = Color(0xFFD7BA7D); // Symbols (=>, ==)
  static const Color codeBullet = Color(0xFFD7BA7D); // Bullet points
  static const Color codeMeta = Color(0xFF9B9B9B); // Metadata annotations

  // Inline code colors
  static const Color inlineCodeBg = Color(0x15FFFFFF); // Slight white overlay
  static const Color inlineCodeText = Color(0xFFD4D4D4); // Inline code text
}
