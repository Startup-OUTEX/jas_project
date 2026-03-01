import 'package:flutter/material.dart';
import 'dart:math';
import 'services/settings_service.dart';
import 'services/easter_egg_service.dart';
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
  bool _isAdmin = false;
  bool _isSoundEnabled = true;

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
      _isSoundEnabled = _settingsService.isSoundEnabled;
      _isLoading = false;
    });
  }

  void _showAdminLogin() async {
    final bool? success = await showDialog<bool>(
      context: context,
      builder: (context) => const _AdminLoginDialog(),
    );

    if (success == true && mounted) {
      setState(() => _isAdmin = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocale.tr('admin_mode_enabled'))),
      );
    }
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
                        _buildSectionHeader(AppLocale.tr('set_section_main')),
                        // Language Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocale.tr('set_lang'),
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white30),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildLangOption('UA', 'uk'),
                                  _buildLangOption('EN', 'en'),
                                  _buildLangOption('DE', 'de'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Sound Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocale.tr('set_sound'),
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Switch(
                              value: _isSoundEnabled,
                              activeColor: Colors.yellowAccent,
                              onChanged: (val) async {
                                await _settingsService.setSoundEnabled(val);
                                setState(() => _isSoundEnabled = val);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        _buildDropdownRow(
                          AppLocale.tr('set_accuracy_method'),
                          _accuracyMethod,
                          [
                            'basic',
                            'roundness',
                            'combined',
                            'hausdorff',
                          ], // Keys
                          (val) async {
                            if (val != null) {
                              await _settingsService.setAccuracyMethod(val);
                              setState(() => _accuracyMethod = val);
                            }
                          },
                          // Maps keys to display text
                          displayMap: {
                            'basic': AppLocale.tr('set_method_rmse'),
                            'roundness': AppLocale.tr('set_method_roundness'),
                            'combined': AppLocale.tr('set_method_combined'),
                            'hausdorff': AppLocale.tr('set_method_hausdorff'),
                          },
                        ),
                        MethodExplanationWidget(method: _accuracyMethod),
                        const SizedBox(height: 20),

                        // Admin Login Button (if not admin)
                        if (!_isAdmin)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 10),
                            child: OutlinedButton.icon(
                              onPressed: _showAdminLogin,
                              icon: const Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              label: Text(
                                AppLocale.tr('btn_admin_login'),
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white30),
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),

                        // Restricted Sections
                        if (_isAdmin) ...[
                          const Divider(color: Colors.white24, height: 40),
                          _buildSectionHeader(
                            AppLocale.tr('set_section_gameplay'),
                          ),
                          Text(
                            AppLocale.tr('set_min_percent'),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: _minCirclePercentage,
                                  min: 0.0,
                                  max: 100.0,
                                  divisions: 100,
                                  label: _minCirclePercentage
                                      .round()
                                      .toString(),
                                  activeColor: Colors.yellowAccent,
                                  onChanged: (val) async {
                                    await _settingsService
                                        .setMinCirclePercentage(val);
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

                          _buildSectionHeader(AppLocale.tr('set_section_data')),
                          _buildDropdownRow(
                            AppLocale.tr('set_reset_interval'),
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocale.tr(
                                              'dialog_settings_reset',
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                  child: Text(
                                    AppLocale.tr('set_clear_cache'),
                                    style: const TextStyle(color: Colors.white),
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
                                        title: Text(
                                          AppLocale.tr(
                                            'dialog_clear_records_title',
                                          ),
                                        ),
                                        content: Text(
                                          AppLocale.tr(
                                            'dialog_clear_records_content',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text(
                                              AppLocale.tr('dialog_no'),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text(
                                              AppLocale.tr('dialog_yes'),
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
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
                                          SnackBar(
                                            content: Text(
                                              AppLocale.tr(
                                                'set_records_cleared',
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  child: Text(
                                    AppLocale.tr('set_clear_records'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

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
    String currentValue,
    List<String> options,
    Function(String?) onChanged, {
    Map<String, String>? displayMap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white70)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: options.contains(currentValue) ? currentValue : options[0],
              dropdownColor: const Color(0xFF4E2784),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              onChanged: onChanged,
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    displayMap != null
                        ? (displayMap[value] ?? value)
                        : value.toUpperCase(),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLangOption(String label, String code) {
    bool isSelected = AppLocale.currentCode == code;
    return GestureDetector(
      onTap: () async {
        await AppLocale.setLocale(code);
        setState(() {}); // Rebuild
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellowAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MethodExplanationWidget extends StatefulWidget {
  final String method;

  const MethodExplanationWidget({super.key, required this.method});

  @override
  State<MethodExplanationWidget> createState() =>
      _MethodExplanationWidgetState();
}

class _MethodExplanationWidgetState extends State<MethodExplanationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String descKey = 'set_desc_\${widget.method}';
    // Fallbacks if key not found (though we added them)
    if (widget.method == 'basic') descKey = 'set_desc_rmse';

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animation
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A154C),
              shape: BoxShape.circle,
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _MethodPainter(widget.method, _controller.value),
                );
              },
            ),
          ),
          // Text
          Expanded(
            child: Text(
              AppLocale.tr(descKey),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodPainter extends CustomPainter {
  final String method;
  final double animationValue;

  _MethodPainter(this.method, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    final paint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (method == 'basic') {
      // RMSE: Circle with pulsing radius
      double pulse = sin(animationValue * 2 * pi) * 3;
      canvas.drawCircle(center, radius + pulse, paint);
      // Draw ideal circle faint
      canvas.drawCircle(center, radius, paint..color = Colors.white12);
    } else if (method == 'roundness') {
      // Roundness: Morphing between square and circle
      // t goes 0 -> 1 -> 0
      double t = (sin(animationValue * 2 * pi) + 1) / 2; // 0 to 1
      // Draw rounded rect with varying radius
      double corner = radius * t;
      Rect rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(corner)),
        paint,
      );
    } else if (method == 'combined') {
      // Combined: Circle with jagged edges appearing
      // Wiggle
      Path path = Path();
      int segments = 12;
      for (int i = 0; i <= segments; i++) {
        double angle = (i / segments) * 2 * pi;
        double r = radius;
        if (i % 2 != 0) {
          r += sin(animationValue * 2 * pi) * 5; // Jaggedness
        }
        double x = center.dx + r * cos(angle);
        double y = center.dy + r * sin(angle);
        if (i == 0)
          path.moveTo(x, y);
        else
          path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, paint);
    } else if (method == 'hausdorff') {
      // Hausdorff: Two circles (inner/outer bound) pulsing
      double gap = 5 + sin(animationValue * 2 * pi) * 3;
      canvas.drawCircle(
        center,
        radius - gap,
        paint..color = Colors.cyanAccent.withOpacity(0.5),
      );
      canvas.drawCircle(
        center,
        radius + gap,
        paint..color = Colors.redAccent.withOpacity(0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _AdminLoginDialog extends StatefulWidget {
  const _AdminLoginDialog();

  @override
  State<_AdminLoginDialog> createState() => _AdminLoginDialogState();
}

class _AdminLoginDialogState extends State<_AdminLoginDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _passController = TextEditingController();
  final String _adminPassword = 'OUTEX&JAS&UF-2026';

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward();
  }

  void _checkPassword() {
    final text = _passController.text.toUpperCase();
    final rawText = _passController.text;

    // --- Easter Eggs --- //
    // 1. Retro Mode
    if (text == 'OLD' || text == 'SCHOOL') {
      Navigator.pop(context); // Close Admin Dialog FIRST
      EasterEggService().toggleRetroMode();
      return;
    }
    // 2. Black Hole
    if (text == '1/0') {
      Navigator.pop(context); // Close Admin Dialog FIRST
      EasterEggService().triggerBlackHole();
      return;
    }
    // 3. Team Photo
    if (text == 'TEAM') {
      Navigator.pop(context); // Close Admin Dialog FIRST
      EasterEggService().triggerTeamPhoto();
      return;
    }

    // --- Admin Check --- //
    if (rawText == _adminPassword) {
      Navigator.pop(context, true); // Return true for success
    } else {
      // Wrong Password
      _triggerShake();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocale.tr('admin_wrong_pass')),
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            sin(_shakeController.value * 3.14 * 4) * 5,
            0,
          ), // Simple shake
          child: child,
        );
      },
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          AppLocale.tr('admin_login_title'),
          style: const TextStyle(color: Color(0xFF4E2784)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: AppLocale.tr('admin_enter_pass'),
              ),
              onSubmitted: (_) => _checkPassword(),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocale.tr('admin_forgot_pass'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocale.tr('game_btn_cancel')),
          ),
          ElevatedButton(onPressed: _checkPassword, child: const Text('OK')),
        ],
      ),
    );
  }
}
