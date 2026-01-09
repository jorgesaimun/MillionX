import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/advice_service.dart';

class FarmerSectionWidget extends StatelessWidget {
  final String cropName;
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;
  final int currentStage;
  final int totalStages;

  const FarmerSectionWidget({
    super.key,
    required this.cropName,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
    required this.currentStage,
    required this.totalStages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Speech bubble
        _buildSpeechBubble(),
        const SizedBox(height: 4),
        // Farmer character
        _buildFarmerCharacter(),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    // Get detailed advice for all three resources
    final detailedAdvice = AdviceService.getDetailedAdvice(
      irrigation: irrigationLevel,
      fertilizer: fertilizerLevel,
      pesticide: pesticideLevel,
      currentStage: currentStage,
      totalStages: totalStages,
    );

    // Show welcome message on stage 1
    final message =
        currentStage == 1
            ? 'Welcome to ${cropName.toUpperCase()}\n\n$detailedAdvice'
            : detailedAdvice;

    return Container(
      width: 280, // Increased from 220
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        message,
        style: GoogleFonts.vt323(
          fontSize: 16, // Slightly smaller to fit more text
          fontWeight: FontWeight.bold,
          color: Colors.black,
          height: 1.3, // Better line spacing
        ),
        maxLines: 8, // Increased from 3
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildFarmerCharacter() {
    return Image.asset(
      'assets/images/farmer_left.png',
      width: 150,
      height: 125,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF8D6E63),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 40),
        );
      },
    );
  }
}
