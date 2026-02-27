import 'package:get/get.dart';

class Conn extends GetConnect {
  String rfxSpQuot =
      'https://www.chinamoney.com.cn/r/cms/www/chinamoney/data/fx/rfx-sp-quot.json';
  String corsHost = 'https://cors.p1gd0g.cc';

  // https://cors.p1gd0g.cc?url=https://www.chinamoney.com.cn/r/cms/www/chinamoney/data/fx/rfx-sp-quot.json
  Future<double> getRfxSpQuot() async {
    final rsp = await get<double>(
      corsHost,
      query: {'url': rfxSpQuot},
      decoder: (data) {
        final json = RfxSpQuotJson.fromJson(data);
        return double.parse(json.records!.first.bidPrc!);
      },
    );
    return rsp.body!;
  }
}

class RfxSpQuotJson {
  List<Records>? records;

  RfxSpQuotJson({this.records});

  RfxSpQuotJson.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
  }
}

class Records {
  String? bidPrc;
  String? askPrc;
  String? midprice;
  String? time;
  String? ccyPair;

  Records({this.bidPrc, this.askPrc, this.midprice, this.time, this.ccyPair});

  Records.fromJson(Map<String, dynamic> json) {
    bidPrc = json['bidPrc'];
    askPrc = json['askPrc'];
    midprice = json['midprice'];
    time = json['time'];
    ccyPair = json['ccyPair'];
  }
}
