import 'package:equatable/equatable.dart';
import 'package:swap2godriver/models/auth_model.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final RegisterRequest request;

  const RegisterSubmitted({required this.request});

  @override
  List<Object> get props => [request];
}
