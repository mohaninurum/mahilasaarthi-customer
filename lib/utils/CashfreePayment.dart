import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

import 'package:mahilasaarthi/constants/api.dart';
import 'package:mahilasaarthi/services/auth.service.dart';

class CashfreePayment {
  var cfPaymentGatewayService = CFPaymentGatewayService();
  BuildContext? context;
  Function(String orderId)? onSuccess;
  Function(String error, String orderId)? onError;

  void init(BuildContext ctx, {Function(String orderId)? onSuccessCallback, Function(String error, String orderId)? onErrorCallback}) {
    context = ctx;
    onSuccess = onSuccessCallback;
    onError = onErrorCallback;
    cfPaymentGatewayService.setCallback(verifyPayment, onErrorCallbackInternal);
  }

  void verifyPayment(String orderId) async {
    print("Cashfree Payment Success for $orderId");
    try {
      final token = await AuthServices.getAuthBearerToken();
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/cashfree/verify-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"order_id": orderId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'SUCCESS') {
          if (onSuccess != null) {
            onSuccess!(orderId);
          }
          return;
        }
      }
      
      // If verification failed on backend
      print("Backend verification failed: ${response.body}");
      if (onError != null) {
        onError!("Payment successful but verification failed on server", orderId);
      }
    } catch (e) {
      print("Verification error: $e");
      if (onError != null) {
        onError!("Verification error", orderId);
      }
    }
  }

  void onErrorCallbackInternal(dynamic errorResponse, String orderId) {
    String errorMsg = "Payment failed";
    try {
      errorMsg = errorResponse.getMessage() ?? "Payment failed";
    } catch (e) {
      print(e);
    }
    print("Cashfree Payment failed: $errorMsg");
    if (onError != null) {
      onError!(errorMsg, orderId);
    }
  }

  // This calls the Laravel backend to get the payment_session_id
  Future<void> startPayment({required double amount, required String customerId, required String customerPhone}) async {
    try {
      final String orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";
      
      final token = await AuthServices.getAuthBearerToken();
      // Call Laravel Backend API
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/cashfree/create-order'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Send Auth token
        },
        body: jsonEncode({
          "order_amount": amount,
          "customer_id": customerId,
          "customer_phone": customerPhone
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'SUCCESS' && data['payment_session_id'] != null) {
          final String sessionToken = data['payment_session_id'];
          final String backendOrderId = data['order_id'] ?? orderId;

          var session = CFSessionBuilder()
              .setEnvironment(CFEnvironment.PRODUCTION) 
              .setOrderId(backendOrderId)
              .setPaymentSessionId(sessionToken)
              .build();

          var webCheckout = CFWebCheckoutPaymentBuilder()
              .setSession(session)
              .build();

          cfPaymentGatewayService.doPayment(webCheckout);
        } else {
          print("Error from backend Cashfree order: ${response.body}");
          if (onError != null) {
            onError!("Failed to get session from backend", orderId);
          }
        }
      } else {
        print("Error HTTP calling backend Cashfree order: ${response.body}");
        if (onError != null) {
          onError!("Failed to connect to backend", orderId);
        }
      }
    } catch (e) {
      print(e);
      if (onError != null) {
        onError!(e.toString(), "");
      }
    }
  }
}
