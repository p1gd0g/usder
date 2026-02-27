import 'package:get/get.dart';

class Conn extends GetConnect {
  String rfxSpQuot =
      'https://www.chinamoney.com.cn/r/cms/www/chinamoney/data/fx/rfx-sp-quot.json';

  // 美元利率
  String usdRate =
      'https://www.bocwm.cn/webApi/cms/productNetWorth/getNetWorthImageByCode?productCode=RJHQDUSD01A&dayCount=5';
  String corsHost = 'https://cors.p1gd0g.cc';

  // https://cors.p1gd0g.cc?url=https://www.chinamoney.com.cn/r/cms/www/chinamoney/data/fx/rfx-sp-quot.json
  Future<String> getRfxSpQuot() async {
    final rsp = await get<String>(
      corsHost,
      query: {'url': rfxSpQuot},
      decoder: (data) {
        final json = RfxSpQuotJson.fromJson(data);
        return (json.records!.first.bidPrc!);
      },
    );
    return rsp.body!;
  }

  // https://www.bocwm.cn/webApi/cms/productNetWorth/getNetWorthImageByCode?productCode=RJHQDUSD01A&dayCount=5

  Future<String> getUsdRate() async {
    final rsp = await get<String>(
      corsHost,
      query: {'url': usdRate},
      decoder: (data) {
        final json = UsdRateJson.fromJson(data);
        return (json.sevenDayAnnualization!);
      },
    );
    return rsp.body!;
  }
}

class UsdRateJson {
  String? sevenDayAnnualization;

  UsdRateJson.fromJson(Map<String, dynamic> json) {
    sevenDayAnnualization = json['sevenDayAnnualization'];
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
