import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

class Con extends GetxController {
  final TextEditingController assetInputCon = TextEditingController(
    text: '10000',
  );
  final TextEditingController curExchangeInputCon = TextEditingController(
    text: '7.0',
  );
  final TextEditingController finalExchangeInputCon = TextEditingController(
    text: '7.0',
  );

  // rmb 年化利率
  final TextEditingController rmbRateInputCon = TextEditingController(
    text: '1.4',
  );

  // usd 年化利率
  final TextEditingController usdRateInputCon = TextEditingController(
    text: '4.0',
  );

  final FDateFieldController finalDateInputCon = FDateFieldController(
    date: DateTime.now().add(const Duration(days: 365)),
  );

  var calc = 0.obs;

  double rmbProfit() {
    final rmbAsset = double.tryParse(assetInputCon.text) ?? 0;
    final rmbRate = double.tryParse(rmbRateInputCon.text) ?? 0;

    final days =
        finalDateInputCon.value?.difference(DateTime.now()).inDays.toDouble() ??
        0;

    final rmbProfit = rmbAsset * rmbRate / 100 * days / 365;

    return rmbProfit.toPrecision(3);
  }

  (double, double) usdProfit() {
    final rmbAsset = double.tryParse(assetInputCon.text) ?? 0;
    final curExchange = double.tryParse(curExchangeInputCon.text) ?? 1;
    final finalExchange = double.tryParse(finalExchangeInputCon.text) ?? 1;
    final usdRate = double.tryParse(usdRateInputCon.text) ?? 0;

    final days =
        finalDateInputCon.value?.difference(DateTime.now()).inDays.toDouble() ??
        0;

    final usdAsset = rmbAsset / curExchange;
    final usdProfit = usdAsset * usdRate / 100 * days / 365;

    return (
      usdProfit.toPrecision(3),
      (usdProfit * finalExchange).toPrecision(3),
    );
  }
}
