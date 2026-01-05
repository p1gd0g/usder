import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:myapp/controller.dart';
import 'dart:developer' as developer;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stack_trace/stack_trace.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((
  //   x,
  // ) {
  //   FirebaseAnalytics.instance.logAppOpen();
  // });

  final theme = FThemes.zinc.dark;
  final con = Get.put(Con());

  runApp(
    GetMaterialApp(
      logWriterCallback: (value, {isError = false}) {
        // void defaultLogWriterCallback(String value, {bool isError = false}) {
        if (isError || Get.isLogEnable) {
          developer.log(
            '[${DateTime.now()}] $value\n${Trace.current().terse.frames.getRange(1, 4).join('\n')}',
            name: 'GETX',
          );
        }
        // }
      },

      theme: theme.toApproximateMaterialTheme(),
      home: FScaffold(
        header: AppBar(title: const Text('美元/人民币理财对比')),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              FTextField(
                control: FTextFieldControl.managed(
                  controller: con.assetInputCon,
                ),
                label: const Text('要投资的人民币金额'),
                keyboardType: .number,
                onTap: () {
                  con.assetInputCon.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: con.assetInputCon.text.length,
                  );
                },
              ),

              FTextField(
                control: FTextFieldControl.managed(
                  controller: con.rmbRateInputCon,
                ),
                label: const Text('人民币年化利率（%）'),
                keyboardType: .number,
                onTap: () {
                  con.rmbRateInputCon.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: con.rmbRateInputCon.text.length,
                  );
                },
              ),

              FTextField(
                control: FTextFieldControl.managed(
                  controller: con.curRateInputCon,
                ),
                label: const Text('当前美元/人民币汇率'),
                keyboardType: .number,
                onTap: () {
                  con.curRateInputCon.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: con.curRateInputCon.text.length,
                  );
                },
              ),

              FTextField(
                control: FTextFieldControl.managed(
                  controller: con.usdRateInputCon,
                ),
                label: const Text('美元年化利率（%）'),
                keyboardType: .number,
                onTap: () {
                  con.usdRateInputCon.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: con.usdRateInputCon.text.length,
                  );
                },
              ),

              FDateField.calendar(
                label: const Text('到期日'),
                control: FDateFieldControl.managed(
                  controller: con.finalDateInputCon,
                ),
              ),
              FTextField(
                control: FTextFieldControl.managed(
                  controller: con.finalRateInputCon,
                ),
                label: const Text('到期日美元/人民币汇率'),
                keyboardType: .number,
                onTap: () {
                  con.finalRateInputCon.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: con.finalRateInputCon.text.length,
                  );
                },
              ),

              FButton(
                onPress: () {
                  con.calc.value++;
                },
                prefix: const Icon(FIcons.calculator),
                child: const Text('计算'),
              ),

              Obx(() {
                if (con.calc.value == 0) {
                  return const SizedBox();
                }

                Get.log('input, ${con.assetInputCon.text}');
                return FCard();
              }),
            ],
          ),
        ),
      ),
    ),
  );
}
