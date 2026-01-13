part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class FetchWalletBalance extends WalletEvent {}

class DepositWallet extends WalletEvent {
  final double amount;

  const DepositWallet({required this.amount});

  @override
  List<Object> get props => [amount];
}
