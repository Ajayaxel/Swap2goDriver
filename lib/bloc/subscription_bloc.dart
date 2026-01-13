import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swap2godriver/models/subscription_model.dart';
import 'package:swap2godriver/repo/subscription_repo.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository subscriptionRepository;

  SubscriptionBloc({required this.subscriptionRepository})
    : super(SubscriptionInitial()) {
    on<LoadSubscriptionPlans>(_onLoadSubscriptionPlans);
    on<LoadPlanDetails>(_onLoadPlanDetails);
    on<CheckSubscriptionStatus>(_onCheckSubscriptionStatus);
    on<InitializePayment>(_onInitializePayment);
  }

  Future<void> _onLoadSubscriptionPlans(
    LoadSubscriptionPlans event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final response = await subscriptionRepository.getPlans();
      emit(SubscriptionLoaded(plans: response.plans));
    } catch (e) {
      emit(SubscriptionError(message: e.toString()));
    }
  }

  Future<void> _onLoadPlanDetails(
    LoadPlanDetails event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      print('BLoC: Loading plan details for ID: ${event.planId}');
      final response = await subscriptionRepository.getPlanDetails(
        event.planId,
      );
      if (response.plan != null) {
        print('BLoC: Plan details loaded successfully');
        emit(PlanDetailsLoaded(plan: response.plan!));
      } else {
        print('BLoC: Plan details not found in response');
        emit(const SubscriptionError(message: 'Plan details not found'));
      }
    } catch (e) {
      print('BLoC Error loading plan details: $e');
      emit(SubscriptionError(message: e.toString()));
    }
  }

  Future<void> _onCheckSubscriptionStatus(
    CheckSubscriptionStatus event,
    Emitter<SubscriptionState> emit,
  ) async {
    // Don't emit loading here to avoid full screen loader on init
    try {
      final response = await subscriptionRepository.getMySubscription();
      emit(MySubscriptionLoaded(subscriptionData: response.data));
    } catch (e) {
      // Fail silently or handle error appropriately
      // emit(SubscriptionError(message: e.toString()));
    }
  }

  Future<void> _onInitializePayment(
    InitializePayment event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final response = await subscriptionRepository.initializePayment(
        event.planId,
      );
      if (response.data != null) {
        emit(PaymentInitialized(paymentData: response.data!));
      } else {
        emit(const SubscriptionError(message: 'Failed to initialize payment'));
      }
    } catch (e) {
      emit(SubscriptionError(message: e.toString()));
    }
  }
}
