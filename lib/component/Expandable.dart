import 'dart:math';

import 'package:flutter/material.dart';

class Expandable extends StatefulWidget {
  final double distance;
  final List<Widget> children;

  Expandable({Key? key, required this.distance, required this.children})
      : super(key: key);
  @override
  _ExpandableState createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        value: _open ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300));
    _expandAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(alignment: Alignment.bottomRight,
          children: [
            _buildTabToCloseFab(),
            _buildTabToOpenFab(),
          ]..insertAll(0, _buildExpandableActionButton())),
    );
  }
  List<_ExpandableActionButton> _buildExpandableActionButton(){
    List<_ExpandableActionButton> animChildren = [];
    final int count = widget.children.length;
    final double gap = 90.0 / (count - 1);

    for(var i=0, degree = 0.0; i < count; i++, degree += gap){
      animChildren.add(_ExpandableActionButton(
        distance: widget.distance,
        degree: degree,
        progress: _expandAnimation,
        child: widget.children[i],
      ));
    }
    return animChildren;
  }
  AnimatedContainer _buildTabToCloseFab() {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      duration: Duration(milliseconds: 300),
      transform: Matrix4.rotationZ(_open ? 0 : pi / 4), //원주의 1/4만큼 rotate하겠다.
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: toggle,
        child: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  AnimatedContainer _buildTabToOpenFab() {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      duration: Duration(milliseconds: 1000),
      transform: Matrix4.rotationZ(_open ? 0 : pi / 4), //원주의 1/4만큼 rotate하겠다.
      child: AnimatedOpacity(
        child: FloatingActionButton(
          onPressed: toggle,
          child: Icon(Icons.close),
        ),
        duration: Duration(milliseconds: 300),
        opacity: _open ? 0.0 : 1.0,
      ),
    );
  }

  void toggle() {
    _open = !_open;
    setState(() {
      if (_open)
        _controller.forward();
      else
        _controller.reverse();
    });
  }
}

class _ExpandableActionButton extends StatelessWidget {
  final double distance;
  final double degree;
  final Animation<double> progress;
  final Widget child;

  const _ExpandableActionButton(
      {Key? key,
        required this.distance,
        required this.degree,
        required this.progress,
        required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: progress,
        builder: (context, child) {
          // 이 child와 같음
          //시간에 따른 거리 계산
          final Offset offset = Offset.fromDirection(
              degree * (pi / 180), progress.value * distance);
          return Positioned(
            right: offset.dx + 4,
            bottom: offset.dy,
            child: child!, // 위의 child와 같은
          );
        },
        child: child);
  }
}