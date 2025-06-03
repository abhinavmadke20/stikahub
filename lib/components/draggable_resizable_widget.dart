import 'package:flutter/material.dart';

class DraggableResizableWidget extends StatefulWidget {
  final Widget child;
  const DraggableResizableWidget({required this.child, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DraggableResizableWidgetState createState() => _DraggableResizableWidgetState();
}

class _DraggableResizableWidgetState extends State<DraggableResizableWidget> {
  Offset position = const Offset(100, 100);
  double scale = 1.0;
  double rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        onScaleUpdate: (details) {
          setState(() {
            scale = details.scale;
            rotation = details.rotation;
          });
        },
        child: Transform.rotate(
          angle: rotation,
          child: Transform.scale(
            scale: scale,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
