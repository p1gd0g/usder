import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:myapp/conn.dart';
import 'package:myapp/controller.dart';
import 'package:myapp/result.dart';
import 'dart:developer' as developer;
import 'package:stack_trace/stack_trace.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((
  //   x,
  // ) {
  //   FirebaseAnalytics.instance.logAppOpen();
  // });

  final theme = FThemes.zinc.dark;
  final con = Get.put(Con());

  final conn = Get.put(Conn());

  runApp(
    GetMaterialApp(
      navigatorObservers: [PosthogObserver()],
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
        header: FHeader(
          title: const Text('USDer - 美元/人民币理财对比'),
          suffixes: [
            FPopoverMenu.tiles(
              menu: [
                FTileGroup(
                  children: [
                    FTile(
                      title: const Text('Gridder - 网格交易测试工具'),
                      onPress: () => launchUrlString('https://x.p1gd0g.cc'),
                    ),
                    FTile(
                      title: const Text('ATRx - ETF 波动对比'),
                      onPress: () => launchUrlString('https://x.p1gd0g.cc'),
                    ),
                    FTile(
                      title: const Text('关注作者 @p1gd0g'),
                      onPress: () => launchUrlString(
                        'https://mp.weixin.qq.com/s/yoFS-PvjhuvyNDBxZNO9Vg',
                      ),
                    ),
                  ],
                ),
              ],
              builder: (context, value, child) {
                return FHeaderAction(
                  icon: Icon(FIcons.ellipsis),
                  onPress: () {
                    value.toggle();
                  },
                );
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

              FutureBuilder<String>(
                future: conn.getRfxSpQuot(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != .done) {
                    return const FCircularProgress();
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                  } else {
                    con.curExchangeInputCon.text = snapshot.data!;
                  }

                  return FTextField(
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
                  );
                },
              ),

              FutureBuilder<String>(
                future: conn.getUsdRate(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != .done) {
                    return const FCircularProgress();
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                  } else {
                    con.usdRateInputCon.text = snapshot.data!;
                  }

                  return FTextField(
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
                  );
                },
              ),

              FTabs(
                control: FTabControl.managed(initial: 0),
                onPress: (value) {
                  con.tabIndex = value;
                },
                children: [
                  FTabEntry(
                    label: Text('按到期日'),
                    child: FDateField.calendar(
                      label: const Text('到期日'),
                      control: FDateFieldControl.managed(
                        controller: con.finalDateInputCon,
                      ),
                    ),
                  ),
                  FTabEntry(
                    label: Text('按天数'),
                    child: FTextField(
                      control: FTextFieldControl.managed(
                        controller: con.daysInputCon,
                      ),
                      label: const Text('投资天数'),
                      keyboardType: .number,
                      onTap: () {
                        con.daysInputCon.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: con.daysInputCon.text.length,
                        );
                      },
                    ),
                  ),
                ],
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
