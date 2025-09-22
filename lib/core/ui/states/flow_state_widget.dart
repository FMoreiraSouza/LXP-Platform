// lib/core/ui/states/flow_state_widget.dart
import 'package:flutter/material.dart';
import 'package:lxp_platform/core/utils/enums/flow_state.dart';

class FlowStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? function;
  final bool hideButton;
  final FlowState flowState;

  const FlowStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.function,
    this.hideButton = false,
    required this.flowState,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (!hideButton && function != null)
              ElevatedButton(onPressed: function, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (flowState) {
      case FlowState.empty:
        return const Icon(Icons.search_off, size: 64, color: Colors.grey);
      case FlowState.error:
        return const Icon(Icons.error_outline, size: 64, color: Colors.red);
      case FlowState.noConnection:
        return const Icon(Icons.wifi_off, size: 64, color: Colors.orange);
    }
  }
}
