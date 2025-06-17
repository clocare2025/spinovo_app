import 'package:flutter/material.dart';

class RoundedChoiceChip extends StatelessWidget {
  final Widget label;
  final bool selected;
  final void Function(bool) onSelected;
  final Color selectedColor;
  final TextStyle? labelStyle;
  final double borderRadius;

  const RoundedChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.selectedColor = const Color.fromARGB(227, 76, 175, 79),
    this.labelStyle,
    this.borderRadius = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        chipTheme: Theme.of(context).chipTheme.copyWith(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
      ),
      child: ChoiceChip(
        label: label,
        selected: selected,
        onSelected: onSelected,
        selectedColor: selectedColor,
        labelStyle: labelStyle,
      ),
    );
  }
}
