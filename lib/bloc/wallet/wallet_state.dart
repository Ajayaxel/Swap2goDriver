part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletResponse response;

  const WalletLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class WalletError extends WalletState {
  final String message;

  const WalletError({required this.message});

  @override
  List<Object> get props => [message];
}

class WalletDepositLoading extends WalletState {
  final WalletResponse? walletData;

  const WalletDepositLoading({this.walletData});

  @override
  List<Object> get props => [if (walletData != null) walletData!];
}

class WalletDepositSuccess extends WalletState {
  final String paymentUrl;
  final WalletResponse? walletData;

  const WalletDepositSuccess({required this.paymentUrl, this.walletData});

  @override
  List<Object> get props => [paymentUrl, if (walletData != null) walletData!];
}

class WalletDepositError extends WalletState {
  final String message;
  final WalletResponse? walletData;

  const WalletDepositError({required this.message, this.walletData});

  @override
  List<Object> get props => [message, if (walletData != null) walletData!];
}
