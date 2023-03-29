import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomWatch extends StatefulWidget {
  const CustomWatch({super.key});

  @override
  State<CustomWatch> createState() => _CustomWatchState();
}

class _CustomWatchState extends State<CustomWatch> {
  DateTime now = DateTime.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('custom_watch'),
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          width: MediaQuery.of(context).size.width / 2,
          // height: MediaQuery.of(context).size.height / 2,
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: CustomPaint(
              painter: WatchPainter(now),
            ),
          ),
        ),
      ),
    );
  }
}

class WatchPainter extends CustomPainter {
  final TextPainter tp;
  final Color primaryColor;
  final DateTime now;

  /// WatchPainter가 생성 될 때 tp를 initailize 시켜준다.
  WatchPainter(DateTime now)
      : this.tp = TextPainter(
          textDirection: TextDirection.ltr, // 왼쪽부터 오른쪽으로 글자 쓰기
        ),
        this.primaryColor = Color(0xffe57242),
        this.now = now;

  /// 기본 메서드 그림 그려지는 부분
  @override
  void paint(Canvas canvas, Size size) {
    final xCenter = size.width / 2;
    final yCenter = size.height / 2;

    final angle = (2 * pi) / 12;

    // tp.text = const TextSpan(
    //     text: 'test',
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: 20.0,
    //     ));

    // tp.layout(); // 텍스트페인터를 레이아웃 시킴
    // tp.paint(canvas, Offset(xCenter, yCenter)); // 텍스트 페인터로 텍스트를 그려줌(off)

    canvas.save();

    canvas.translate(xCenter, yCenter); // 그려지는 캔버스 위치이동

    randerText(canvas, size, xCenter, yCenter, angle);
    randerHands(canvas, size, xCenter, yCenter);

    canvas.restore();
  }

  /// 기본 메서드
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// 시침, 분침 초침 그려주는 함수
  randerHands(Canvas canvas, Size size, double xCenter, double yCenter) {
    canvas.save();

    final innerPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final outerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final secPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square;

    final rootPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square;

    final rootWhiteCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rootPrimaryCirclePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final rootBlackCirclePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final rootOffset = 15.0;

    DateTime now = DateTime.now();

    final hourAngle =
        (now.hour % 12) * (2 * pi / 12) + (now.minute) * (2 * pi / (12 * 60));
    final minuteAngle = now.minute * (2 * pi / 60);
    final secondAngle = now.second * (2 * pi / 60);

    // 시침
    canvas.save();
    canvas.rotate(hourAngle);
    canvas.drawLine(Offset.zero, Offset(0.0, -rootOffset), rootPaint);
    canvas.drawLine(
        Offset(0.0, -rootOffset), Offset(0.0, -xCenter * 0.7), outerPaint);
    canvas.drawLine(
        Offset(0.0, -rootOffset), Offset(0.0, -xCenter * 0.7), innerPaint);
    canvas.restore();

    // 분침
    canvas.save();
    canvas.rotate(minuteAngle);
    canvas.drawLine(Offset.zero, Offset(0.0, -rootOffset), rootPaint);
    canvas.drawLine(
        Offset(0.0, -rootOffset), Offset(0.0, -xCenter * 0.9), outerPaint);
    canvas.drawLine(
        Offset(0.0, -rootOffset), Offset(0.0, -xCenter * 0.9), innerPaint);
    canvas.restore();

    // 초침
    canvas.save();

    canvas.rotate(secondAngle);
    canvas.drawLine(Offset(0.0, -10.0), Offset(0.0, xCenter * 0.9), secPaint);
    canvas.drawCircle(Offset.zero, 6.0, rootWhiteCirclePaint);
    canvas.drawCircle(Offset.zero, 4.0, rootPrimaryCirclePaint);
    canvas.drawCircle(Offset.zero, 2.0, rootBlackCirclePaint);
    canvas.restore();

    canvas.restore();
  }

  /// 숫자 그리는 함수
  randerText(Canvas canvas, Size size, double xCenter, double yCenter, angle) {
    canvas.save();

    final vertLength = yCenter / cos(angle);
    final horiLength = xCenter / sin(angle * 2);

    final lengthList = [
      yCenter,
      vertLength,
      horiLength,
      xCenter,
      horiLength,
      vertLength,
      yCenter,
    ];

    for (int i = 0; i < 12; i++) {
      canvas.save();

      canvas.translate(0.0, -lengthList[i % 6]);

      final display = i == 0 ? '12' : i.toString();

      tp.text = TextSpan(
          text: display,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: primaryColor));

      canvas.rotate(-angle * i);

      tp.layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

      canvas.restore();

      canvas.rotate(angle);
    }

    canvas.restore();
  }
}
