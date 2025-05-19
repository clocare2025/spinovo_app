import 'package:flutter/material.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class HomeMsgSextion extends StatelessWidget {
  const HomeMsgSextion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Live it up!',
          size: 50,
          color: const Color.fromARGB(131, 165, 165, 165),
          fontweights: FontWeight.bold,
          overFlow: TextOverflow.visible,
        ),
        CustomText(
          text: 'India’s first quick laundry service',
          size: 14,
          color: const Color.fromARGB(176, 143, 143, 143),
          fontweights: FontWeight.w500,
          overFlow: TextOverflow.visible,
        ),
        CustomText(
          text: 'Crafted with ❤️ in India',
          size: 14,
              color: const Color.fromARGB(176, 143, 143, 143),
          fontweights: FontWeight.w500,
          overFlow: TextOverflow.visible,
        ),
                       
      ],
    );
  }
}
