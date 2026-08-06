import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:myapp/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conn.g.dart';

final Dio _dio = Dio();

class Conn {
  static const String _rfxSpQuotURL =
      'https://www.chinamoney.com.cn/r/cms/www/chinamoney/data/fx/rfx-sp-quot.json';

  static const String _usdRateURL =
      'https://www.bocwm.cn/webApi/cms/productNetWorth/getNetWorthImageByCode?productCode=RJHQDUSD01A&dayCount=5';
  static const String _corsHost = 'https://cors.p1gd0g.cc';

  Future<String> getRfxSpQuot() async {
    appLogger.d('Fetching RfxSpQuot from $_rfxSpQuotURL');

    try {
      final rsp = await _dio.get<String>(
        _corsHost,
        queryParameters: {'url': _rfxSpQuotURL},
      );
      final data = jsonDecode(rsp.data!);
      final json = RfxSpQuotJson.fromJson(data);
      return json.records!.first.bidPrc!;
    } catch (e) {
      appLogger.e('Error fetching RfxSpQuot: $e');
      return '';
    }
  }

  Future<String> getUsdRate() async {
    appLogger.d('Fetching UsdRate from $_usdRateURL');

    try {
      final rsp = await _dio.get<String>(
        _corsHost,
        queryParameters: {'url': _usdRateURL},
      );
      final data = jsonDecode(rsp.data!);
      final json = UsdRateJson.fromJson(data);
      return json.sevenDayAnnualization!;
    } catch (e) {
      appLogger.e('Error fetching UsdRate: $e');
      return '';
    }
  }
}

@riverpod
Conn conn(Ref ref) => Conn();

@riverpod
Future<String> rfxSpQuot(Ref ref) => ref.read(connProvider).getRfxSpQuot();

@riverpod
Future<String> usdRate(Ref ref) => ref.read(connProvider).getUsdRate();

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
