import 'package:flutter/cupertino.dart';

class ZoomInOut extends StatefulWidget {
  final double beginScale, endScale;
  final Duration duration;
  final Widget passedChild;
  const ZoomInOut({
    super.key,
    required this.beginScale,
    required this.endScale,
    required this.duration,
    required this.passedChild,
  });

  @override
  State<ZoomInOut> createState() => _ZoomInOutState();
}

class _ZoomInOutState extends State<ZoomInOut> {
  late double tempEnd;

  @override
  void initState() {
    super.initState();
    tempEnd = widget.endScale;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: widget.beginScale, end: tempEnd),
      duration: widget.duration,
      builder: ((context, value, child) {
        return Transform.scale(
          scale: value,
          child: widget.passedChild,
        );
      }),
      onEnd: () {
        setState(() {
          tempEnd =
              tempEnd == widget.endScale ? widget.beginScale : widget.endScale;
        });
      },
    );
  }
}
