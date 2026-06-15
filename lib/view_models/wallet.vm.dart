import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mahilasaarthi/models/wallet.dart';
import 'package:mahilasaarthi/models/wallet_transaction.dart';
import 'package:mahilasaarthi/requests/wallet.request.dart';
import 'package:mahilasaarthi/services/app.service.dart';
import 'package:mahilasaarthi/view_models/payment.view_model.dart';
import 'package:mahilasaarthi/views/pages/wallet/wallet_transfer.page.dart';
import 'package:mahilasaarthi/widgets/bottomsheets/wallet_amount_entry.bottomsheet.dart';
import 'package:mahilasaarthi/widgets/finance/wallet_address.bottom_sheet.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:mahilasaarthi/utils/CashfreePayment.dart';
import 'package:mahilasaarthi/services/auth.service.dart';
import '../utils/Phonepe.dart';

class WalletViewModel extends PaymentViewModel {
  //
  WalletViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  WalletRequest walletRequest = WalletRequest();
  Wallet? wallet;
  RefreshController refreshController = RefreshController();
  List<WalletTransaction> walletTransactions = [];
  int queryPage = 1;
  StreamSubscription<bool>? refreshWalletBalanceSub;

  //
  initialise() async {
    await loadWalletData();

    refreshWalletBalanceSub = AppService().refreshWalletBalance.listen(
      (value) {
        loadWalletData();
      },
    );
  }

  dispose() {
    super.dispose();
    refreshWalletBalanceSub?.cancel();
  }

  //
  loadWalletData() async {
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }

    getWalletBalance();
    getWalletTransactions();
  }

  //
  getWalletBalance() async {
    setBusy(true);
    try {
      wallet = await walletRequest.walletBalance();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  getWalletTransactions({bool initialLoading = true}) async {
    //
    if (initialLoading) {
      setBusyForObject(walletTransactions, true);
      refreshController.refreshCompleted();
      queryPage = 1;
    } else {
      queryPage = queryPage + 1;
    }

    try {
      //
      final mWalletTransactions = await walletRequest.walletTransactions(
        page: queryPage,
      );
      //
      if (initialLoading) {
        walletTransactions = mWalletTransactions;
      } else {
        walletTransactions.addAll(mWalletTransactions);
        refreshController.loadComplete();
      }
      clearErrors();
    } catch (error) {
      print("Wallet transactions error ==> $error");
      setErrorForObject(walletTransactions, error);
    }
    setBusyForObject(walletTransactions, false);
  }

  //
  showAmountEntry() async {
    await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WalletAmountEntryBottomSheet(
          onSubmit: (String amount) {
            viewContext.pop();
            startCashfreeTopUp(amount);
          },
        );
      },
    );
  }

  void startCashfreeTopUp(String amount) {
    setBusy(true);
    final user = AuthServices.currentUser;
    CashfreePayment payment = CashfreePayment();
    payment.init(
      viewContext, 
      onSuccessCallback: (orderId) {
        setBusy(false);
        toastSuccessful("Wallet recharged successfully".tr());
        loadWalletData(); // Refresh wallet balance
      },
      onErrorCallback: (error, orderId) {
        setBusy(false);
        toastError(error);
      }
    );
    payment.startPayment(
      amount: double.parse(amount), 
      customerId: user?.id.toString() ?? "1", 
      customerPhone: user?.phone ?? "9999999999"
    );
  }

  //
  initiateWalletTopUp(String amount) async {
    setBusy(true);

    try {
      final link = await walletRequest.walletTopup(amount,"");
      // await openExternalWebpageLink(link);
      await openWebpageLink(link, embeded: true);
      clearErrors();
    } catch (error) {
      setError(error);
      toastError("$error");
      print("error >> $error");
    }
    setBusy(false);
  }

  //Wallet transfer
  showWalletTransferEntry() async {
    final result = await viewContext.push(
      (context) => WalletTransferPage(wallet!),
    );

    //
    if (result == null) {
      return;
    }
    //
    getWalletBalance();
    getWalletTransactions();
  }

  showMyWalletAddress() async {
    setBusyForObject(showMyWalletAddress, true);
    final apiResponse = await walletRequest.myWalletAddress();
    //
    if (apiResponse.allGood) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: viewContext,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (ctx) => WalletAddressBottomSheet(apiResponse),
      );
    } else {
      toastError(apiResponse.message ?? "Error loading wallet address".tr());
    }
    setBusyForObject(showMyWalletAddress, false);
  }
}
