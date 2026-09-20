import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'match_card_colors.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.target});

  final DateTime target;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining = widget.target.difference(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _remaining = widget.target.difference(DateTime.now()));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _remaining.isNegative ? Duration.zero : _remaining;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimeBlock(
          value: remaining.inDays,
          label: 'DAYS',
          bubbleColor: MatchCardColors.timerBlueBubble,
        ),
        const _Colon(),
        _TimeBlock(
          value: remaining.inHours % 24,
          label: 'HRS',
          bubbleColor: MatchCardColors.timerBlueBubble,
        ),
        const _Colon(),
        _TimeBlock(
          value: remaining.inMinutes % 60,
          label: 'MINS',
          bubbleColor: MatchCardColors.timerRedBubble,
        ),
        const _Colon(),
        _TimeBlock(
          value: remaining.inSeconds % 60,
          label: 'SECS',
          bubbleColor: MatchCardColors.timerRedBubble,
        ),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.value,
    required this.label,
    required this.bubbleColor,
  });

  final int value;
  final String label;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: GoogleFonts.oswald(
            color: MatchCardColors.yellowAccent,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3, top: 4),
      child: Text(
        ':',
        style: GoogleFonts.oswald(
          color: MatchCardColors.yellowAccent,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}
