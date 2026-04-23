import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:myapp/controller.dart';

class Result extends ConsumerWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(conProvider); // 订阅 state 变化，触发 rebuild
    final con = ref.read(conProvider.notifier);

    final usd = con.usdProfitWithExchange();
    final rmbProfit = con.rmbProfit();
    final totalUsdPnl = (usd.rmbEquivalent + con.usdExchangePnL()).toPrecision(
      3,
    );
    final usdWins = totalUsdPnl > rmbProfit;

    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        _RmbProfitCard(profit: rmbProfit, isWinner: !usdWins),
        FDivider(),
        if (size.width > size.height)
          Row(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              FCard(
                title: const Text('美元汇率盈亏'),
                subtitle: Text('本金 \$ ${con.usdAsset}'),
                child: Text('￥${con.usdExchangePnL()}'),
              ),
              Icon(FIcons.plus, size: 48),
              FCard(
                title: const Text('美元理财收益'),
                subtitle: Text('\$ ${usd.usdProfit}'),
                child: Text('￥${usd.rmbEquivalent}'),
              ),
            ],
          )
        else ...[
          FCard(
            title: const Text('美元汇率盈亏'),
            subtitle: Text('本金 \$ ${con.usdAsset}'),
            child: Text('￥${con.usdExchangePnL()}'),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              Icon(FIcons.plus, size: 48),
              FCard(
                title: const Text('美元理财收益'),
                subtitle: Text('\$ ${usd.usdProfit}'),
                child: Text('￥${usd.rmbEquivalent}'),
              ),
            ],
          ),
        ],
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: .center,
          spacing: 16,
          children: [
            Icon(FIcons.equal, size: 48),
            _TotalPnlCard(
              usdProfit: usd.usdProfit,
              usdAsset: con.usdAsset,
              rmbEquivalent: usd.rmbEquivalent,
              usdExchangePnL: con.usdExchangePnL(),
              isWinner: usdWins,
            ),
          ],
        ),
        SizedBox(height: 16),
        FCard(
          title: Text(
            '调整到期日汇率：${con.finalExchangeFromSlider.toStringAsFixed(2)}',
          ),
          child: FSlider(
            // label: Text(
            //   '到期日美元/人民币汇率：${con.finalExchangeFromSlider.toStringAsFixed(2)}',
            // ),
            control: FSliderControl.managedContinuous(
              controller: con.finalExchangeSliderCon,
              onChange: (_) => ref.read(conProvider.notifier).refreshCalc(),
            ),
            tooltipBuilder: (_, v) => Text((6.0 + v * 2.0).toStringAsFixed(2)),
          ),
        ),
      ],
    );
  }
}

class _RmbProfitCard extends StatelessWidget {
  final double profit;
  final bool isWinner;

  const _RmbProfitCard({required this.profit, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return FCard(
      image: isWinner ? FBadge(child: const Text('收益更高 🏆')) : null,
      title: const Text('人民币理财收益'),
      child: Text('￥$profit'),
    );
  }
}

class _TotalPnlCard extends StatelessWidget {
  final double usdProfit;
  final double usdAsset;
  final double rmbEquivalent;
  final double usdExchangePnL;
  final bool isWinner;

  const _TotalPnlCard({
    required this.usdProfit,
    required this.usdAsset,
    required this.rmbEquivalent,
    required this.usdExchangePnL,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    return FCard(
      image: isWinner ? FBadge(child: const Text('收益更高 🏆')) : null,
      title: const Text('美元理财总盈亏'),
      subtitle: Text('\$ ${(usdProfit + usdAsset).toPrecision(3)}'),
      child: Text('￥${(rmbEquivalent + usdExchangePnL).toPrecision(3)}'),
    );
  }
}
