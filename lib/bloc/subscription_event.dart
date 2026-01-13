part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class LoadSubscriptionPlans extends SubscriptionEvent {}

class LoadPlanDetails extends SubscriptionEvent {
  final int planId;

  const LoadPlanDetails({required this.planId});

  @override
  List<Object> get props => [planId];
}

class CheckSubscriptionStatus extends SubscriptionEvent {}

class InitializePayment extends SubscriptionEvent {
  final int planId;

  const InitializePayment({required this.planId});

  @override
  List<Object> get props => [planId];
}
