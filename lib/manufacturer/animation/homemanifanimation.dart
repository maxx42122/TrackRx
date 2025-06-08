import 'package:flutter/material.dart';

class AnimatedAlignExample extends StatefulWidget {
  const AnimatedAlignExample({
    required this.duration,
    super.key,
  });

  final Duration duration;

  //final Curve curve;

  @override
  State<AnimatedAlignExample> createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
          });
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.white10,
              child: AnimatedAlign(
                alignment: selected ? Alignment.topRight : Alignment.bottomLeft,
                duration: widget.duration,
                //curve: widget.curve,
                child: const Icon(
                  Icons.add_home_work_outlined,
                  size: 50,
                ),
              ),
            ),
          ),
        ));
  }
}
