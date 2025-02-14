import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/service/image_packer.dart';
import '../../core/service/text_recognition.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/input/input_field_bloc.dart';

class InputFieldViewModel {
  final TextEditingController _textController = TextEditingController();
  final InputFieldBloc inputFieldBloc;
  final ChatBloc chatBloc;
  final ImagePickerService imagePickerService;
  final TextRecognitionService textRecognitionService;

  InputFieldViewModel({
    required this.inputFieldBloc,
    required this.chatBloc,
    required this.imagePickerService,
    required this.textRecognitionService,
  }) {
    _textController.addListener(_handleTextChanged);
  }

  TextEditingController get textController => _textController;
  void _handleTextChanged() {
    final text = _textController.text.trim();
    final isFieldEmpty = text.isEmpty;
    inputFieldBloc.add(UpdateFieldEvent(isFieldEmpty));
  }

  // bool _isFieldEmpty = true;

  // void _handleTextChanged() {
  //   final text = _textController.text.trim();
  //   if (_isFieldEmpty) {
  //     _isFieldEmpty = false;
  //     inputFieldBloc.add(UpdateFieldEvent(_isFieldEmpty));
  //   } else if (text.length == 1 || text.isEmpty) {
  //     if (text.isEmpty) {
  //       _isFieldEmpty = true;
  //     }
  //     inputFieldBloc.add(UpdateFieldEvent(_isFieldEmpty));
  //   }
  // }
  Future<bool> pickImage(ImageSource source) async {
    try {
      final image = await imagePickerService.pickImage(source);
      if (image != null) {
        final recognizedText = await textRecognitionService.extractText(image);
        if (recognizedText.isEmpty) {
          throw Exception("Image selected but no text recognized.");
        }
        inputFieldBloc.add(UpdateImageEvent(
          selectedImage: image.path,
          recognizedText: recognizedText,
        ));
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  void sendMessage({required int? chatId, required bool isChatHistory}) {
    final text = _textController.text.trim();
    final currentState = inputFieldBloc.state;

    if (text.isNotEmpty || currentState.selectedImage != null) {
      chatBloc.add(StreamDataEvent(
        prompt: text,
        isUser: true,
        chatId: chatId ?? 0,
        image: (currentState.recognizedText?.isNotEmpty ?? false)
            ? currentState.selectedImage
            : null,
        recognizedText: currentState.recognizedText,
      ));

      _textController.clear();
      inputFieldBloc.add(ResetInputFieldEvent());
    }
  }

  void dispose() {
    _textController.dispose();
  }
}
