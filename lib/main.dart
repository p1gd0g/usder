import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:myapp/controller.dart';
import 'package:myapp/result.dart';
import 'dart:developer' as developer;
import 'package:stack_trace/stack_trace.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh'),
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: FLocalizations.localizationsDelegates,
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
        header: AppBar(
          title: const Text('USDer - 美元/人民币理财对比'),
          actions: [
            PopupMenuButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(FIcons.ellipsis),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 1,
                    child: Text('Gridder - 网格交易测试工具'),
                    onTap: () => launchUrlString('https://x.p1gd0g.cc'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('ATRx - ETF 波动对比'),
                    onTap: () => launchUrlString('https://x.p1gd0g.cc'),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Text('关注作者 @p1gd0g'),
                    onTap: () => launchUrlString(
                      'https://mp.weixin.qq.com/s/yoFS-PvjhuvyNDBxZNO9Vg',
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
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
                  controller: con.curExchangeInputCon,
                ),
                label: const Text('当前美元/人民币汇率'),
                keyboardType: .number,
                onTap: () {
                  con.curExchangeInputCon.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: con.curExchangeInputCon.text.length,
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
                  controller: con.finalExchangeInputCon,
                ),
                label: const Text('到期日美元/人民币汇率'),
                keyboardType: .number,
                onTap: () {
                  con.finalExchangeInputCon.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: con.finalExchangeInputCon.text.length,
                  );
                },
              ),

              FButton(
                onPress: () {
                  con.calc.value++;
                },
                prefix: const Icon(FIcons.calculator),
                child: const Text('计算收益（不构成投资建议）'),
              ),

              Obx(() {
                if (con.calc.value == 0) {
                  return const SizedBox();
                }

                Get.log('input, ${con.assetInputCon.text}');
                return Result();
              }),
            ],
          ),
        ),
      ),
    ),
  );
}
