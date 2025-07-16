import 'package:flutter/material.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class RetryWidget extends StatelessWidget {
  final String msg;
  final Function onTap;
  const RetryWidget({super.key, required this.msg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: msg ,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
             onTap();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
