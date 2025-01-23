import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart'; // For link handling
import '../../../core/utils/extension/extension.dart';
import '../../../presentation/viewmodel/validation/validation_cubit.dart';
import 'package:flutter/services.dart';

import '../../../core/di/get_it.dart';
import '../../../core/utils/constants/colors.dart';

class AiBubble extends StatefulWidget {
  const AiBubble({
    super.key,
    required this.message,
    required this.time,
  });

  final String message;
  final String time;

  @override
  State<AiBubble> createState() => _AiBubbleState();
}

class _AiBubbleState extends State<AiBubble> {
  bool _isShowDateTime = false;
  final _validationCubit = getIt<ValidationCubit>();

  void _showDate() {
    _isShowDateTime = !_isShowDateTime;
    setState(() {});
  }

  // Handle link taps
  void _launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Copy code to clipboard
  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDate,
      onDoubleTap: _showDate,
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 7.h, bottom: 7.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Bubble
            Container(
              constraints: BoxConstraints(maxWidth: context.width / 1.3),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
                color: ColorManager.dark,
              ),
              child: TextSelectionTheme(
                data: context.theme.textSelectionTheme,
                child: SelectionArea(
                  child: MarkdownBody(
                    data: widget.message,
                    styleSheet:
                    MarkdownStyleSheet.fromTheme(context.theme).copyWith(
                      p: context.textTheme.bodySmall?.copyWith(
                        color: ColorManager.white,
                      ),
                      strong: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white,
                      ),
                      em: context.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: ColorManager.white,
                      ),
                      code: context.textTheme.bodySmall?.copyWith(
                        color: ColorManager.white,
                      ),
                    ),
                    onTapLink: (text, href, title) {
                      if (href != null) {
                        _launchUrl(href); // Handle link taps
                      }
                    },
                    builders: {
                      'code': CodeBlockBuilder(
                        onCopy: _copyCode,
                      ),
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Text(
                  "AI",
                  style: context.textTheme.bodySmall,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  opacity: _isShowDateTime ? 1 : 0,
                  child: AnimatedContainer(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 250),
                    height: _isShowDateTime ? 18.h : 0.0,
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      _validationCubit.formatDateTime(widget.time),
                      style: context.textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserBubble extends StatefulWidget {
  const UserBubble({
    super.key,
    required this.message,
    required this.time,
  });

  final String message;
  final String time;

  @override
  State<UserBubble> createState() => _UserBubbleState();
}

class _UserBubbleState extends State<UserBubble> {
  bool _isShowDateTime = false;
  final _validationCubit = getIt<ValidationCubit>();

  void _showDate() {
    _isShowDateTime = !_isShowDateTime;
    setState(() {});
  }
  void _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  // Copy code to clipboard
  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDate,
      onDoubleTap: _showDate,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w, top: 7.h, bottom: 7.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Message Bubble
            Container(
              constraints: BoxConstraints(maxWidth: context.width / 1.3),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
                color: ColorManager.dark, // Black background
              ),
              child: TextSelectionTheme(
                data: context.theme.textSelectionTheme,
                child: SelectionArea(
                  child: MarkdownBody(
                    data: widget.message,
                    styleSheet:
                    MarkdownStyleSheet.fromTheme(context.theme).copyWith(
                      p: context.textTheme.bodySmall?.copyWith(
                        color: ColorManager.white, // White text for contrast
                      ),
                      strong: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white, // White text for contrast
                      ),
                      em: context.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: ColorManager.white, // White text for contrast
                      ),
                      code: context.textTheme.bodySmall?.copyWith(
                        backgroundColor: Colors.grey[800],
                        color: ColorManager.white,
                      ),
                    ),
                    onTapLink: (text, href, title) {

                      if (href != null) {
                        _launchUrl(href); // Handle link taps
                      }
                    },
                    builders: {
                      'code': CodeBlockBuilder(
                        onCopy: _copyCode,
                      ),
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            // Timestamp and User Label
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  opacity: _isShowDateTime ? 1 : 0,
                  child: AnimatedContainer(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 250),
                    height: _isShowDateTime ? 18.h : 0.0,
                    padding: EdgeInsets.only(right: 16.w),
                    child: Text(
                      _validationCubit.formatDateTime(widget.time),
                      style: context.textTheme.bodySmall,
                    ),
                  ),
                ),
                Text(
                  "You",
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CodeBlockBuilder extends MarkdownElementBuilder {
  final Function(String) onCopy;

  CodeBlockBuilder({required this.onCopy});

  @override
  Widget? visitElementAfter(element, TextStyle? preferredStyle) {
    final code = element.textContent;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    code,
                    style: const TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 2,
            top: 2,
            child: InkWell(
              child: const Icon(
                Icons.copy,
                color: Colors.white,
                size: 15,
              ),
              onTap: () => onCopy(code),
            ),
          ),
        ],
      ),
    );
  }
}