import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:forui/forui.dart';

part 'controller.g.dart';

extension NumPrecision on num {
  double toPrecision(int fractionDigits) =>
      double.parse(toStringAsFixed(fractionDigits));
}

@Riverpod(keepAlive: true)
class Ctrl extends _$Ctrl {
  @override
  int build() => 0;

  int tabIndex = 0;

  final TextEditingController assetInputCon = TextEditingController(
    text: '10000',
  );
  final TextEditingController curExchangeInputCon = TextEditingController(
    text: '7.0',
  );
  // 到期日汇率滑块（6.0~8.0，百分比 = (rate-6)/2）
  // 初始汇率 7.0 对应 max = 0.5
  final FContinuousSliderController finalExchangeSliderCon =
      FContinuousSliderController(
        value: FSliderValue(max: 0.5),
        stepPercentage: 0.01,
      );

  double get finalExchangeFromSlider =>
      6.0 + finalExchangeSliderCon.value.max * 2.0;

  // rmb 年化利率
  final TextEditingController rmbRateInputCon = TextEditingController(
    text: '1.4',
  );

  // usd 年化利率
  final TextEditingController usdRateInputCon = TextEditingController(
    text: '4.0',
  );

  final FDateSelectionController<DateTime?> finalDateInputCon =
      FDateSelectionController.single(
    initial: DateTime.now().add(const Duration(days: 365)),
  );

  final TextEditingController daysInputCon = TextEditingController(text: '365');

  final ScrollController scrollCon = ScrollController();

  void incrementCalc() {
    state++;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollCon.animateTo(
        scrollCon.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void refreshCalc() {
    state++;
  }

  int get profitDays {
    if (tabIndex == 0) {
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
    final finalExchange = finalExchangeFromSlider;

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

  /// 盈亏平衡点汇率：totalUsdPnl == rmbProfit 时对应的到期日汇率
  double breakEvenExchangeRate() {
    final curExchange = double.tryParse(curExchangeInputCon.text) ?? 1;
    final rmbRate = double.tryParse(rmbRateInputCon.text) ?? 0;
    final usdRate = double.tryParse(usdRateInputCon.text) ?? 0;
    final days = profitDays.toDouble();

    final rmbFactor = 1 + rmbRate / 100 * days / 365;
    final usdFactor = 1 + usdRate / 100 * days / 365;

    return (curExchange * rmbFactor / usdFactor).toPrecision(4);
  }

  ({double usdProfit, double rmbEquivalent}) usdProfitWithExchange() {
    final finalExchange = finalExchangeFromSlider;
    final usdRate = double.tryParse(usdRateInputCon.text) ?? 0;

    final days = profitDays.toDouble();

    final usdProfit = usdAsset * usdRate / 100 * days / 365;

    return (
      usdProfit: usdProfit.toPrecision(3),
      rmbEquivalent: (usdProfit * finalExchange).toPrecision(3),
    );
  }
}
