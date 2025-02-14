part of 'input_field_bloc.dart';

@immutable
abstract class InputFieldState {
  final String? selectedImage;
  final String? recognizedText;
  final bool isFieldEmpty;

  const InputFieldState({
    this.selectedImage,
    this.recognizedText,
    required this.isFieldEmpty,
  });
}

class InputFieldInitial extends InputFieldState {
  const InputFieldInitial() : super(isFieldEmpty: true);
}

class InputFieldUpdated extends InputFieldState {
  const InputFieldUpdated({
    required super.isFieldEmpty,
    super.selectedImage,
    super.recognizedText,
  });
}