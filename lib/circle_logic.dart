import 'dart:math';
import 'dart:ui';

class CircleResult {
  final double score; // 0 to 100
  final Offset center;
  final double radius;
  final String message;

  CircleResult({
    required this.score,
    required this.center,
    required this.radius,
    required this.message,
  });
}

class CircleEvaluator {
  static CircleResult evaluate(List<Offset> points, {String method = 'basic'}) {
    if (points.length < 5) {
      return CircleResult(
        score: 0,
        center: Offset.zero,
        radius: 0,
        message: 'Малюй далі...',
      );
    }

    // 1. Calculate Centroid (Geometric Center)
    // Used for all methods as a fallback or primary center
    double sumX = 0, sumY = 0;
    for (var p in points) {
      sumX += p.dx;
      sumY += p.dy;
    }
    final centroid = Offset(sumX / points.length, sumY / points.length);

    // 2. Least Squares Fit (for RMSE method mainly)
    // Equation: 2Ax + 2By + C = x^2 + y^2
    double sX = 0, sY = 0, sX2 = 0, sY2 = 0, sXY = 0, sXZ = 0, sYZ = 0;
    final n = points.length.toDouble();

    for (var p in points) {
      final x = p.dx;
      final y = p.dy;
      final z = x * x + y * y;
      sX += x;
      sY += y;
      sX2 += x * x;
      sY2 += y * y;
      sXY += x * y;
      sXZ += x * z;
      sYZ += y * z;
    }

    final D =
        n * sX2 * sY2 +
        2 * sXY * sY * sX -
        sX * sX * sY2 -
        sY * sY * sX2 -
        n * sXY * sXY;

    Offset bestCenter = centroid;
    double bestRadius = 0;

    if (D.abs() > 0.0001) {
      final sumZ = sX2 + sY2;
      final a =
          (sXZ * (n * sY2 - sY * sY) +
              sYZ * (sX * sY - n * sXY) +
              sumZ * (sXY * sY - sX * sY2)) /
          D;
      final b =
          (sXZ * (sX * sY - n * sXY) +
              sYZ * (n * sX2 - sX * sX) +
              sumZ * (sX * sXY - sY * sX2)) /
          D;
      final c =
          (sXZ * (sXY * sY - sY2 * sX) +
              sYZ * (sX * sXY - sX2 * sY) +
              sumZ * (sX2 * sY2 - sXY * sXY)) /
          D;
      bestCenter = Offset(a / 2, b / 2);
      bestRadius = sqrt(c + (a / 2) * (a / 2) + (b / 2) * (b / 2));
    } else {
      // Fallback to average distance from centroid
      double sumDist = 0;
      for (var p in points) sumDist += (p - centroid).distance;
      bestRadius = sumDist / points.length;
    }

    double finalScore = 0;

    switch (method) {
      case 'roundness':
        finalScore = _calculateRoundness(points);
        break;
      case 'combined':
        finalScore = _calculateCombined(points);
        break;
      case 'hausdorff':
        finalScore = _calculateHausdorff(points, centroid);
        break;
      case 'basic':
      default:
        finalScore = _calculateRMSE(points, bestCenter, bestRadius);
        break;
    }

    finalScore = finalScore.clamp(0.0, 100.0);

    // Feedback message
    String message = '';
    if (finalScore > 90)
      message = 'Супер!';
    else if (finalScore > 70)
      message = 'Добре...';
    else if (finalScore > 40)
      message = 'Рівніше...';
    else
      message = 'Старайся!';

    return CircleResult(
      score: finalScore,
      center: bestCenter,
      radius: bestRadius,
      message: message,
    );
  }

  // --- 1. RMSE Method (Radial Score) ---
  // radialScore = 100 / (1 + rmse/meanR)
  // finalScore = radialScore * coverage
  static double _calculateRMSE(
    List<Offset> points,
    Offset center,
    double radius,
  ) {
    if (radius == 0) return 0;
    double sumSquaredErrors = 0;
    for (var p in points) {
      sumSquaredErrors += pow((p - center).distance - radius, 2);
    }
    final rmse = sqrt(sumSquaredErrors / points.length);

    // User Formula: 100 / (1 + rmse/meanR)
    double radialScore = 100 / (1 + (rmse / radius));

    // Coverage Calculation
    double coverage = _calculateCoverage(points, center);

    return radialScore * coverage;
  }

  // Calculate angular coverage (0.0 to 1.0)
  static double _calculateCoverage(List<Offset> points, Offset center) {
    if (points.isEmpty) return 0;
    List<double> angles = points
        .map((p) => atan2(p.dy - center.dy, p.dx - center.dx))
        .toList();
    angles.sort();

    // Find max gap
    double maxGap = 0;
    for (int i = 0; i < angles.length - 1; i++) {
      double gap = angles[i + 1] - angles[i];
      if (gap > maxGap) maxGap = gap;
    }
    // Check gap between last and first (wrapping around PI)
    double lastGap = (angles.first + 2 * pi) - angles.last;
    if (lastGap > maxGap) maxGap = lastGap;

    // Coverage = (360 - maxGap_in_degrees) / 360
    double coverage = (2 * pi - maxGap) / (2 * pi);
    return coverage.clamp(0.0, 1.0);
  }

  // --- 2. Roundness Method (2D Sphericity) ---
  // Roundness = (4 * pi * Area) / Perimeter^2
  static double _calculateRoundness(List<Offset> points) {
    double area = 0;
    double perimeter = 0;

    // Shoelace Formula for Area
    // Perimeter is sum of distances
    for (int i = 0; i < points.length; i++) {
      Offset p1 = points[i];
      Offset p2 = points[(i + 1) % points.length]; // Closed loop

      // Area part: (x1*y2 - y1*x2)
      area += (p1.dx * p2.dy) - (p1.dy * p2.dx);

      // Perimeter part
      perimeter += (p1 - p2).distance;
    }
    area = area.abs() / 2.0;

    if (perimeter == 0) return 0;

    double roundness = (4 * pi * area) / (perimeter * perimeter);

    // Theoretical max is 1.0. Scale to 100.
    return roundness * 100;
  }

  // --- 3. Combined Method (Roundness + Angularity) ---
  static double _calculateCombined(List<Offset> points) {
    double roundnessScore = _calculateRoundness(points); // 0-100

    double totalTurningAngle = 0;
    for (int i = 0; i < points.length; i++) {
      Offset pPrev = points[i];
      Offset pCurr = points[(i + 1) % points.length];
      Offset pNext = points[(i + 2) % points.length];

      Offset v1 = pCurr - pPrev;
      Offset v2 = pNext - pCurr;

      double angle = (atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx));
      // Normalize to -PI to PI range
      while (angle <= -pi) angle += 2 * pi;
      while (angle > pi) angle -= 2 * pi;

      totalTurningAngle += angle.abs();
    }

    // Ideal: 2PI.
    double excessAngle = totalTurningAngle - (2 * pi);
    if (excessAngle < 0) excessAngle = 0;

    // Penalize excess angle (jaggedness)
    // If excessAngle is large (e.g. PI), score drops significantly
    double angularityScore = 100 / (1 + excessAngle);

    return (roundnessScore * 0.7 + angularityScore * 0.3).clamp(0.0, 100.0);
  }

  // --- 4. Hausdorff Method (Practical Variant) ---
  // Score based on standard deviation of distances to barycenter
  // s = stdDev(dist), r = mean(dist)
  // Score = 100 / (1 + s/r)
  static double _calculateHausdorff(List<Offset> points, Offset centroid) {
    double sumDist = 0;
    List<double> dists = [];
    for (var p in points) {
      double d = (p - centroid).distance;
      dists.add(d);
      sumDist += d;
    }
    double meanR = sumDist / points.length;
    if (meanR == 0) return 0;

    double sumSqDiff = 0;
    for (var d in dists) {
      sumSqDiff += pow(d - meanR, 2);
    }
    double stdDev = sqrt(sumSqDiff / points.length);

    // Formula: 100 / (1 + s/r)
    return 100 / (1 + (stdDev / meanR));
  }
}
