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
      spacing: 16,
      children: [
        FCard(
          title: const Text('人民币理财收益'),
          mainAxisSize: MainAxisSize.max,
          child: Text('￥${con.rmbProfit()}'),
        ),
        FCard(
          title: const Text('美元理财收益'),
          subtitle: Text('投资 ${con.usdAsset} 美元'),
          mainAxisSize: MainAxisSize.max,

          child: Text('\$ ${usd.$1}'),
        ),
        FCard(
          title: const Text('美元理财折合人民币收益'),
          mainAxisSize: MainAxisSize.max,
          child: Text('￥ ${usd.$2}'),
        ),
      ],
    );
  }
}
