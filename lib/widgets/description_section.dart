import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DescriptionSection extends StatelessWidget {
  final String description;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const DescriptionSection({
    super.key,
    required this.description,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the description, either fully expanded or shortened
        MarkdownBody(
          data: isExpanded ? description : _shortenDescription(description),
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        // Show "Read more" or "Show less" if the description is longer than 200 characters
        if (description.length > 200)
          GestureDetector(
            onTap: onToggleExpand,
            child: Text(
              isExpanded ? 'Show less' : 'Read more',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }

  /// Shortens the description to 200 characters with an ellipsis if it exceeds that length.
  String _shortenDescription(String description) {
    return description.length > 200 ? '${description.substring(0, 200)}...' : description;
  }
}
