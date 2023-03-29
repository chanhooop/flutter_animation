import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class CustomRoulette extends StatefulWidget {
  const CustomRoulette({super.key});

  @override
  State<CustomRoulette> createState() => _CustomRouletteState();
}

class _CustomRouletteState extends State<CustomRoulette>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  late int _selectedNumber = 0;

  final List<String> _letters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J'
  ];

  @override
  void initState() {
    super.initState();

    /// 에니메이션 컨트롤러 설정
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.addListener(() {
      print(_animation.value);
      setState(() {});
    });
  }

  /// 룰렛 작동
  void _startAnimation() {
    int _random = Random().nextInt(10);
    _controller.forward(from: 0.0);

    print('asdf 골라진 값 : ${_animation.value}');
    _timer = Timer(Duration(seconds: 5), () {
      print('2초 걸림..??');
      setState(() {
        _selectedNumber = _random;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Roulette'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: _animation.value * 20 * pi,
            child: RouletteShape(
              letters: _letters,
            ),
          ),
          RotationTransition(
            turns: _animation,
            child: RouletteShape(
              letters: _letters,
            ),
          ),
          SizedBox(height: 30),
          MaterialButton(
            child: Text('Spin the Wheel!'),
            onPressed: _startAnimation,
          ),
          SizedBox(height: 20),
          Text(
            _selectedNumber == 0
                ? 'Select a number!'
                : 'Selected: ${_letters[_selectedNumber]}',
            style: TextStyle(fontSize: 20),
          ),
        ],
      )),
    );
  }
}

class RouletteShape extends StatelessWidget {
  final double width;
  final double height;
  final List<String> letters;

  RouletteShape({this.width = 300, this.height = 300, required this.letters});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _RoulettePainter(letters),
    );
  }
}

class _RoulettePainter extends CustomPainter {
  final List<String> _letters;
  final int _maxAngle = 6;

  _RoulettePainter(this._letters);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final sweepAngle = 2 * pi / _maxAngle;

    // for (var i = 0; i < _maxAngle; i++) {
    for (var i = 0; i < _maxAngle; i++) {
      final startAngle = i * sweepAngle;
      final paint = Paint()
        ..color = _getColor(i)
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      final letter = _letters != null && i < _letters.length
          ? _letters[i]
          : String.fromCharCode(65 + i);
      final textPainter = _getTextPainter(letter);
      final angle = startAngle + sweepAngle / 2;
      final radius = size.width / 2;

      canvas.save();
      canvas.translate(radius, radius);
      canvas.rotate(angle);
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
      textPainter.paint(canvas, Offset(100, 0));
      canvas.restore();
    }
  }

  Color _getColor(int angle) {
    if (angle % 2 == 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  TextPainter _getTextPainter(String letter) {
    final style = TextStyle(fontSize: 20, color: Colors.white);
    final textSpan = TextSpan(text: letter, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    return textPainter;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
