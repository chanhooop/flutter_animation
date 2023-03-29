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
                // painter: ,
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

    canvas.save();

    // 원에 item 갯수에 맞는 색
    randerArc(canvas, size, xCenter, yCenter);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// 원에 item 갯수에 맞는 색
  randerArc(Canvas canvas, Size size, double xCenter, double yCenter) {
    final List<Color> colorList = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.purpleAccent
    ];
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.save();

    // canvas.drawArc(rect, startAngle, sweepAngle, true, paint)

    canvas.restore();
  }
}
