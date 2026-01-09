/// Service to evaluate crop performance and generate results
class ResultsService {
  // Thresholds for resource levels
  static const double _low = 0.3;
  static const double _high = 0.7;

  /// Result model holding star rating, what happened, and why
  static ResultsData evaluatePerformance({
    required double irrigation,
    required double fertilizer,
    required double pesticide,
    required int currentStage,
  }) {
    // Determine band for each resource
    final waterBand = _band(irrigation);
    final fertBand = _band(fertilizer);
    final pestBand = _band(pesticide);

    // Count how many are "ok" (ideal)
    int idealCount = 0;
    if (waterBand == _Band.ok) idealCount++;
    if (fertBand == _Band.ok) idealCount++;
    if (pestBand == _Band.ok) idealCount++;

    // Calculate star rating based on how many inputs are ideal
    final int starRating = _calculateStars(
      idealCount,
      waterBand,
      fertBand,
      pestBand,
    );

    // Generate what happened message
    final String whatHappened = _getWhatHappened(starRating, currentStage);

    // Generate why message
    final String why = _getWhy(waterBand, fertBand, pestBand, currentStage);

    return ResultsData(
      starRating: starRating,
      whatHappened: whatHappened,
      why: why,
    );
  }

  /// Calculate star rating based on ideal inputs
  static int _calculateStars(
    int idealCount,
    _Band water,
    _Band fert,
    _Band pest,
  ) {
    if (idealCount == 3) return 3; // Perfect
    if (idealCount == 2) return 2; // Good
    if (idealCount == 1) return 1; // Fair
    return 0; // Poor
  }

  /// Get "What Happened" outcome message
  static String _getWhatHappened(int stars, int stage) {
    if (stars == 3) {
      final variants = [
        'Crop thrived beautifully',
        'Excellent growth this stage',
        'Crop is flourishing',
        'Perfect development',
        'Healthy crop growth',
        'Outstanding results',
      ];
      return variants[(stage - 1) % variants.length];
    }
    if (stars == 2) {
      final variants = [
        'Crop grew well overall',
        'Good growth this stage',
        'Crop is doing fine',
        'Decent development',
        'Acceptable growth',
        'Good progress',
      ];
      return variants[(stage - 1) % variants.length];
    }
    if (stars == 1) {
      final variants = [
        'Crop struggled slightly',
        'Mixed results this stage',
        'Crop needs attention',
        'Growth was slow',
        'Some challenges faced',
        'Average results',
      ];
      return variants[(stage - 1) % variants.length];
    }
    // 0 stars
    final variants = [
      'Crop suffered greatly',
      'Poor results this stage',
      'Crop is in distress',
      'Growth was stunted',
      'Major problems occurred',
      'Critical condition',
    ];
    return variants[(stage - 1) % variants.length];
  }

  /// Get "Why" reason message based on inputs
  static String _getWhy(_Band water, _Band fert, _Band pest, int stage) {
    // Build reason based on which inputs were problematic
    final reasons = <String>[];

    if (water == _Band.high) {
      reasons.add('overwatered');
    } else if (water == _Band.low) {
      reasons.add('under-watered');
    } else {
      reasons.add('perfect water balance');
    }

    if (fert == _Band.high) {
      reasons.add('over-fertilized');
    } else if (fert == _Band.low) {
      reasons.add('under-fertilized');
    } else {
      reasons.add('ideal nutrients');
    }

    if (pest == _Band.high) {
      reasons.add('over-treated');
    } else if (pest == _Band.low) {
      reasons.add('under-protected');
    } else {
      reasons.add('balanced protection');
    }

    // Combine reasons into a sentence
    return _combineReasons(reasons, stage);
  }

  /// Combine reasons into a readable message
  static String _combineReasons(List<String> reasons, int stage) {
    if (reasons.length == 3) {
      if (reasons.every(
        (r) =>
            r.contains('perfect') ||
            r.contains('ideal') ||
            r.contains('balanced'),
      )) {
        final variants = [
          'Perfect care across all inputs',
          'All three inputs were ideal',
          'Balanced management throughout',
          'Excellent input control',
          'Optimal resource management',
          'Perfectly balanced inputs',
        ];
        return variants[(stage - 1) % variants.length];
      }

      // Mix of good and bad
      final good =
          reasons
              .where(
                (r) =>
                    r.contains('perfect') ||
                    r.contains('ideal') ||
                    r.contains('balanced'),
              )
              .length;
      if (good == 2) {
        return '${reasons[0]}, but ${reasons[1]} and ${reasons[2]}';
      }
      return '${reasons[0]}, ${reasons[1]}, and ${reasons[2]}';
    }

    return reasons.join(' and ');
  }

  static _Band _band(double v) {
    if (v < _low) return _Band.low;
    if (v > _high) return _Band.high;
    return _Band.ok;
  }
}

enum _Band { low, ok, high }

/// Model to hold results
class ResultsData {
  final int starRating; // 0-3 stars
  final String whatHappened;
  final String why;

  ResultsData({
    required this.starRating,
    required this.whatHappened,
    required this.why,
  });
}
