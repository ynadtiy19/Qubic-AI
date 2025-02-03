import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:qubic_ai/core/utils/constants/colors.dart';

class PreBlockBuilder extends MarkdownElementBuilder {
  final void Function(String) onCopy;

  PreBlockBuilder({required this.onCopy});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final content = _extractCodeContent(element);
    return _buildCodeBlock(content);
  }

  String _extractCodeContent(md.Element element) {
    if (element.children?.isEmpty ?? false) return element.textContent;

    final buffer = StringBuffer();
    for (final child in element.children ?? []) {
      if (child is md.Text) {
        buffer.writeln(child.text);
      } else if (child is md.Element && child.tag == 'code') {
        buffer.writeln(child.textContent);
      }
    }
    return buffer.toString().trim();
  }

  Widget _buildCodeBlock(String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorManager.codeBg!,
              ),
              right: BorderSide(
                color: ColorManager.codeBg!,
              ),
              left: BorderSide(
                color: ColorManager.codeBg!,
              ),
            ),
            color: ColorManager.codeBg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              const Text(
                'Code Block',
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              InkWell(
                onTap: () => onCopy(content),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: ColorManager.codeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.copy,
                    color: ColorManager.white,
                    size: 16,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorManager.codeBg,
          ),
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SelectableText(
                content,
                style: const TextStyle(
                  fontFamily: 'Consolas',
                  fontSize: 14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InlineCodeBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.codeBg,
      ),
      child: SelectableText(
        element.textContent,
        style: const TextStyle(
          fontFamily: 'Consolas',
          fontSize: 14,
          color: ColorManager.white,
        ),
      ),
    );
  }
}
