import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'input_field_event.dart';
part 'input_field_state.dart';

class InputFieldBloc extends Bloc<InputFieldEvent, InputFieldState> {
  InputFieldBloc() : super(const InputFieldInitial()) {
    on<UpdateFieldEvent>((event, emit) {
      emit(InputFieldUpdated(
        isFieldEmpty: event.isFieldEmpty,
        selectedImage: state.selectedImage,
        recognizedText: state.recognizedText,
      ));
    });

    on<UpdateImageEvent>((event, emit) {
      emit(InputFieldUpdated(
        isFieldEmpty: state.isFieldEmpty,
        selectedImage: event.selectedImage,
        recognizedText: event.recognizedText,
      ));
    });

    on<ResetInputFieldEvent>((event, emit) {
      emit(const InputFieldUpdated(
        isFieldEmpty: true,
        selectedImage: null,
        recognizedText: null,
      ));
    });
  }
}
