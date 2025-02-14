part of 'input_field_bloc.dart';

abstract class InputFieldEvent {}

class UpdateFieldEvent extends InputFieldEvent {
  final bool isFieldEmpty;

  UpdateFieldEvent(this.isFieldEmpty);
}

class UpdateImageEvent extends InputFieldEvent {
  final String? selectedImage;
  final String? recognizedText;

  UpdateImageEvent({this.selectedImage, this.recognizedText});
}

class ResetInputFieldEvent extends InputFieldEvent {}
