part of 'subscription_bloc.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionPlan> plans;

  const SubscriptionLoaded({required this.plans});

  @override
  List<Object> get props => [plans];
}

class PlanDetailsLoaded extends SubscriptionState {
  final SubscriptionPlan plan;

  const PlanDetailsLoaded({required this.plan});

  @override
  List<Object> get props => [plan];
}

class MySubscriptionLoaded extends SubscriptionState {
  final dynamic subscriptionData;

  const MySubscriptionLoaded({this.subscriptionData});

  @override
  List<Object?> get props => [subscriptionData];
}

class PaymentInitialized extends SubscriptionState {
  final PaymentData paymentData;

  const PaymentInitialized({required this.paymentData});

  @override
  List<Object> get props => [paymentData];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError({required this.message});

  @override
  List<Object> get props => [message];
}
