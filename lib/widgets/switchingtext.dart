import 'package:flutter/material.dart';

class SwitchingText extends StatefulWidget {
  final List<String> texts;
  final Duration interval;
  final TextStyle? style;
  const SwitchingText({
    super.key,
    required this.texts,
    this.interval = const Duration(seconds: 5),
    this.style,
  });

  @override
  State<SwitchingText> createState() => SwitchingTextState();
}

class SwitchingTextState extends State<SwitchingText> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startSwitching();
  }

  void _startSwitching() {
    Future.delayed(widget.interval, () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.texts.length;
        });
        _startSwitching();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.texts[_currentIndex], style: widget.style);
  }
}
