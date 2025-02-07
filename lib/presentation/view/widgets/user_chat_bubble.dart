import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qubic_ai/core/utils/extension/extension.dart';

import '../../../core/di/get_it.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/helper/clipboard.dart';
import '../../../core/utils/helper/url_launcher.dart';
import '../../../core/widgets/code_block_builder.dart';
import '../../viewmodel/validation/validation_cubit.dart';

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
            Container(
              constraints: BoxConstraints(maxWidth: context.width / 1.3),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
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
                        backgroundColor: Colors.grey[800],
                        color: ColorManager.white,
                      ),
                    ),
                    onTapLink: (text, href, title) {
                      if (href != null) {
                        UrlManager.launch(href);
                      }
                    },
                    builders: {
                      'pre': PreBlockBuilder(
                          onCopy: ClipboardManager.copyToClipboard),
                      'code': InlineCodeBuilder(),
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
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
