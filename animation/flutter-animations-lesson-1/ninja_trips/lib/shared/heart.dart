import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation; // 컬러 변환 애니메이션
  Animation<double> _sizeAnimation; // 사이즈 변환 애니메이션
  Animation _curve;

  bool isFav = false; // 실제환경에서 상태관리가 필요한 값

  @override
  void initState() {
    super.initState();

    /// 애니메이션 컨트롤러로 컨트롤 선언
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    /// 애니메이션 컨트롤러를 할당해주면 커브를 사용가능 / 사용하는 애니메이션에 컨트롤러가 아닌 커브를 할당해주면 됨 (.animate("_curve"))
    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    /// 원하는 애니메이션 효과를 선언(애니메이션 컨트롤러 할당) // 일방향 효과
    _colorAnimation =
        ColorTween(begin: Colors.grey[400], end: Colors.red).animate(_curve);

    /// 양방향 효과
    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 30, end: 50),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 50, end: 30),
        weight: 1,
      ),
    ]).animate(_curve);

    /// 컨트롤러에서 변하는 값 확인
    _controller.addListener(() {
      // print(_controller.value);
      // print(_colorAnimation.value);
    });

    /// 컨트롤러 상태 확인
    /// _controller.forward()  =>  AnimationStatus.complete
    /// _controller.reverse()  =>  AnimationStatus.dismissed
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFav = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    /// 컨트롤러는 다 사용하고 나서 해제시켜줘야 메모리관리가 됨
    // _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return IconButton(
          icon: Icon(
            Icons.favorite,
            color: _colorAnimation.value,
            size: _sizeAnimation.value,
          ),
          onPressed: () {
            isFav ? _controller.reverse() : _controller.forward();
            // /// 에니메이션 컨트롤러 실행
            // _controller.forward();

            // /// 에니메이션 컨트롤러 리버스
            // _controller.reverse();
          },
        );
      },
      // child:
      // IconButton(
      //   icon: Icon(
      //     Icons.favorite,
      //     color: _colorAnimation.value,
      //     size: 30,
      //   ),
      //   onPressed: () {},
      // ),
    );
  }
}
