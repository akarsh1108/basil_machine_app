import 'package:flutter/material.dart';
import 'package:machine_basil/controller/ValueNotifier.dart';

class WaveCard extends StatelessWidget {
  final String name;
  final String url;

  const WaveCard({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: quantityNotifier,
      builder: (context, quantities, child) {
        final quantity = quantities[name] ?? 0;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$quantity ml',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Image.asset(
                  url,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
