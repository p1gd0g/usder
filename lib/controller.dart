import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

class Con extends GetxController {
  final TextEditingController assetInputCon = TextEditingController(
    text: '10000',
  );
  final TextEditingController curRateInputCon = TextEditingController(
    text: '7.0',
  );
  final TextEditingController finalRateInputCon = TextEditingController(
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
}
