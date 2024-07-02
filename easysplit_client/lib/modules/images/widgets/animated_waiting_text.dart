import 'package:easysplit_flutter/modules/images/stores/process_store.dart';
import 'package:flutter/material.dart';

class AnimatedWaitingText extends StatefulWidget {
  final List<String> baseTexts;
  final TextStyle textStyle;

  const AnimatedWaitingText({
    super.key,
    required this.baseTexts,
    required this.textStyle,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedWaitingTextState();
  }
}

class _AnimatedWaitingTextState extends State<AnimatedWaitingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  final ProcessStore _processStore = ProcessStore();
  final List<String> _texts = [];
  late int _lastIndex;

  @override
  void initState() {
    super.initState();

    for (var text in widget.baseTexts) {
      _texts.add(text);
      _texts.add('$text${'.'}');
      _texts.add('$text${'.' * 2}');
      _texts.add('$text${'.' * 3}');
      _texts.add('$text${'.' * 3}');
    }

    _lastIndex = _texts.length - 1;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );

    _animation = IntTween(begin: 0, end: _lastIndex).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            !_processStore.loopingLastText) {
          _processStore.setLoopingLastText(true);
          _controller.duration = const Duration(seconds: 3);
          _controller.reset();
          _animation = IntTween(begin: _lastIndex - 4, end: _lastIndex).animate(
            CurvedAnimation(parent: _controller, curve: Curves.linear),
          )..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                _controller.reset();
                _controller.forward();
              }
            });
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Text(
          _texts[_animation.value],
          style: widget.textStyle,
        );
      },
    );
  }
}
