import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/crop.dart';
import 'widgets/cultivation_widgets/calendar_widget.dart';
import 'widgets/result_widgets/farmer_result_widget.dart';
import 'widgets/result_widgets/results_panel_widget.dart';
import 'final_result_screen.dart';
import 'services/advice_service.dart';
import 'services/results_service.dart';

class ResultScreen extends StatefulWidget {
  final Crop selectedCrop;
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;
  final int currentStage;
  final int totalStages;
  final VoidCallback onStageAdvance;
  final String currentMonth;
  final String monthNumber;
  final String? division;

  const ResultScreen({
    super.key,
    required this.selectedCrop,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
    required this.currentStage,
    required this.totalStages,
    required this.onStageAdvance,
    required this.currentMonth,
    required this.monthNumber,
    this.division,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final String _adviceMessage;
  late final int _starRating;
  late final String _whatHappened;
  late final String _why;

  @override
  void initState() {
    super.initState();
    // Compute dynamic advice
    _adviceMessage = AdviceService.getDetailedAdvice(
      irrigation: widget.irrigationLevel,
      fertilizer: widget.fertilizerLevel,
      pesticide: widget.pesticideLevel,
      currentStage: widget.currentStage,
      totalStages: widget.totalStages,
    );

    // Compute dynamic results
    final results = ResultsService.evaluatePerformance(
      irrigation: widget.irrigationLevel,
      fertilizer: widget.fertilizerLevel,
      pesticide: widget.pesticideLevel,
      currentStage: widget.currentStage,
    );
    _starRating = results.starRating;
    _whatHappened = results.whatHappened;
    _why = results.why;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/result_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 40.0, right: 30.0),
          child: Row(
            children: [
              // Left column: Calendar and Farmer
              _buildLeftColumn(),
              const SizedBox(width: 20),
              // Right column: Results panel and Next button
              _buildRightColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    final topPadding = MediaQuery.of(context).padding.top;
    final leftPadding = MediaQuery.of(context).padding.left;
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, left: leftPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Left: Calendar widget
            CalendarWidget(
              currentMonth: widget.currentMonth,
              monthNumber: widget.monthNumber,
            ),
            Spacer(),
            // Left Bottom: Farmer with speech bubble pushed to bottom
            FarmerResultWidget(message: _adviceMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildRightColumn() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spacer to center the results panel
          const Spacer(),
          // Right Center: Results panel
          ResultsPanelWidget(
            whatHappened: _whatHappened,
            why: _why,
            starRating: _starRating,
          ),
          const SizedBox(height: 30),
          // Next button positioned below results panel
          _buildNextButton(),
          // Bottom spacer
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastStage = widget.currentStage == widget.totalStages;

    return Container(
      width: 120,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            if (isLastStage) {
              // Final stage - navigate to final result screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FinalResultScreen(
                        selectedCrop: widget.selectedCrop,
                        irrigationLevel: widget.irrigationLevel,
                        fertilizerLevel: widget.fertilizerLevel,
                        pesticideLevel: widget.pesticideLevel,
                        division: widget.division,
                      ),
                ),
              );
            } else {
              // Not final stage - advance stage and return to cultivation
              widget.onStageAdvance();
              Navigator.pop(context); // Pop result screen (cloud was replaced)
            }
          },
          child: Center(
            child: Text(
              isLastStage ? 'FINISH' : 'NEXT',
              style: GoogleFonts.vt323(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
