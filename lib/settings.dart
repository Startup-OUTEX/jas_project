import 'package:flutter/material.dart';
import 'services/settings_service.dart';
import 'services/score_service.dart';
import 'widgets/app_footer.dart';
import 'locale_strings.dart';

class Settings1Screen extends StatefulWidget {
  const Settings1Screen({super.key});

  @override
  State<Settings1Screen> createState() => _Settings1ScreenState();
}

class _Settings1ScreenState extends State<Settings1Screen> {
  final SettingsService _settingsService = SettingsService();
  final ScoreService _scoreService = ScoreService();

  // Local state for UI
  String _accuracyMethod = 'basic';
  double _minCirclePercentage = 15.0;
  String _resetInterval = 'monthly';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settingsService.loadSettings();
    setState(() {
      _accuracyMethod = _settingsService.accuracyMethod;
      _minCirclePercentage = _settingsService.minCirclePercentage;
      _resetInterval = _settingsService.resetInterval;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E2784),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          AppLocale.tr('set_title'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Основні'),
                        // Language Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocale.tr('set_lang'),
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'UA',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Switch(
                                  value: AppLocale.currentCode == 'en',
                                  activeColor: Colors.yellowAccent,
                                  onChanged: (val) async {
                                    await AppLocale.setLocale(
                                      val ? 'en' : 'uk',
                                    );
                                    setState(
                                      () {},
                                    ); // Rebuild to show change immediately
                                  },
                                ),
                                const Text(
                                  'EN',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        _buildDropdownRow(
                          'Метод точності',
                          _accuracyMethod,
                          ['basic', 'advanced'],
                          (val) async {
                            if (val != null) {
                              await _settingsService.setAccuracyMethod(val);
                              setState(() => _accuracyMethod = val);
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader('Ігровий процес'),
                        const Text(
                          'Мін. відсоток для зарахування',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _minCirclePercentage,
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                label: _minCirclePercentage.round().toString(),
                                activeColor: Colors.yellowAccent,
                                onChanged: (val) async {
                                  await _settingsService.setMinCirclePercentage(
                                    val,
                                  );
                                  setState(() => _minCirclePercentage = val);
                                },
                              ),
                            ),
                            Text(
                              '${_minCirclePercentage.toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildSectionHeader('Дані та Рейтинг'),
                        _buildDropdownRow(
                          'Скидання рейтингу',
                          _resetInterval,
                          ['daily', 'monthly', 'never'],
                          (val) async {
                            if (val != null) {
                              await _settingsService.setResetInterval(val);
                              setState(() => _resetInterval = val);
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  await _settingsService.clearAllSettings();
                                  await _loadSettings(); // Reload defaults
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Налаштування скинуто'),
                                      ),
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                ),
                                child: const Text(
                                  'Очистити Кеш',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Видалити всіх лідерів?',
                                      ),
                                      content: const Text(
                                        'Цю дію неможливо відмінити.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Ні'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text(
                                            'Так',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await _scoreService.clearAllScores();
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Всі рекорди видалено'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                child: const Text(
                                  'Очистити Лідерів',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 60), // Space for footer
                      ],
                    ),
                  ),

                  // Footer
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: Center(child: AppFooter()),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdownRow(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF5E3794),
          style: const TextStyle(color: Colors.white),
          underline: Container(height: 1, color: Colors.white30),
          iconEnabledColor: Colors.white,
          items: options
              .map(
                (e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
