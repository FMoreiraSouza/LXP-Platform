import 'package:flutter/material.dart';

class AppLoadWidget extends StatelessWidget {
  final String? label;
  final Color? bgColor;
  final Color? textColor;

  const AppLoadWidget({
    super.key,
    this.label,
    this.bgColor = Colors.white,
    this.textColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (label != null) ...[
              const SizedBox(height: 16),
              Text(
                label!,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}