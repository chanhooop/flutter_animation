import 'dart:math';

import 'package:flutter/material.dart';

class TicketUi extends StatelessWidget {
  const TicketUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('티켓 UI'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 티켓 윗부분 UI
            TicketTopWidget(
              width: 100,
              height: 100,
              borderRadius: 20,
              punchRadius: 10,
              strokeColor: Colors.redAccent,
              strokeWidth: 3,
              child: Container(),
            ),

            /// 티켓 아래부분 UI
            TicketBottomWidget(
              width: 100,
              height: 60,
              punchRadius: 10,
              borderRadius: 20,
              strokeColor: Colors.red,
              strokeWidth: 3,
              child: Container(),
            ),
            SmartTicketWidget(
              topContent: Container(),
              bottomContent: Container(),
              width: 100,
              tHeight: 100,
              bHeight: 50,
              borderRadius: 20,
              punchRadius: 10,
              strokeColor: Colors.yellow,
              strokeWidth: 10,
            )
          ],
        ),
      ),
    );
  }
}

/// 스마트티켓 UI
class SmartTicketWidget extends StatelessWidget {
  /// 티켓 윗부분 위젯
  final Widget topContent;

  /// 티켓 아랫부분 위젯
  final Widget bottomContent;

  /// 티켓 가로길이
  final double width;

  /// 티켓 윗부분 높이
  final double tHeight;

  /// 티켓 아랫부분 높이
  final double bHeight;

  /// 티켓 보더 radius
  final double borderRadius;

  /// 티켓 펀치홀 radius
  final double punchRadius;

  /// 티켓 보더 색
  final Color strokeColor;

  /// 보더 굵기
  final double strokeWidth;

  /// 티켓 윗부분 데코레이션
  final BoxDecoration topBoxDecoration;

  /// 티켓 아랫부분 데코레이션
  final BoxDecoration bottomBoxDecoration;

  const SmartTicketWidget({
    super.key,
    required this.topContent,
    required this.bottomContent,
    required this.width,
    required this.tHeight,
    required this.bHeight,
    required this.borderRadius,
    required this.punchRadius,
    this.strokeColor = Colors.transparent,
    this.strokeWidth = 0,
    this.topBoxDecoration = const BoxDecoration(),
    this.bottomBoxDecoration = const BoxDecoration(),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TicketTopWidget(
          child: topContent,
          width: width,
          height: tHeight,
          borderRadius: borderRadius,
          punchRadius: punchRadius,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
          boxDecoration: topBoxDecoration,
        ),
        TicketBottomWidget(
          child: bottomContent,
          width: width,
          height: bHeight,
          borderRadius: borderRadius,
          punchRadius: punchRadius,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
          boxDecoration: bottomBoxDecoration,
        )
      ],
    );
  }
}

/// 티켓 윗부분 UI
class TicketTopWidget extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double punchRadius;
  final Color strokeColor;
  final double strokeWidth;
  final BoxDecoration boxDecoration;

  const TicketTopWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.punchRadius,
    this.boxDecoration = const BoxDecoration(),
    this.strokeColor = Colors.transparent,
    this.strokeWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketTopClipper(
          borderRadius: borderRadius, punchRadius: punchRadius),
      child: Container(
        width: width,
        height: height,
        decoration: boxDecoration,
        child: CustomPaint(
          painter: TicketTopBorderPainter(
              borderRadius: borderRadius,
              punchRadius: punchRadius,
              strokeColor: strokeColor,
              strokeWidth: strokeWidth),
          child: child,
        ),
      ),
    );
  }
}

/// 티켓 아래부분 UI
class TicketBottomWidget extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double punchRadius;
  final Color strokeColor;
  final double strokeWidth;
  final BoxDecoration boxDecoration;

  const TicketBottomWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.punchRadius,
    this.boxDecoration = const BoxDecoration(),
    this.strokeColor = Colors.transparent,
    this.strokeWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketBottomClipper(
          borderRadius: borderRadius, punchRadius: punchRadius),
      child: Container(
        width: width,
        height: height,
        decoration: boxDecoration,
        child: CustomPaint(
          painter: TicketBottomBorderPainter(
            borderRadius: borderRadius,
            punchRadius: punchRadius,
            strokeColor: strokeColor,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

/// 티켓 윗부분 클리퍼
class TicketTopClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double punchRadius;
  TicketTopClipper({required this.borderRadius, required this.punchRadius});
  @override
  getClip(Size size) {
    Rect ltRect = Rect.fromCircle(
        center: Offset(borderRadius, borderRadius), radius: borderRadius);
    Rect rtRect = Rect.fromCircle(
        center: Offset(size.width - borderRadius, borderRadius),
        radius: borderRadius);
    Rect lbRect =
        Rect.fromCircle(center: Offset(0.0, size.height), radius: punchRadius);
    Rect rbRect = Rect.fromCircle(
        center: Offset(size.width, size.height), radius: punchRadius);
    Path path = Path()
      ..arcTo(ltRect, 3 * pi / 2, -pi / 2, false)
      ..arcTo(lbRect, 3 * pi / 2, pi / 2, false)
      ..arcTo(rbRect, pi, pi / 2, false)
      ..arcTo(rtRect, 0 / 2, -pi / 2, false)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

/// 티켓 윗부분 보더 페인터
class TicketTopBorderPainter extends CustomPainter {
  final double borderRadius;
  final double punchRadius;
  final Color strokeColor;
  final double strokeWidth;
  TicketTopBorderPainter(
      {required this.borderRadius,
      required this.punchRadius,
      required this.strokeColor,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = strokeColor;
    Rect ltRect = Rect.fromCircle(
        center: Offset(borderRadius, borderRadius), radius: borderRadius);
    Rect rtRect = Rect.fromCircle(
        center: Offset(size.width - borderRadius, borderRadius),
        radius: borderRadius);
    Rect lbRect =
        Rect.fromCircle(center: Offset(0.0, size.height), radius: punchRadius);
    Rect rbRect = Rect.fromCircle(
        center: Offset(size.width, size.height), radius: punchRadius);
    Path path = Path()
      ..arcTo(rbRect, pi, pi / 2, false)
      ..arcTo(rtRect, 0 / 2, -pi / 2, false)
      ..arcTo(ltRect, 3 * pi / 2, -pi / 2, false)
      ..arcTo(lbRect, 3 * pi / 2, pi / 2, false);

    canvas.save();

    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 티켓 아랫부분 클리퍼
class TicketBottomClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double punchRadius;

  TicketBottomClipper({required this.borderRadius, required this.punchRadius});

  @override
  Path getClip(Size size) {
    Rect ltRect = Rect.fromCircle(center: Offset.zero, radius: punchRadius);
    Rect rtRect =
        Rect.fromCircle(center: Offset(size.width, 0), radius: punchRadius);
    Rect lbRect = Rect.fromCircle(
        center: Offset(borderRadius, size.height - borderRadius),
        radius: borderRadius);
    Rect rbRect = Rect.fromCircle(
        center: Offset(size.width - borderRadius, size.height - borderRadius),
        radius: borderRadius);
    Path path = Path()
      ..arcTo(ltRect, 0, pi / 2, false)
      ..arcTo(lbRect, pi, -pi / 2, false)
      ..arcTo(rbRect, pi / 2, -pi / 2, false)
      ..arcTo(rtRect, pi / 2, pi / 2, false)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// 티켓 아랫부분 보더 페인터
class TicketBottomBorderPainter extends CustomPainter {
  final double borderRadius;
  final double punchRadius;
  final Color strokeColor;
  final double strokeWidth;
  TicketBottomBorderPainter(
      {required this.borderRadius,
      required this.punchRadius,
      required this.strokeColor,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = strokeColor;
    Rect ltRect = Rect.fromCircle(center: Offset.zero, radius: 10);
    Rect rtRect = Rect.fromCircle(center: Offset(size.width, 0), radius: 10);
    Rect lbRect = Rect.fromCircle(
        center: Offset(borderRadius, size.height - borderRadius),
        radius: borderRadius);
    Rect rbRect = Rect.fromCircle(
        center: Offset(size.width - borderRadius, size.height - borderRadius),
        radius: borderRadius);
    Path path = Path()
      ..arcTo(ltRect, 0, pi / 2, false)
      ..arcTo(lbRect, pi, -pi / 2, false)
      ..arcTo(rbRect, pi / 2, -pi / 2, false)
      ..arcTo(rtRect, pi / 2, pi / 2, false);

    canvas.save();

    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
