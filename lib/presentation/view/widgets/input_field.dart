import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:qubic_ai/core/utils/extension/extension.dart';

import '../../../core/di/get_it.dart';
import '../../../core/utils/constants/colors.dart';
import '../../viewmodel/chat/chat_bloc.dart';
import '../../viewmodel/validation/validation_cubit.dart';

class BuildInputField extends StatefulWidget {
  const BuildInputField(
      {super.key,
      required this.generativeAIBloc,
      required this.isLoading,
      required this.chatId,
      required this.isChatHistory});

  final ChatAIBloc generativeAIBloc;
  final bool isLoading;
  final int? chatId;
  final bool isChatHistory;

  @override
  State<BuildInputField> createState() => _BuildInputFieldState();
}

class _BuildInputFieldState extends State<BuildInputField> {
  late TextEditingController _textInputFieldController;

  @override
  void initState() {
    super.initState();
    _textInputFieldController = TextEditingController();
  }

  void _onChanged(String text) {
    if (_isFieldEmpty) {
      _isFieldEmpty = false;
      setState(() {});
    } else if (text.trim().length == 1 || text.trim().isEmpty) {
      if (text.trim().isEmpty) {
        _isFieldEmpty = true;
      }
      setState(() {});
    }
  }

  void _sendMessage() {
    if (_textInputFieldController.text.trim().isNotEmpty) {
      widget.generativeAIBloc.add(
        StreamDataEvent(
          prompt: _textInputFieldController.text.trim(),
          isUser: true,
          chatId: widget.chatId ?? 0,
        ),
      );
      _textInputFieldController.clear();
    }
    _isFieldEmpty = true;
    setState(() {});
  }

  final _validationCubit = getIt<ValidationCubit>();
  bool _isFieldEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          right: 9.w,
          left: 9.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10.h),
      decoration: BoxDecoration(
        color: ColorManager.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.w, top: 5.h, bottom: 5.h),
            child: !widget.isChatHistory
                ? IconButton(
                    onPressed: () => widget.generativeAIBloc
                        .add(CreateNewChatSessionEvent()),
                    icon: const Icon(
                      Icons.add,
                      color: ColorManager.white,
                      size: 25,
                    ),
                  )
                : null,
          ),
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 5,
              onChanged: _onChanged,
              style: context.textTheme.bodyMedium,
              controller: _textInputFieldController,
              textDirection: _validationCubit
                  .getFieldDirection(_textInputFieldController.text),
              onSubmitted: (_) => !widget.isLoading ? _sendMessage() : null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: !widget.isChatHistory ? 0 : 15,
                    right: 10,
                    top: 13.h,
                    bottom: 13.h),
                hintText: 'Message Qubic AI',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.w),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: widget.isLoading
                    ? ColorManager.white
                    : _textInputFieldController.text.trim().isEmpty
                        ? ColorManager.grey
                        : ColorManager.white,
              ),
              onPressed: () => !widget.isLoading ? _sendMessage() : null,
              icon: widget.isLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                      ),
                    )
                  : Icon(
                      Icons.arrow_upward_rounded,
                      color: ColorManager.dark,
                      size: 25,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
