import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ResponsiveSize on num {
  /// Scales the dimension proportionally ONLY on Windows.
  /// On Android, Web, and iOS, it returns the original value, keeping old layout logic intact.
  double get wRes => (!kIsWeb && Platform.isWindows) ? w : toDouble();
  double get hRes => (!kIsWeb && Platform.isWindows) ? h : toDouble();
  double get spRes => (!kIsWeb && Platform.isWindows) ? sp : toDouble();
  double get rRes => (!kIsWeb && Platform.isWindows) ? r : toDouble();
}
