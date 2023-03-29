import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyRoulette extends StatelessWidget {
  const MyRoulette({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items = ['상품1', '상품2,', '상품3'];

    return Scaffold(
      appBar: AppBar(
        title: Text('my_roulette'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          width: MediaQuery.of(context).size.width / 2,
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: RoulettePainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class RoulettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final xCenter = size.width / 2;
    final yCenter = size.height / 2;

    final List<Color> colorList = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.purpleAccent
    ];

    canvas.save();

    // 원에 item 갯수에 맞는 배경색
    randerArc(canvas, size, colorList);
    randerTxt(canvas, size, xCenter, yCenter, colorList);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// item 갯수에 맞는 배경 그리기
  randerArc(Canvas canvas, Size size, List<Color> list) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height); // 각도
    final sweepAngle = 2 * pi / list.length;

    canvas.save();

    for (int i = 0; i < list.length; i++) {
      // 3 * pi / 2 = 270도(위로직각)
      final startAngle = ((3 * pi / 2) - (sweepAngle / 2)) + (i * sweepAngle);
      // final startAngle = 3 * pi / 2;
      final paintBackground = Paint()
        ..color = list[i]
        ..style = PaintingStyle.fill;
      final paintBorder = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.save();

      canvas.drawArc(rect, startAngle, sweepAngle, true, paintBackground);
      canvas.drawArc(rect, startAngle, sweepAngle, true, paintBorder);

      canvas.restore();
    }
    canvas.restore();
  }

  /// item num 그려주기
  randerTxt(Canvas canvas, Size size, double xCenter, double yCenter,
      List<dynamic> list) {
    final TextPainter tp = TextPainter(textDirection: TextDirection.ltr);

    canvas.save();

    for (int i = 0; i < list.length; i++) {
      tp.text = TextSpan(
        text: (i + 1).toString(),
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
      );

      canvas.save();

      canvas.restore();
    }

    canvas.restore();
  }
}
