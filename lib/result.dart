import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:myapp/controller.dart';

class Result extends ConsumerWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final con = ref.read(conProvider);

    final usd = con.usdProfitWithExchange();
    final size = MediaQuery.of(context).size;

    return Column(
      // spacing: 16,
      children: [
        FCard(title: const Text('人民币理财收益'), child: Text('￥${con.rmbProfit()}')),
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
                subtitle: Text('\$ ${usd.$1}'),
                child: Text('￥${usd.$2}'),
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
                subtitle: Text('\$ ${usd.$1}'),
                child: Text('￥${usd.$2}'),
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
            FCard(
              title: const Text('美元理财总盈亏'),
              subtitle: Text('\$ ${(usd.$1 + con.usdAsset).toPrecision(3)}'),
              child: Text('￥${(usd.$2 + con.usdExchangePnL()).toPrecision(3)}'),
            ),
          ],
        ),
      ],
    );
  }
}
