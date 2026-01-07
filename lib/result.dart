import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:myapp/controller.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    final con = Get.put(Con());

    final usd = con.usdProfitWithExchange();

    return Column(
      // spacing: 16,
      children: [
        FCard(title: const Text('人民币理财收益'), child: Text('￥${con.rmbProfit()}')),
        FDivider(),
        if (Get.width > Get.height)
          Row(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              FCard(
                title: const Text('美元汇率盈亏'),
                subtitle: Text('本金 \$ ${con.usdAsset}'),
                child: Text('￥${con.usdExchangePnL()}'),
              ),
              Icon(FIcons.plus),
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
              Icon(FIcons.plus),
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
            Icon(FIcons.equal),
            FCard(
              title: const Text('总盈亏'),
              subtitle: Text('\$ ${(usd.$1 + con.usdAsset).toPrecision(3)}'),
              child: Text('￥${(usd.$2 + con.usdExchangePnL()).toPrecision(3)}'),
            ),
          ],
        ),
      ],
    );
  }
}
