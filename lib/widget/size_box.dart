import 'package:flutter/material.dart';

class Height extends StatelessWidget {
  final double heights;
  const Height(this.heights, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heights,
    );
  }
}


class Widths extends StatelessWidget {
  final double widths;
  const Widths(this.widths, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widths,
    );
  }
}
