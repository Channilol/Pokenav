import 'package:pokenav/api_call.dart';

class LocalUtils {
  static final _localUtils = LocalUtils._private();
  LocalUtils._private();

  Future<void> init() async {
    await apiCall.getPokedex(1);
  }
}

final localUtils = LocalUtils._localUtils;
