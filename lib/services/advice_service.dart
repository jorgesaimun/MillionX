class AdviceService {
  // Thresholds for low/ok/high bands
  static const double _low = 0.3;
  static const double _high = 0.7;

  /// Get detailed advice for all three resources (expanded format for display)
  static String getDetailedAdvice({
    required double irrigation,
    required double fertilizer,
    required double pesticide,
    required int currentStage,
    required int totalStages,
  }) {
    final bandWater = _band(irrigation);
    final bandFert = _band(fertilizer);
    final bandPest = _band(pesticide);

    // Build detailed feedback for each resource
    final waterAdvice = _getWaterAdvice(bandWater, currentStage);
    final fertAdvice = _getFertilizerAdvice(bandFert, currentStage);
    final pestAdvice = _getPesticideAdvice(bandPest, currentStage);

    // Combine all advice with clear labels
    return 'Water: $waterAdvice\nFertilizer: $fertAdvice\nPesticide: $pestAdvice';
  }

  /// Get water-specific advice
  static String _getWaterAdvice(_Band band, int stage) {
    if (band == _Band.high) {
      final variants = [
        'Too much, reduce by 20%',
        'Overwatering risk, dial back',
        'Soil waterlogged, less water',
        'Roots drowning, ease off',
        'Too wet, reduce irrigation',
        'Over-watered, use less',
      ];
      return _pick(variants, stage);
    }
    if (band == _Band.low) {
      final variants = [
        'Too dry, add 20% more',
        'Needs moisture, increase water',
        'Plants thirsty, water well',
        'Soil dry, boost irrigation',
        'Low moisture, add water',
        'Drying out, irrigate more',
      ];
      return _pick(variants, stage);
    }
    // Balanced
    final variants = [
      'Perfect moisture level',
      'Water level optimal',
      'Hydration is good',
      'Balanced water use',
      'Moisture level fine',
      'Water well managed',
    ];
    return _pick(variants, stage);
  }

  /// Get fertilizer-specific advice
  static String _getFertilizerAdvice(_Band band, int stage) {
    if (band == _Band.high) {
      final variants = [
        'Too rich, reduce nutrients',
        'Overfertilized, use less',
        'Nutrient burn risk, dial down',
        'Too much food, reduce dose',
        'Excess nutrients, ease off',
        'Over-feeding, use sparingly',
      ];
      return _pick(variants, stage);
    }
    if (band == _Band.low) {
      final variants = [
        'Lacks nutrients, add more',
        'Underfed, increase fertilizer',
        'Soil needs boost, feed it',
        'Low nutrients, use more',
        'Deficiency risk, add nutrients',
        'Starving, provide fertilizer',
      ];
      return _pick(variants, stage);
    }
    // Balanced
    final variants = [
      'Nutrient level balanced',
      'Feeding is ideal',
      'Good nutrient balance',
      'Fertilizer level perfect',
      'Nutrients well distributed',
      'Feeding going well',
    ];
    return _pick(variants, stage);
  }

  /// Get pesticide-specific advice
  static String _getPesticideAdvice(_Band band, int stage) {
    if (band == _Band.high) {
      final variants = [
        'Over-sprayed, use less',
        'Too much chemical, reduce',
        'High toxicity risk, ease back',
        'Harsh on ecosystem, dial down',
        'Chemical overload, reduce dose',
        'Too strong, lower application',
      ];
      return _pick(variants, stage);
    }
    if (band == _Band.low) {
      final variants = [
        'Low protection, add more',
        'Under-protected, increase spray',
        'Pest risk rising, treat more',
        'Weak defense, boost protection',
        'Insufficient coverage, apply more',
        'Vulnerable to pests, protect it',
      ];
      return _pick(variants, stage);
    }
    // Balanced
    final variants = [
      'Protection is balanced',
      'Pest control ideal',
      'Good chemical balance',
      'Protection level perfect',
      'Pesticide well managed',
      'Defense well balanced',
    ];
    return _pick(variants, stage);
  }

  /// Simple version (short advice - for compact displays)
  static String getSimpleAdvice({
    required double irrigation,
    required double fertilizer,
    required double pesticide,
    required int currentStage,
    required int totalStages,
  }) {
    final bandWater = _band(irrigation);
    final bandFert = _band(fertilizer);
    final bandPest = _band(pesticide);

    // Priority: water -> fertilizer -> pesticide -> overall good
    if (bandWater == _Band.high) {
      final variants = <String>[
        'Reduce water today',
        'Soil is waterlogged',
        'Less water this stage',
        'Roots need more air',
        'Overwatering detected',
        'Dry the soil a bit',
      ];
      return _pick(variants, currentStage);
    }
    if (bandWater == _Band.low) {
      final variants = <String>[
        'Add more water',
        'Soil looks dry',
        'Increase watering',
        'Plants are thirsty',
        'Boost moisture level',
        'Hydrate your crops',
      ];
      return _pick(variants, currentStage);
    }

    if (bandFert == _Band.high) {
      final variants = <String>[
        'Reduce fertilizer use',
        'Too many nutrients',
        'Use less fertilizer',
        'Risk of burn',
        'Soil too rich now',
        'Dial feeding down',
      ];
      return _pick(variants, currentStage);
    }
    if (bandFert == _Band.low) {
      final variants = <String>[
        'Add more nutrients',
        'Soil lacks nutrients',
        'Fertilize a bit more',
        'Boost soil health',
        'Feed your plants',
        'Growth needs support',
      ];
      return _pick(variants, currentStage);
    }

    if (bandPest == _Band.high) {
      final variants = <String>[
        'Reduce pesticide',
        'Less spray is better',
        'Use chemicals sparingly',
        'Avoid over-spraying',
        'Lower pesticide dose',
        'Keep it gentle',
      ];
      return _pick(variants, currentStage);
    }
    if (bandPest == _Band.low) {
      final variants = <String>[
        'Add some protection',
        'Watch for pests',
        'Increase protection slightly',
        'Apply mild treatment',
        'Pest control needed',
        'Protect your plants',
      ];
      return _pick(variants, currentStage);
    }

    // Overall balanced
    final balanced = <String>[
      'Nice balance, keep it up',
      'Great care this stage',
      'Inputs look balanced',
      'Good job farmer',
      'Healthy choices today',
      'Balanced approach',
    ];
    return _pick(balanced, currentStage);
  }

  static String _pick(List<String> variants, int currentStage) {
    // Deterministic variety per stage (6–13 stages supported)
    final index = (currentStage - 1) % variants.length;
    return variants[index];
  }

  static _Band _band(double v) {
    if (v < _low) return _Band.low;
    if (v > _high) return _Band.high;
    return _Band.ok;
  }
}

enum _Band { low, ok, high }
