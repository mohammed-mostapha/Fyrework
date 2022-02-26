import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({
    @required this.message,
    @required this.success,
  });
}

class StripeServices {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
  static Uri paymentApiUri = Uri.parse(paymentApiUrl);
  static String secret = 'sk_test_HfgOrlOugEBdMwOVMJiKRb63008T1xHhms';

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeServices.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: 'pk_test_3cXl3FkRpnNrY7ZWuuNRq8Rn00QX5CW6FW',
      androidPayMode: 'test',
      merchantId: 'Fyrework',
    ));
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response =
          await http.post(paymentApiUri, headers: headers, body: body);
      return jsonDecode(response.body);
    } catch (error) {
      print('error Happened');
      throw error;
    }
  }

  static Future<StripeTransactionResponse> payWithCard(
      {@required String amount, @required String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      var paymentIntent =
          await StripeServices.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
        ),
      );

      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
          message: 'Transaction successful, preparing your advert',
          success: true,
        );
      } else {
        return StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }
    } on PlatformException catch (error) {
      return StripeServices.getErrorAndAnalyze(error);
    } catch (error) {
      return StripeTransactionResponse(
        message: 'Transaction failed',
        success: false,
      );
    }
  }

  static getErrorAndAnalyze(error) {
    String message = 'Something went wrong';
    if (error.code == 'cancelled') {
      message = 'Transaction canceled';
    }
    return StripeTransactionResponse(
      message: message,
      success: false,
    );
  }
}
