import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:myapp/conn.dart';
import 'package:myapp/controller.dart';
import 'package:myapp/result.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final theme =
      const <TargetPlatform>{
        .android,
        .iOS,
        .fuchsia,
      }.contains(defaultTargetPlatform)
      ? FTheme.neutral.dark.touch
      : FTheme.neutral.dark.desktop;
  runApp(
    ProviderScope(
      child: FTheme(
        data: theme,
        child: MaterialApp(
          builder: (context, child) {
            final typography = context.theme.typography;
            return DefaultTextStyle(style: typography.body.md, child: child!);
          },
          navigatorObservers: [PosthogObserver()],
          debugShowCheckedModeBanner: false,
          locale: const Locale('zh'),
          supportedLocales: FLocalizations.supportedLocales,
          localizationsDelegates: FLocalizations.localizationsDelegates,
          theme: theme.toApproximateMaterialTheme(),
          home: const HomePage(),
        ),
      ),
    ),
  );
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final con = ref.read(ctrlProvider.notifier);

    return FScaffold(
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
                icon: const Icon(FLucideIcons.ellipsis),
                onPress: () {
                  value.toggle();
                },
              );
            },
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: con.scrollCon,
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            FTextField(
              control: FTextFieldControl.managed(controller: con.assetInputCon),
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

            Consumer(
              builder: (context, ref, child) {
                final asyncValue = ref.watch(rfxSpQuotProvider);
                return asyncValue.when(
                  loading: () => const FCircularProgress(),
                  error: (e, _) => FTextField(
                    control: FTextFieldControl.managed(
                      controller: con.curExchangeInputCon,
                    ),
                    label: const Text('当前美元/人民币汇率'),
                    keyboardType: .number,
                  ),
                  data: (value) {
                    if (value.isNotEmpty) {
                      con.curExchangeInputCon.text = value;
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
                );
              },
            ),

            Consumer(
              builder: (context, ref, child) {
                final asyncValue = ref.watch(usdRateProvider);
                return asyncValue.when(
                  loading: () => const FCircularProgress(),
                  error: (e, _) => FTextField(
                    control: FTextFieldControl.managed(
                      controller: con.usdRateInputCon,
                    ),
                    label: const Text('美元年化利率（%）'),
                    keyboardType: .number,
                  ),
                  data: (value) {
                    if (value.isNotEmpty) {
                      con.usdRateInputCon.text = value;
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
                FTabEntry(
                  label: Text('按到期日'),
                  child: FDateField.calendar(
                    label: const Text('到期日'),
                    selectionControl: FDateSelectionControl.managedSingle(
                      controller: con.finalDateInputCon,
                    ),
                  ),
                ),
              ],
            ),

            FButton(
              onPress: () {
                con.incrementCalc();
              },
              prefix: const Icon(FLucideIcons.calculator),
              child: const Text('计算收益（不构成投资建议）'),
            ),

            Consumer(
              builder: (context, ref, child) {
                final calc = ref.watch(ctrlProvider);
                if (calc == 0) {
                  return const SizedBox.shrink();
                }
                return const Result();
              },
            ),

            // if (calc == 0)
            //   const SizedBox()
            // else ...[
            //   Builder(
            //     builder: (context) {
            //       appLogger.i('input, ${con.assetInputCon.text}');
            //       return const Result();
            //     },
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
