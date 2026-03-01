import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AppLocale {
  static const String keyLocale = 'kb_locale_code';
  static String currentCode = 'uk';
  static final ValueNotifier<String> localeNotifier = ValueNotifier<String>(
    'uk',
  );

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
      'game_timeout': 'Занадто довго! Малюй швидше!',
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
      'set_section_main': 'Основні',
      'set_lang': 'Мова / Language',
      'set_accuracy_method': 'Метод оцінки',
      'set_method_rmse': 'RMSE (Радіус)',
      'set_desc_rmse': 'Вимірює відхилення точок від середнього радіуса.',
      'set_method_roundness': 'Круглість (Sphericity)',
      'set_desc_roundness': 'Порівнює площу та периметр. Визначає форму.',
      'set_method_combined': 'Комбінований (+Кути)',
      'set_desc_combined': 'Круглість + плавність. Штрафує за "кути".',
      'set_method_hausdorff': 'Гаусдорф (Відстань)',
      'set_desc_hausdorff': 'Вимірює розкид відстаней від центру.',
      'admin_login_title': 'Вхід адміністратора',
      'admin_enter_pass': 'Введіть пароль',
      'admin_wrong_pass': 'Невірний пароль',
      'admin_forgot_pass':
          'Якщо забули пароль, зверніться до команди OUTEX - outex.ua@gmail.com',
      'admin_mode_enabled': 'Режим адміністратора увімкнено',
      'btn_admin_login': 'Налаштування адміністратора',
      'set_sound': 'Звук',
      'set_section_gameplay': 'Ігровий процес',
      'set_min_percent': 'Мін. похибка:',
      'set_section_data': 'Дані та Рейтинг',
      'set_reset_interval': 'Скидання рейтингу',
      'set_clear_cache': 'Очистити кеш',
      'set_cache_cleared': 'Кеш очищено',
      'set_clear_records': 'Очистити Лідерів',
      'set_records_cleared': 'Всі рекорди видалено',

      // Dialogs
      'dialog_clear_records_title': 'Видалити всіх лідерів?',
      'dialog_clear_records_content': 'Цю дію неможливо відмінити.',
      'dialog_yes': 'Так',
      'dialog_no': 'Ні',
      'dialog_settings_reset': 'Налаштування скинуто',

      // Footer
      'footer_text': 'Застосунок створено за підтримки OUTEX',

      // Loading
      'loading_text': 'Завантаження...',
      'loading_subtext': 'Готуємо для тебе завдання з геометрії...',

      // About
      'about_project_info':
          'Проєкт створено на замовлення\nМалої академії наук України\nза ініціативи UF Incubator.',
      'about_title': 'Про OUTEX',
      'about_text_1':
          'OUTEX — це український стартап, який створює інноваційні мобільні застосунки для спорту та реабілітації з використанням штучного інтелекту.',
      'about_text_2':
          'Ми допомагаємо людям тренуватись будь-де й будь-коли, стежити за правильною технікою виконання вправ та отримувати персональні плани тренувань.',
      'about_text_3':
          'Підтримуючи Малу академію наук України, ми хочемо, щоб сучасні технології допомагали дітям полюбити математику, науку та рух.',
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
      'game_timeout': 'Too slow! Draw faster!',
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
      'set_section_main': 'General',
      'set_lang': 'Language',
      'set_accuracy_method': 'Accuracy Method',
      'set_method_rmse': 'RMSE (Radius)',
      'set_desc_rmse': 'Measures deviation from the average radius.',
      'set_method_roundness': 'Roundness (2D Sphericity)',
      'set_desc_roundness': 'Compares Area vs Perimeter. Checks shape.',
      'set_method_combined': 'Combined (Roundness + Angularity)',
      'set_desc_combined': 'Roundness + Smoothness. Penalizes corners.',
      'set_method_hausdorff': 'Hausdorff Distance',
      'set_desc_hausdorff': 'Measures variance of distances from center.',
      'admin_login_title': 'Admin Login',
      'admin_enter_pass': 'Enter Password',
      'admin_wrong_pass': 'Wrong Password',
      'admin_forgot_pass':
          'If you forgot the password, contact the OUTEX team - outex.ua@gmail.com',
      'admin_mode_enabled': 'Admin Mode Enabled',
      'btn_admin_login': 'Admin Settings',
      'set_sound': 'Sound',
      'set_section_gameplay': 'Gameplay',
      'set_min_percent': 'Min. Error:',
      'set_section_data': 'Data & Leaderboard',
      'set_reset_interval': 'Reset Leaderboard',
      'set_clear_cache': 'Clear Cache',
      'set_cache_cleared': 'Cache Cleared',
      'set_clear_records': 'Clear Leaders',
      'set_records_cleared': 'All records deleted',

      // Dialogs
      'dialog_clear_records_title': 'Delete all leaders?',
      'dialog_clear_records_content': 'This action cannot be undone.',
      'dialog_yes': 'Yes',
      'dialog_no': 'No',
      'dialog_settings_reset': 'Settings reset',

      // Footer
      'footer_text': 'App created with support from OUTEX',

      // Loading
      'loading_text': 'Loading...',
      'loading_subtext': 'Preparing geometry tasks for you...',

      // About
      'about_project_info':
          'Project created on request of\nJunior Academy of Sciences of Ukraine\ninitiated by UF Incubator.',
      'about_title': 'About OUTEX',
      'about_text_1':
          'OUTEX is a Ukrainian startup creating innovative mobile apps for sports and rehabilitation using artificial intelligence.',
      'about_text_2':
          'We help people train anywhere, anytime, monitor correct exercise technique and receive personalized training plans.',
      'about_text_3':
          'Supporting the Junior Academy of Sciences of Ukraine, we want modern technologies to help children fall in love with mathematics, science and movement.',
    },
    'de': {
      // Main Screen
      'main_title': 'KANNST DU EINEN\nPERFEKTEN KREIS ZEICHNEN?',
      'main_play': 'SPIELEN',
      'main_settings': 'Einstellungen',
      'main_records': 'Bestenliste',
      'main_empty': 'Noch niemand da. Sei der Erste!',
      'main_try': 'Versuchen',

      // Game Screen
      'game_instruction_1': 'Zeichne einen perfekten Kreis in einem Zug',
      'game_instruction_2': 'Wir vergleichen deinen Kreis mit dem Ideal',
      'game_instruction_3': 'Versuche 100% Genauigkeit zu erreichen!',
      'game_instruction_4': 'Zeichne schnell und sicher!',
      'game_touch_draw': 'Berühren und zeichnen!',
      'game_feedback_small': 'Zu klein! Zeichne größer!',
      'game_feedback_accuracy': 'Etwas schief... Versuch es nochmal!',
      'game_timeout': 'Zu langsam! Zeichne schneller!',
      'game_btn_retry': 'Noch mal',
      'game_btn_save': 'Speichern',
      'game_save_title': 'Ergebnis speichern',
      'game_enter_name': "Gib deinen Namen ein",
      'game_btn_cancel': 'Abbrechen',
      'game_btn_save_confirm': 'Speichern',

      // Encouragement
      'enc_robot': 'UNGLAUBLICH! DU BIST EIN ROBOTER!',
      'enc_fantastic': 'FANTASTISCHES ERGEBNIS!',
      'enc_good': 'SEHR GUT! WEITER SO!',
      'enc_ok': 'NICHT SCHLECHT, ABER GEHT BESSER!',
      'enc_norm': 'NORMAL. VERSUCH ES NOCHMAL!',
      'enc_bad': 'MEHR ÜBUNG NÖTIG!',

      // Records
      'rec_title': 'Bestenliste',
      'rec_today_best': 'Bester heute',
      'rec_total_best': 'Bester aller Zeiten',
      'rec_empty': 'Noch keine Rekorde. Sei der Erste!',
      'rec_call': 'Versuche den Rekord zu brechen!',
      'rec_play': 'Spielen',

      // Settings
      'set_title': 'Einstellungen',
      'set_section_main': 'Allgemein',
      'set_lang': 'Sprache / Language',
      'set_accuracy_method': 'Genauigkeitsmethode',
      'set_method_rmse': 'RMSE (Standard)',
      'set_desc_rmse': 'Misst die Abweichung vom mittleren Radius.',
      'set_method_roundness': 'Rundheit (2D Sphericity)',
      'set_desc_roundness': 'Vergleicht Fläche vs Umfang. Bestimmt die Form.',
      'set_method_combined': 'Kombiniert (Rundheit + Winkel)',
      'set_desc_combined': 'Rundheit + Glätte. Bestraft Ecken.',
      'set_method_hausdorff': 'Hausdorff-Abstand',
      'set_desc_hausdorff': 'Misst die Varianz der Abstände vom Zentrum.',
      'admin_login_title': 'Admin-Login',
      'admin_enter_pass': 'Passwort eingeben',
      'admin_wrong_pass': 'Falsches Passwort',
      'admin_forgot_pass':
          'Wenn Sie das Passwort vergessen, wenden Sie sich an das OUTEX-Team - outex.ua@gmail.com',
      'admin_mode_enabled': 'Admin-Modus aktiviert',
      'btn_admin_login': 'Admin-Einstellungen',
      'set_sound': 'Ton',
      'set_section_gameplay': 'Gameplay',
      'set_min_percent': 'Min. Fehler:',
      'set_section_data': 'Daten & Bestenliste',
      'set_reset_interval': 'Bestenliste zurücksetzen',
      'set_clear_cache': 'Cache leeren',
      'set_cache_cleared': 'Cache geleert',
      'set_clear_records': 'Bestenliste löschen',
      'set_records_cleared': 'Alle Rekorde gelöscht',

      // Dialogs
      'dialog_clear_records_title': 'Alle Einträge löschen?',
      'dialog_clear_records_content':
          'Dies kann nicht rückgängig gemacht werden.',
      'dialog_yes': 'Ja',
      'dialog_no': 'Nein',
      'dialog_settings_reset': 'Einstellungen zurückgesetzt',

      // Footer
      'footer_text': 'App erstellt mit Unterstützung von OUTEX',

      // Loading
      'loading_text': 'Laden...',
      'loading_subtext': 'Bereite Geometrieaufgaben vor...',

      // About
      'about_project_info':
          'Projekt erstellt im Auftrag der\nKleinen Akademie der Wissenschaften der Ukraine\nauf Initiative des UF Incubator.',
      'about_title': 'Über OUTEX',
      'about_text_1':
          'OUTEX ist ein ukrainisches Startup, das innovative mobile Apps für Sport und Rehabilitation unter Verwendung künstlicher Intelligenz entwickelt.',
      'about_text_2':
          'Wir helfen Menschen, überall und jederzeit zu trainieren, die richtige Übungstechnik zu überwachen und personalisierte Trainingspläne zu erhalten.',
      'about_text_3':
          'Durch die Unterstützung der Kleinen Akademie der Wissenschaften der Ukraine wollen wir, dass moderne Technologien Kindern helfen, sich in Mathematik, Wissenschaft und Bewegung zu verlieben.',
    },
  };

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    currentCode = prefs.getString(keyLocale) ?? 'uk';
    localeNotifier.value = currentCode;
  }

  static Future<void> setLocale(String code) async {
    if (!_strings.containsKey(code)) return;
    currentCode = code;
    localeNotifier.value = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLocale, code);
  }

  static String tr(String key) {
    return _strings[currentCode]?[key] ?? key;
  }
}
