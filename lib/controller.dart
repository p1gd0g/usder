import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:forui/forui.dart';

part 'controller.g.dart';

extension NumPrecision on num {
  double toPrecision(int fractionDigits) =>
      double.parse(toStringAsFixed(fractionDigits));
}

@Riverpod(keepAlive: true)
class Con extends _$Con {
  @override
  int build() => 0;

  int tabIndex = 0;

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

  final TextEditingController daysInputCon = TextEditingController(text: '365');

  void incrementCalc() {
    state++;
  }

  int get profitDays {
    if (tabIndex == 1) {
      return int.tryParse(daysInputCon.text) ?? 0;
    }

    return (finalDateInputCon.value?.difference(DateTime.now()).inDays ?? 0) +
        1;
  }

  double get usdAsset {
    final rmbAsset = double.tryParse(assetInputCon.text) ?? 0;
    final curExchange = double.tryParse(curExchangeInputCon.text) ?? 1;

    final usdAsset = rmbAsset / curExchange;
    return usdAsset.toPrecision(3);
  }

  double usdExchangePnL() {
    final curExchange = double.tryParse(curExchangeInputCon.text) ?? 1;
    final finalExchange = double.tryParse(finalExchangeInputCon.text) ?? 1;

    final pnl = usdAsset * (finalExchange - curExchange);

    return pnl.toPrecision(3);
  }

  double rmbProfit() {
    final rmbAsset = double.tryParse(assetInputCon.text) ?? 0;
    final rmbRate = double.tryParse(rmbRateInputCon.text) ?? 0;

    final days = profitDays.toDouble();

    final rmbProfit = rmbAsset * rmbRate / 100 * days / 365;

    return rmbProfit.toPrecision(3);
  }

  (double, double) usdProfitWithExchange() {
    final finalExchange = double.tryParse(finalExchangeInputCon.text) ?? 1;
    final usdRate = double.tryParse(usdRateInputCon.text) ?? 0;

    final days = profitDays.toDouble();

    final usdProfit = usdAsset * usdRate / 100 * days / 365;

    return (
      usdProfit.toPrecision(3),
      (usdProfit * finalExchange).toPrecision(3),
    );
  }
}
