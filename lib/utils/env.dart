import 'package:myapp/utils/def.dart';

class Env {
  // build version
  static const version = String.fromEnvironment(Def.version);
  static const buildTime = String.fromEnvironment(Def.buildTime);
  static const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
}
