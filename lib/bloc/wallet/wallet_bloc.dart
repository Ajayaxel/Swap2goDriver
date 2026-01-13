import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swap2godriver/models/wallet_model.dart';
import 'package:swap2godriver/repo/wallet_repo.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc({required this.walletRepository}) : super(WalletInitial()) {
    on<FetchWalletBalance>(_onFetchWalletBalance);
    on<DepositWallet>(_onDepositWallet);
  }

  Future<void> _onFetchWalletBalance(
    FetchWalletBalance event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      final response = await walletRepository.getWalletBalance();
      if (response.success) {
        emit(WalletLoaded(response: response));
      } else {
        emit(WalletError(message: response.message));
      }
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onDepositWallet(
    DepositWallet event,
    Emitter<WalletState> emit,
  ) async {
    WalletResponse? currentData;
    if (state is WalletLoaded) {
      currentData = (state as WalletLoaded).response;
    } else if (state is WalletDepositError) {
      currentData = (state as WalletDepositError).walletData;
    } else if (state is WalletDepositSuccess) {
      currentData = (state as WalletDepositSuccess).walletData;
    }

    emit(WalletDepositLoading(walletData: currentData));
    try {
      final response = await walletRepository.depositWallet(event.amount);
      if (response.success && response.data != null) {
        emit(
          WalletDepositSuccess(
            paymentUrl: response.data!.paymentUrl,
            walletData: currentData,
          ),
        );
        // Refresh balance after initiating deposit?
        // Usually we wait for payment completion, but for now we just open the URL.
        // We might want to reload the wallet balance after returning from the webview.
        add(FetchWalletBalance());
      } else {
        emit(
          WalletDepositError(
            message: response.message,
            walletData: currentData,
          ),
        );
      }
    } catch (e) {
      emit(WalletDepositError(message: e.toString(), walletData: currentData));
    }
  }
}
