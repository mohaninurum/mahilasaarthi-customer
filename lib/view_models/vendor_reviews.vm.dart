import 'package:flutter/material.dart';
import 'package:mahilasaarthi/models/review.dart';
import 'package:mahilasaarthi/models/vendor.dart';
import 'package:mahilasaarthi/requests/vendor.request.dart';
import 'package:mahilasaarthi/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class VendorReviewsViewModel extends MyBaseViewModel {
  //
  VendorReviewsViewModel(BuildContext context, Vendor vendor) {
    this.viewContext = context;
    this.vendor = vendor;
  }

  //
  Vendor? vendor;
  int queryPage = 1;
  List<Review> reviews = [];
  VendorRequest _vendorRequest = VendorRequest();
  RefreshController refreshController = RefreshController();

  @override
  void initialise() {
    super.initialise();
    getVendorReviews();
  }

  //
  getVendorReviews({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
      queryPage = 1;
    } else {
      queryPage++;
    }

    try {
      final mReviews = await _vendorRequest.getReviews(
        page: queryPage,
        vendorId: vendor!.id,
      );
      if (!initialLoading) {
        reviews.addAll(mReviews);
        refreshController.loadComplete();
      } else {
        reviews = mReviews;
      }
      clearErrors();
    } catch (error) {
      print("mReviews Error ==> $error");
      setError(error);
    }

    setBusy(false);
  }
}
