import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SessionUtil {
  static const _uuid = Uuid();

  static Future<void> saveSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('sessionId');
    if (sessionId == null) {
      sessionId = _uuid.v4();
      await prefs.setString('sessionId', sessionId);
    }
  }

  static Future<String?> getSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId');
  }
}
