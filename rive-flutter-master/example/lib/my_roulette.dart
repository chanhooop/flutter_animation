import 'dart:math';

import 'package:flutter/material.dart';

class MyRoulette extends StatefulWidget {
  const MyRoulette({super.key});

  @override
  State<MyRoulette> createState() => _MyRouletteState();
}

class _MyRouletteState extends State<MyRoulette> {
  @override
  Widget build(BuildContext context) {
    List<String> items = [
      '점심밥1',
      '상품2,',
      '상품3',
      '상품4',
      '상품5',
      '상품6',
      '상품7',
      '상품8',
    ];
    // List<Color> colorList = [
    //   Colors.redAccent,
    //   Colors.orangeAccent,
    //   Colors.yellowAccent,
    // ];

    double angle = 2 * pi / items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('점심판 룰렛'),
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              width: 400,
              height: 450,
              color: Colors.red,
              child: Stack(
                children: [
                  Positioned(
                    top: (400 - 300) / 2,
                    left: (400 - 300) / 2,
                    child: SizedBox(
                      width: 300,
                      child: AnimatedRouletteWidget(
                        items: items,
                        angle: angle,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 40,
                      left: (400 - 30) / 2,
                      child: SizedBox(width: 30, child: Triangle())),
                ],
              ),
            ),
          )),
    );
  }
}

class Triangle extends StatelessWidget {
  const Triangle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1.2,
      child: CustomPaint(
        painter: TrianglePainter(),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.indigo
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final xCenter = size.width / 2;
    final yCenter = size.height / 2;
    canvas.save();
    Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, _paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AnimatedRouletteWidget extends StatefulWidget {
  /// 커스텀 애니메이션 룰렛 위젯
  const AnimatedRouletteWidget(
      {Key? key,
      required this.items,
      required this.angle,
      this.colorList = const [
        Colors.redAccent,
        Colors.orangeAccent,
        Colors.yellowAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.pinkAccent,
        Colors.purpleAccent
      ]})
      : super(key: key);

  /// 아이템 리스트(필수)
  final List items;

  /// 배경색 리스트
  final List<Color> colorList;

  /// 아이템 하나의 각
  final double angle;

  ///

  @override
  State<AnimatedRouletteWidget> createState() => _AnimatedRouletteWidgetState();
}

class _AnimatedRouletteWidgetState extends State<AnimatedRouletteWidget>
    with SingleTickerProviderStateMixin {
  /// 추후 상태관리
  double turns = 0.0;

  /// 추후 상태관리
  bool swichOnOff = false;

  /// 추후 상태관리
  Duration _duration = Duration(milliseconds: 3500);

  /// 추후 상태관리
  int? _random;

  /// 룰렛 작동
  void _startAnimation() async {
    // 아이템 하나당 각도
    double a = 1 / widget.items.length;

    int _randomOn = getGameWinner(context, widget.items); // 룰렛 당첨 로직
    setState(() {
      _duration = const Duration(milliseconds: 3500);
      Future.delayed(const Duration(milliseconds: 3500)).then((value) {
        setState(() {
          _random = _randomOn;
        });
      });
      turns = 8 - (a * _randomOn);
      swichOnOff = !swichOnOff;
    });
  }

  /// 룰렛 리셋
  void _resetAnimation() async {
    setState(() {
      _duration = Duration(milliseconds: 0);
      turns = 0.0;
      swichOnOff = !swichOnOff;
      _random = null;
    });
  }

  /// 룰렛 당첨 로직
  getGameWinner<int>(BuildContext context, List items) {
    print('${items.length}');
    int _random = Random().nextInt(items.length - 1) as int;
    print('adsf 룰렛 당첨 확인 : ${_random}');
    return _random; // 당첨된 아이템 인덱스
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: AnimatedRotation(
            turns: turns,
            duration: _duration,
            curve: Curves.easeInOut,
            child: CustomPaint(
              painter: RoulettePainter(
                  itemList: widget.items,
                  colorList: widget.colorList,
                  fontSize: 15,
                  fontPosition: 1.9),
            ),
          ),
        ),
        // 추후 상태관리 시 빼기
        ElevatedButton(
            onPressed: () {
              swichOnOff ? _resetAnimation() : _startAnimation();
            },
            child: swichOnOff
                ? Text(
                    '리셋',
                    style: TextStyle(color: Colors.redAccent),
                  )
                : Text('시작', style: TextStyle(color: Colors.greenAccent))),
        _random == null ? Text('당첨 : ') : Text('당첨 : ${widget.items[_random!]}')
      ],
    );
  }
}

class RoulettePainter extends CustomPainter {
  /// 커스텀 룰렛 페인터
  RoulettePainter(
      {required this.itemList,
      required this.colorList,
      this.fontSize = 20.0,
      this.fontPosition = 1.7});

  /// 아이템 리스트
  List<dynamic> itemList;

  /// 배경색 리스트
  List<Color> colorList;

  /// 폰트 크기
  double fontSize;

  /// 폰트 위치 (1.0 ~ 2.0)
  double fontPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final xCenter = size.width / 2;
    final yCenter = size.height / 2;
    double angle = 2 * pi / itemList.length;
    canvas.save();

    randerArc(canvas, size, itemList, colorList, angle);
    randerTxt(canvas, size, xCenter, yCenter, itemList, angle, fontSize,
        fontPosition);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// 원 item 별 배경색
  randerArc(Canvas canvas, Size size, List itemList, List<Color> colorList,
      double angle) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height); // 각도
    final sweepAngle = angle;

    canvas.save();

    for (int i = 0; i < itemList.length; i++) {
      // 3 * pi / 2 = 270도(위로직각)
      final startAngle = ((3 * pi / 2) - (sweepAngle / 2)) + (i * sweepAngle);
      final paintBackground = Paint()
        ..color = getBackColor(i, colorList, itemList)
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

  /// 배경색 루프
  getBackColor(int i, List<Color> colorList, List itemList) {
    final int colorPositionLength = colorList.length - 1;
    final int position;

    if (i > colorPositionLength) {
      if (itemList.length % colorList.length == 1 && i == itemList.length - 1) {
        position = 1;
      } else
        position = ((i % colorList.length));

      return colorList[position];
    } else {
      // 컬러 갯수가 아이템 갯수 보다 많을때
      return colorList[i];
    }
  }

  /// item 번호 텍스트 그려주기
  randerTxt(Canvas canvas, Size size, double xCenter, double yCenter,
      List<dynamic> list, double angle, double fontSize, double fontPosition) {
    canvas.save();
    canvas.translate(xCenter, yCenter);
    for (int i = 0; i < list.length; i++) {
      canvas.save();
      canvas.translate(0.0, -yCenter / fontPosition);
      item(canvas, (i + 1).toString(), fontSize);
      canvas.restore();
      canvas.rotate(angle);
    }

    canvas.restore();
  }

  /// item num 디자인
  item(Canvas canvas, String item, double fontSize) {
    final TextPainter tp = TextPainter(textDirection: TextDirection.ltr);
    tp.text = TextSpan(
      text: item,
      style: TextStyle(
          fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
    );
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.drawCircle(Offset.zero, fontSize, backgroundPaint);
    tp.layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }
}
