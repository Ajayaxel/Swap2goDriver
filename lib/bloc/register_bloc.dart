import 'package:bloc/bloc.dart';

import 'package:swap2godriver/repo/auth_repo.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final response = await authRepository.register(event.request);
      if (response.success) {
        emit(RegisterSuccess(response: response));
      } else {
        emit(RegisterFailure(error: response.message));
      }
    } catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}
