import 'package:convert/convert.dart';
import 'package:intl/intl.dart';

class Def {
  static const String version = "vsn";
  static const String buildTime = "build_time";

  // yyyyMMdd
  static DateFormat dateFormat = DateFormat('yyyyMMdd');
  // yyyy-MM-dd HH:mm:ss
  static DateFormat dateFormatV2 = DateFormat('yyyy-MM-dd HH:mm:ss');
  // yyyy-MM-dd
  static DateFormat dateFormatV3 = DateFormat('yyyy-MM-dd');

  // notice: use YYYYMMDD, not yyyyMMdd
  static FixedDateTimeFormatter dateFormatter = FixedDateTimeFormatter(
    'YYYYMMDD',
  );
}
