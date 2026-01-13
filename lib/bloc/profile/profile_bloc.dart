import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap2godriver/models/profile_model.dart';
import 'package:swap2godriver/repo/profile_repo.dart';

// Events
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> data;
  UpdateProfile(this.data);
}

class UpdateAvailability extends ProfileEvent {
  final bool isOnline;
  UpdateAvailability(this.isOnline);
}

// States
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final DriverProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  ProfileUpdateSuccess(this.message);
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateAvailability>(_onUpdateAvailability);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await repository.getProfile();
      if (response.success && response.data != null) {
        emit(ProfileLoaded(response.data!));
      } else {
        emit(ProfileError(response.message));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await repository.updateProfile(event.data);
      if (response.success) {
        emit(ProfileUpdateSuccess(response.message));
        add(LoadProfile()); // Reload profile to get updated data
      } else {
        emit(ProfileError(response.message));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateAvailability(
    UpdateAvailability event,
    Emitter<ProfileState> emit,
  ) async {
    // We don't want to show a full loading screen for a switch toggle if possible,
    // but for now let's keep it simple and consistent.
    // Or maybe we should optimistically update?
    // Let's stick to the standard flow: Loading -> Success/Error -> Reload
    emit(ProfileLoading());
    try {
      final response = await repository.updateAvailability(event.isOnline);
      if (response.success) {
        // We don't necessarily need to show a success message for the toggle,
        // but we definitely need to reload the profile to get the confirmed state.
        add(LoadProfile());
      } else {
        emit(ProfileError(response.message));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
