import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SandBox extends StatefulWidget {
  const SandBox({Key key}) : super(key: key);

  @override
  State<SandBox> createState() => _SandBoxState();
}

class _SandBoxState extends State<SandBox> {
  double _opacity = 1;
  double _margin = 20;
  double _width = 200;
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 900),
        margin: EdgeInsets.all(_margin),
        width: _width,
        color: _color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => setState(() => _margin = 50),
                child: Text(
                  'animate margin',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                )),
            TextButton(
                onPressed: () => setState(() => _color = Colors.purple),
                child: Text(
                  'animate color',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                )),
            TextButton(
                onPressed: () => setState(() => _width = 400),
                child: Text(
                  'animate width',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                )),
            TextButton(
                onPressed: () => setState(() => _opacity = 0),
                child: Text(
                  'animate opacity',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                )),
            AnimatedOpacity(
              duration: Duration(seconds: 2),
              opacity: _opacity,
              child: Text(
                'hide me',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
