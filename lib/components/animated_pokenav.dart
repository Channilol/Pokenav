import 'package:flutter/material.dart';

class AnimatedPokenav extends StatefulWidget {
  const AnimatedPokenav({super.key, required this.loadingPercent});

  final double loadingPercent;

  @override
  State<AnimatedPokenav> createState() => _AnimatedPokenavState();
}

class _AnimatedPokenavState extends State<AnimatedPokenav>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Color getPercentageColor(double percentage) {
    if (percentage < 33) {
      return Colors.red;
    } else if (percentage < 66) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        children: [
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: 100,
              width: 50,
              color: getPercentageColor(widget.loadingPercent),
            ),
          ),
          Positioned.fill(
            child: SizedBox(
              height: 300,
              child: Image.asset('assets/images/pokenav.png'),
            ),
          ),
        ],
      ),
    );
  }
}
