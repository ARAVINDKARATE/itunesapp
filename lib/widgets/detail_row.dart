import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String title;
  final String? value;

  const DetailRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title text with bold font and white color
          Text(
            '$title: ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Value text with ellipsis overflow handling
          Expanded(
            child: Text(
              value ?? 'N/A', // Display 'N/A' if value is null
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis, // Truncate text with ellipsis if it overflows
            ),
          ),
        ],
      ),
    );
  }
}
