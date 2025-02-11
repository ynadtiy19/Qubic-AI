import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qubic_ai/core/utils/helper/custom_toast.dart';

import '../../../core/di/locator.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/extension/extension.dart';
import '../../../core/utils/helper/clipboard.dart';
import '../../../core/utils/helper/url_launcher.dart';
import '../../../core/widgets/code_block_builder.dart';
import '../../../presentation/viewmodel/validation/validation_cubit.dart';

class AIBubble extends StatefulWidget {
  const AIBubble({
    super.key,
    required this.message,
    required this.time,
  });

  final String message;
  final String time;

  @override
  State<AIBubble> createState() => _AIBubbleState();
}

class _AIBubbleState extends State<AIBubble> {
  bool _isShowDateTime = false;
  final _validationCubit = getIt<ValidationCubit>();
  bool _isCopyMessage = false;

  void _showDate() {
    _isShowDateTime = !_isShowDateTime;
    setState(() {});
  }

  void _copyToClipboard() {
    ClipboardManager.copyToClipboard(widget.message);
    showCustomToast(context, message: "Copied to clipboard");
    _isCopyMessage = true;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 2500), () {
      _isCopyMessage = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: (widget.message.isNotEmpty)
          ? GestureDetector(
              onTap: _showDate,
              onDoubleTap: _showDate,
              child: Padding(
                padding: EdgeInsets.only(left: 12.w, top: 7.h, bottom: 7.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: context.width / 1.2),
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
                                MarkdownStyleSheet.fromTheme(context.theme)
                                    .copyWith(
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
                              tableBody: context.textTheme.bodySmall?.copyWith(
                                color: ColorManager.white,
                              ),
                              tableHead: context.textTheme.bodySmall?.copyWith(
                                color: ColorManager.white,
                                fontWeight: FontWeight.bold,
                              ),
                              tablePadding: EdgeInsets.zero,
                              tableCellsPadding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                            ),
                            onTapLink: (text, href, title) {
                              if (href != null) {
                                UrlManager.launch(href);
                              }
                            },
                            builders: {
                              'pre': PreBlockBuilder(context),
                              'code': InlineCodeBuilder(),
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
                            child: Row(
                              children: [
                                Text(
                                  _validationCubit.formatDateTime(widget.time),
                                  style: context.textTheme.bodySmall,
                                ),
                                SizedBox(width: 15.w),
                                GestureDetector(
                                  onTap:
                                      _isCopyMessage ? null : _copyToClipboard,
                                  child: Icon(
                                    _isCopyMessage
                                        ? Icons.done_rounded
                                        : Icons.copy_all_rounded,
                                    size: 16,
                                    color: ColorManager.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
