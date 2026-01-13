import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swap2godriver/models/auth_model.dart';
import 'package:swap2godriver/repo/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await authRepository.login(event.email, event.password);
      if (response.success) {
        if (response.data != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', response.data!.token);
        }
        emit(LoginSuccess(response: response));
      } else {
        emit(LoginFailure(error: response.message));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
