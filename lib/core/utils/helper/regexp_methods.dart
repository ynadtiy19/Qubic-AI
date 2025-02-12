import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

class RegExpManager {
  const RegExpManager._();

  static bool isNameQuery(String prompt) {
    return prompt.toLowerCase().contains(RegExp(
          r"(اسمك|name|ما اسمك|your name|nombre|你叫什么名字|comment tu t\'appelles)",
          caseSensitive: false,
        ));
  }

  static RegExp syntaxPatterns = RegExp(
    r'(?<annotation>@\w+|part\b)'
    r'|(?<comment>//.*|/\*[\s\S]*?\*/)'
    r'|(?<string>"[^"]*"|'
    r"'[^']*'"
    r')'
    r'|(?<keyword>\b(var|final|const|void|class|async|await|static|extends|with|return|true|false|null|if|else|for|while|do|switch|case|break|continue|try|catch|throw|import|export|typedef|extension|on|set|get|dynamic|required|super|as|factory|late|this)\b)'
    r'|(?<type>\b(int|double|num|String|bool|List|Map|Set|Widget|BuildContext|State|StatefulWidget|StatelessWidget)\b)'
    r'|(?<number>\b\d+\.?\d*\b)'
    r'|(?<class>(\b_?[A-Z]\w*\b))'
    r'|(?<function>\b[a-z][a-zA-Z0-9]*(?=\())' // Function pattern (camelCase + parentheses)
    r'|(?<variable>\b_?[a-z][a-zA-Z0-9]*\b)' // Variable pattern (camelCase without parentheses)
    r'|(?<symbol><|>|=|\+|-|\*|/|%|!|\?|\$|&|\[|\]|\{|\}|\(|\))',
  );

  static final RegExp arabicCharacters = RegExp(r'[\u0600-\u06FF]');
  static final RegExp durationPattern =
      RegExp(r'(\d+)\s*hours?\s*(\d+)\s*mins?');
  static final RegExp emailPattern = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&\'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$",
  );
  static final RegExp namePattern =
      RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
  static final RegExp phonePattern = RegExp(r"^\+?\d{10,12}$");
  static final RegExp numericPattern = RegExp(r"^\d+(\.\d+)?$");
  static final RegExp dateFormatPattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  static final RegExp dayMonthPattern = RegExp(r'^\d{2}$');
  static final RegExp yearPattern = RegExp(r'^\d{4}$');

  static TextDirection getTextDirection(String text) {
    return arabicCharacters.hasMatch(text)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  static TextDirection getFieldDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    return arabicCharacters.hasMatch(text[0])
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  static String? convertDuration(String duration) {
    final match = durationPattern.firstMatch(duration);
    return match != null
        ? '${match.group(1)!} h ${match.group(2)!} m'
        : duration;
  }

  static String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('M/d h:mm a').format(dateTime);
  }

  static String formatBirthDate(String value) {
    final date = DateFormat('dd/MM/yyyy').parseStrict(value);
    return DateFormat('M/d/yyyy').format(date);
  }

  static bool hasUpperCase(String value) => value.contains(RegExp(r'[A-Z]'));
  static bool hasLowerCase(String value) => value.contains(RegExp(r'[a-z]'));
  static bool hasDigit(String value) => value.contains(RegExp(r'\d'));
  static bool isValidEmail(String email) => emailPattern.hasMatch(email);
  static bool isValidName(String name) => namePattern.hasMatch(name);
  static bool isValidPhone(String phone) => phonePattern.hasMatch(phone);
  static bool isNumeric(String value) => numericPattern.hasMatch(value);
  static bool isValidDate(String value) => dateFormatPattern.hasMatch(value);
  static bool isValidDayMonth(String value) => dayMonthPattern.hasMatch(value);
  static bool isValidYear(String value) => yearPattern.hasMatch(value);
}
