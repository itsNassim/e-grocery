import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const ReadMoreText({
    super.key,
    required this.text,
    this.maxLines = 2,
    this.style,
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final span = TextSpan(
        text: widget.text,
        style: widget.style ?? DefaultTextStyle.of(context).style,
      );

      final tp = TextPainter(
        text: span,
        maxLines: widget.maxLines,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: constraints.maxWidth);

      final isOverflowing = tp.didExceedMaxLines;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: widget.style,
            maxLines: _expanded ? null : widget.maxLines,
            overflow: TextOverflow.fade,
          ),
          if (isOverflowing)
            GestureDetector(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Text(
                _expanded ? 'Read less' : 'Read more',
                style: TextStyle(
                  color: Color(0xFF064C4F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      );
    });
  }
}
