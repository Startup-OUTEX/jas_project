import 'package:shared_preferences/shared_preferences.dart';

class AppLocale {
  static const String keyLocale = 'kb_locale_code';
  static String currentCode = 'uk';

  static final Map<String, Map<String, String>> _strings = {
    'uk': {
      // Main Screen
      'main_title': 'ЗМОЖЕШ НАМАЛЮВАТИ\nІДЕАЛЬНЕ КОЛО?',
      'main_play': 'ГРАТИ',
      'main_settings': 'Налаштування',
      'main_records': 'Рейтинг',
      'main_empty': 'Ще нікого немає. Стань першим!',
      'main_try': 'Спробувати',

      // Game Screen
      'game_instruction_1': 'Намагайся намалювати ідеальне коло одним рухом',
      'game_instruction_2': 'Ми порівняємо точність твого кола з еталоном',
      'game_instruction_3': 'Спробуй досягти 100% точності!',
      'game_instruction_4': 'Малюй швидко та впевнено!',
      'game_touch_draw': 'Торкнись і малюй!',
      'game_feedback_small': 'Занадто маленьке! Малюй розмашисто!',
      'game_feedback_accuracy': 'Трохи кривувато... Спробуй ще раз!',
      'game_btn_retry': 'Ще раз',
      'game_btn_save': 'Зберегти',
      'game_save_title': 'Зберегти результат',
      'game_enter_name': "Введи своє ім'я",
      'game_btn_cancel': 'Скасувати',
      'game_btn_save_confirm': 'Зберегти',

      // Encouragement
      'enc_robot': 'НЕЙМОВІРНО! ТИ МАЙЖЕ РОБОТ!',
      'enc_fantastic': 'ФАНТАСТИЧНИЙ РЕЗУЛЬТАТ!',
      'enc_good': 'ДУЖЕ ДОБРЕ! ТАК ТРИМАТИ!',
      'enc_ok': 'НЕПОГАНО, АЛЕ МОЖНА КРАЩЕ!',
      'enc_norm': 'НОРМАЛЬНО. СПРОБУЙ ЩЕ!',
      'enc_bad': 'ТРЕБА БІЛЬШЕ ПРАКТИКИ!',

      // Records
      'rec_title': 'Таблиця лідерів',
      'rec_today_best': 'Найкраще за сьогодні',
      'rec_total_best': 'Найкраще за весь час',
      'rec_empty': 'Поки немає рекордів. Стань першим!',
      'rec_call': 'Спробуй побити рекорд!',
      'rec_play': 'Грати',

      // Settings
      'set_title': 'Налаштування',
      'set_lang': 'Мова / Language',
      'set_clear_cache': 'Очистити кеш',
      'set_cache_cleared': 'Кеш очищено',
      'set_clear_records': 'Очистити рекорди',
    },
    'en': {
      // Main Screen
      'main_title': 'CAN YOU DRAW\nA PERFECT CIRCLE?',
      'main_play': 'PLAY',
      'main_settings': 'Settings',
      'main_records': 'Leaderboard',
      'main_empty': 'No one here yet. Be the first!',
      'main_try': 'Try Now',

      // Game Screen
      'game_instruction_1': 'Try to draw a perfect circle in one stroke',
      'game_instruction_2': 'We compare your circle with the ideal one',
      'game_instruction_3': 'Try to reach 100% accuracy!',
      'game_instruction_4': 'Draw fast and confident!',
      'game_touch_draw': 'Touch and Draw!',
      'game_feedback_small': 'Too small! Draw bigger!',
      'game_feedback_accuracy': 'A bit wonky... Try again!',
      'game_btn_retry': 'Retry',
      'game_btn_save': 'Save',
      'game_save_title': 'Save Result',
      'game_enter_name': "Enter your name",
      'game_btn_cancel': 'Cancel',
      'game_btn_save_confirm': 'Save',

      // Encouragement
      'enc_robot': 'UNBELIEVABLE! YOU ARE A ROBOT!',
      'enc_fantastic': 'FANTASTIC RESULT!',
      'enc_good': 'VERY GOOD! KEEP IT UP!',
      'enc_ok': 'NOT BAD, BUT CAN BE BETTER!',
      'enc_norm': 'NORMAL. TRY AGAIN!',
      'enc_bad': 'MORE PRACTICE NEEDED!',

      // Records
      'rec_title': 'Leaderboard',
      'rec_today_best': 'Best Today',
      'rec_total_best': 'All Time Best',
      'rec_empty': 'No records yet. Be the first!',
      'rec_call': 'Try to beat the record!',
      'rec_play': 'Play',

      // Settings
      'set_title': 'Settings',
      'set_lang': 'Language / Мова',
      'set_clear_cache': 'Clear Cache',
      'set_cache_cleared': 'Cache Cleared',
      'set_clear_records': 'Clear Records',
    },
  };

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    currentCode = prefs.getString(keyLocale) ?? 'uk';
  }

  static Future<void> setLocale(String code) async {
    if (!_strings.containsKey(code)) return;
    currentCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLocale, code);
  }

  static String tr(String key) {
    return _strings[currentCode]?[key] ?? key;
  }
}
