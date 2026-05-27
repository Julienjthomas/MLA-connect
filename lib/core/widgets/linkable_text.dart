import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

/// Renders [text] with http(s) URLs tappable and underlined.
class LinkableText extends StatefulWidget {
  const LinkableText({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  static final _urlPattern = RegExp(r'https?://[^\s]+', caseSensitive: false);

  @override
  State<LinkableText> createState() => _LinkableTextState();
}

class _LinkableTextState extends State<LinkableText> {
  final _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final matches = LinkableText._urlPattern.allMatches(text).toList();

    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    final spans = <TextSpan>[];
    var cursor = 0;

    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      final url = match.group(0)!;
      final recognizer = TapGestureRecognizer()..onTap = () => _openUrl(url);
      _recognizers.add(recognizer);
      spans.add(
        TextSpan(
          text: url,
          style: style.copyWith(
            color: AppColors.primary,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primary,
          ),
          recognizer: recognizer,
        ),
      );
      cursor = match.end;
    }

    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return Text.rich(
      TextSpan(style: style, children: spans),
    );
  }
}
