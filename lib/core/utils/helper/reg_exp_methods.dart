class RegExpManager {
  const RegExpManager._();

  static bool isNameQuery(String prompt) {
    return prompt.toLowerCase().contains(RegExp(
          r"(اسمك|name|ما اسمك|your name|nombre|你叫什么名字|comment tu t\'appelles)",
          caseSensitive: false,
        ));
  }
}
