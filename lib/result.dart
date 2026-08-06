import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:myapp/controller.dart';

/// 统一的卡片布局：固定内边距 + 纵向列，可选顶部角标。
class _InfoCard extends FCard {
  _InfoCard({
    this.badge,
    required this.children,
  }) : super(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              crossAxisAlignment: .start,
              children: [
                ?badge,
                ...children,
              ],
            ),
          ),
        );

  final Widget? badge;
  final List<Widget> children;
}

class Result extends ConsumerWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(ctrlProvider); // 订阅 state 变化，触发 rebuild
    final con = ref.read(ctrlProvider.notifier);

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
              _InfoCard(
                children: [
                  const Text('美元汇率盈亏'),
                  Text('本金 \$ ${con.usdAsset}'),
                  Text('￥${con.usdExchangePnL()}'),
                ],
              ),
              const Icon(FLucideIcons.plus, size: 48),
              _InfoCard(
                children: [
                  const Text('美元理财收益'),
                  Text('\$ ${usd.usdProfit}'),
                  Text('￥${usd.rmbEquivalent}'),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: .center,
                spacing: 16,
                children: [
                  const Icon(FLucideIcons.equal, size: 48),
                  _TotalPnlCard(
                    usdProfit: usd.usdProfit,
                    usdAsset: con.usdAsset,
                    rmbEquivalent: usd.rmbEquivalent,
                    usdExchangePnL: con.usdExchangePnL(),
                    isWinner: usdWins,
                  ),
                ],
              ),
            ],
          )
        else ...[
          _InfoCard(
            children: [
              const Text('美元汇率盈亏'),
              Text('本金 \$ ${con.usdAsset}'),
              Text('￥${con.usdExchangePnL()}'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              const Icon(FLucideIcons.plus, size: 48),
              _InfoCard(
                children: [
                  const Text('美元理财收益'),
                  Text('\$ ${usd.usdProfit}'),
                  Text('￥${usd.rmbEquivalent}'),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              const Icon(FLucideIcons.equal, size: 48),
              _TotalPnlCard(
                usdProfit: usd.usdProfit,
                usdAsset: con.usdAsset,
                rmbEquivalent: usd.rmbEquivalent,
                usdExchangePnL: con.usdExchangePnL(),
                isWinner: usdWins,
              ),
            ],
          ),
        ],
        SizedBox(height: 16),
        Builder(
          builder: (context) {
            final breakEven = con.breakEvenExchangeRate();
            // 滑块范围 6.0~8.0，将汇率转换为 0~1 位置
            final markPos = ((breakEven - 6.0) / 2.0).clamp(0.0, 1.0);
            return _InfoCard(
              children: [
                Text(
                  '调整到期日汇率：${con.finalExchangeFromSlider.toStringAsFixed(2)}',
                ),
                FSlider(
                  marks: [
                    FSliderMark(
                      value: markPos,
                      label: Text('盈亏平衡点 ${breakEven.toStringAsFixed(2)}'),
                      tick: true,
                    ),
                  ],
                  control: FSliderControl.managedContinuous(
                    controller: con.finalExchangeSliderCon,
                    onChange: (_) =>
                        WidgetsBinding.instance.addPostFrameCallback(
                      (_) => ref.read(ctrlProvider.notifier).refreshCalc(),
                    ),
                  ),
                  tooltipBuilder: (_, v) =>
                      Text((6.0 + v * 2.0).toStringAsFixed(2)),
                ),
              ],
            );
          },
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
  Widget build(BuildContext context) => _InfoCard(
        badge: isWinner ? FBadge(child: const Text('收益更高 🏆')) : null,
        children: [
          const Text('人民币理财收益'),
          Text('￥$profit'),
        ],
      );
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
  Widget build(BuildContext context) => _InfoCard(
        badge: isWinner ? FBadge(child: const Text('收益更高 🏆')) : null,
        children: [
          const Text('美元理财总盈亏'),
          Text('\$ ${(usdProfit + usdAsset).toPrecision(3)}'),
          Text('￥${(rmbEquivalent + usdExchangePnL).toPrecision(3)}'),
        ],
      );
}
