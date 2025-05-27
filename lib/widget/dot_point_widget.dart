import 'package:flutter/material.dart';

class dotPointWidget extends StatelessWidget {
  const dotPointWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(20, (index) {
        return Container(
          width: 8,
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 196, 196, 196),
            // shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}