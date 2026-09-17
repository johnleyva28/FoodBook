import 'package:flutter/material.dart';

import '../theme/foodbook_spacing.dart';

/// Resalta las ocurrencias de [query] (case-insensitive) en [text]
/// usando el color primario de la app.
class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? baseStyle;
  final Color? highlightColor;
  final FontWeight highlightWeight;

  const HighlightedText({
    super.key,
    required this.text,
    this.query = '',
    this.baseStyle,
    this.highlightColor,
    this.highlightWeight = FontWeight.w800,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = baseStyle ?? theme.textTheme.bodyMedium!;
    final color = highlightColor ?? theme.colorScheme.primary;

    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    if (!lowerText.contains(lowerQuery)) {
      return Text(text, style: style);
    }

    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final idx = lowerText.indexOf(lowerQuery, start);
      if (idx < 0) {
        spans.add(TextSpan(text: text.substring(start), style: style));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx), style: style));
      }
      spans.add(
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: style.copyWith(
            color: color,
            fontWeight: highlightWeight,
            backgroundColor: color.withValues(alpha: 0.18),
          ),
        ),
      );
      start = idx + query.length;
      if (start >= text.length) break;
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Tile de resultado de búsqueda con texto resaltado.
class HighlightedSearchTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String query;
  final String subtitle;
  final String trailing;

  const HighlightedSearchTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.query,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.18),
          child: Icon(icon, color: color),
        ),
        title: HighlightedText(
          text: title,
          query: query,
          baseStyle: theme.textTheme.titleSmall,
        ),
        subtitle: subtitle.isEmpty
            ? null
            : HighlightedText(
                text: subtitle,
                query: query,
                baseStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
        trailing: Text(
          trailing,
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
