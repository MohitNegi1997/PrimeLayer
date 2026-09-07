import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionStore {
  AuthSessionStore(this._prefs);

  static const String signedInAtKey = 'signed_in_at_ms';
  static const Duration sessionDuration = Duration(hours: 24);

  final SharedPreferences _prefs;

  bool get isValid {
    final signedInAt = _signedInAt;
    if (signedInAt == null) return false;
    return DateTime.now().difference(signedInAt) < sessionDuration;
  }

  DateTime? get _signedInAt {
    final milliseconds = _prefs.getInt(signedInAtKey);
    if (milliseconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Future<void> save() {
    return _prefs.setInt(signedInAtKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> clear() {
    return _prefs.remove(signedInAtKey);
  }
}
