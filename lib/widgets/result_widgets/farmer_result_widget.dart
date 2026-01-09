import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerResultWidget extends StatelessWidget {
  final String message;

  const FarmerResultWidget({
    super.key,
    this.message = 'Water: Good\nFertilizer: Good\nPesticide: Good',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Speech bubble at top
        _buildSpeechBubble(),
        // Farmer character at bottom with minimal spacing
        _buildFarmerCharacter(),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      width: 240, // Increased from 200
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // // Lightbulb icon
          // const Padding(
          //   padding: EdgeInsets.only(top: 2),
          //   child: Icon(Icons.lightbulb, color: Colors.amber, size: 24),
          // ),
          //  const SizedBox(width: 10),
          // Text message
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.vt323(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.4,
              ),
              maxLines: 6, // Increased from 2
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerCharacter() {
    return Image.asset(
      'assets/images/farmer_left.png',
      width: 160,
      height: 130,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 150,
          height: 140,
          decoration: BoxDecoration(
            color: const Color(0xFF8D6E63),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 50),
        );
      },
    );
  }
}
