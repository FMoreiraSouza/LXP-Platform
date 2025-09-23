import 'package:flutter/material.dart';

class AppLoadWidget extends StatelessWidget {
  final String? label;
  final Color? textColor;

  const AppLoadWidget({super.key, this.label, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (label != null) ...[
              const SizedBox(height: 16),
              Text(label!, style: TextStyle(color: textColor, fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
