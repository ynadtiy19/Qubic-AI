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
            r'|(?<string>"[^"]*"|' +
        r"'[^']*'" +
        r')'
            r'|(?<keyword>\b(var|final|const|void|class|async|await|static|extends|with|return|true|false|null|if|else|for|while|do|switch|case|break|continue|try|catch|throw|import|export|typedef|extension|on|set|get|dynamic|required|context|super)\b)'
            r'|(?<type>\b(int|double|num|String|bool|List|Map|Set|Widget|BuildContext|State|StatefulWidget|StatelessWidget)\b)'
            r'|(?<number>\b\d+\.?\d*\b)'
            r'|(?<class>(\b_?[A-Z]\w*\b))'
            r'|(?<function>\b[a-z][a-zA-Z0-9]*(?=\())' // Function pattern (camelCase + parentheses)
            r'|(?<variable>\b_?[a-z][a-zA-Z0-9]*\b)' // Variable pattern (camelCase without parentheses)
            r'|(?<symbol><|>|=|\+|-|\*|/|%|!|\?|:|\$|&|\[|\]|\{|\}|\(|\))',
  );
}
