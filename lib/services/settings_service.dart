import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String keyAccuracyMethod = 'accuracy_method';
  static const String keyMinCirclePercentage = 'min_circle_percentage';
  static const String keyResetInterval = 'reset_interval';
  static const String keyLastResetDate = 'last_reset_date';
  static const String keySoundEnabled = 'sound_enabled';

  // Singleton
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // Default values
  String accuracyMethod = 'basic'; // 'basic', 'advanced'
  double minCirclePercentage = 15.0;
  String resetInterval = 'monthly'; // 'daily', 'monthly', 'never'
  bool isSoundEnabled = true;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    accuracyMethod = prefs.getString(keyAccuracyMethod) ?? 'basic';
    minCirclePercentage = prefs.getDouble(keyMinCirclePercentage) ?? 15.0;
    resetInterval = prefs.getString(keyResetInterval) ?? 'monthly';
    isSoundEnabled = prefs.getBool(keySoundEnabled) ?? true;
  }

  Future<void> setAccuracyMethod(String method) async {
    accuracyMethod = method;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAccuracyMethod, method);
  }

  Future<void> setMinCirclePercentage(double value) async {
    minCirclePercentage = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyMinCirclePercentage, value);
  }

  Future<void> setResetInterval(String interval) async {
    resetInterval = interval;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyResetInterval, interval);
  }

  Future<void> setSoundEnabled(bool value) async {
    isSoundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keySoundEnabled, value);
  }

  Future<DateTime?> getLastResetDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(keyLastResetDate);
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  Future<void> updateLastResetDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastResetDate, DateTime.now().toIso8601String());
  }

  Future<void> clearAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyAccuracyMethod);
    await prefs.remove(keyMinCirclePercentage);
    await prefs.remove(keyResetInterval);
    await prefs.remove(keyLastResetDate);
    await prefs.remove(keySoundEnabled);
    // Reset to defaults
    accuracyMethod = 'basic';
    minCirclePercentage = 15.0;
    resetInterval = 'monthly';
    isSoundEnabled = true;
  }
}
