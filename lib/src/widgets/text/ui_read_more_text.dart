import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// How [UIReadMoreText] trims overflowing content.
enum UIReadMoreTrimMode {
  /// Trim by character count ([UIReadMoreText.trimLength]).
  length,

  /// Trim by line count ([UIReadMoreText.trimLines]).
  line,
}

/// Highlighted pattern inside [UIReadMoreText] (URLs, mentions, etc.).
@immutable
class UIReadMoreAnnotation {
  const UIReadMoreAnnotation({required this.regExp, required this.spanBuilder});

  final RegExp regExp;
  final TextSpan Function({required String text, required TextStyle textStyle})
  spanBuilder;
}

/// Expandable text with optional pattern annotations and line/length trimming.
class UIReadMoreText extends StatefulWidget {
  const UIReadMoreText(
    String this.data, {
    super.key,
    this.isCollapsed,
    this.preDataText,
    this.postDataText,
    this.preDataTextStyle,
    this.postDataTextStyle,
    this.trimExpandedText = 'Show less',
    this.trimCollapsedText = 'Read more',
    this.linkColor,
    this.trimLength = 240,
    this.trimLines = 2,
    this.trimMode = UIReadMoreTrimMode.length,
    this.moreStyle,
    this.lessStyle,
    this.delimiter = '$_kEllipsis ',
    this.delimiterStyle,
    this.annotations,
    this.isExpandable = true,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : richData = null,
       richPreData = null,
       richPostData = null;

  const UIReadMoreText.rich(
    TextSpan this.richData, {
    super.key,
    this.richPreData,
    this.richPostData,
    this.isCollapsed,
    this.trimExpandedText = 'Show less',
    this.trimCollapsedText = 'Read more',
    this.linkColor,
    this.trimLength = 240,
    this.trimLines = 2,
    this.trimMode = UIReadMoreTrimMode.length,
    this.moreStyle,
    this.lessStyle,
    this.delimiter = '$_kEllipsis ',
    this.delimiterStyle,
    this.isExpandable = true,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : data = null,
       annotations = null,
       preDataText = null,
       postDataText = null,
       preDataTextStyle = null,
       postDataTextStyle = null;

  final ValueNotifier<bool>? isCollapsed;
  final int trimLength;
  final int trimLines;
  final UIReadMoreTrimMode trimMode;
  final TextStyle? moreStyle;
  final TextStyle? lessStyle;
  final String? preDataText;
  final String? postDataText;
  final TextStyle? preDataTextStyle;
  final TextStyle? postDataTextStyle;
  final TextSpan? richPreData;
  final TextSpan? richPostData;
  final List<UIReadMoreAnnotation>? annotations;
  final bool isExpandable;
  final String delimiter;
  final String? data;
  final TextSpan? richData;
  final String trimExpandedText;
  final String trimCollapsedText;
  final Color? linkColor;
  final TextStyle? delimiterStyle;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  State<UIReadMoreText> createState() => _UIReadMoreTextState();
}

const String _kEllipsis = '\u2026';
const String _kLineSeparator = '\u2028';

class _UIReadMoreTextState extends State<UIReadMoreText> {
  static final _nonCapturingGroupPattern = RegExp(r'\((?!\?:)');

  final TapGestureRecognizer _recognizer = TapGestureRecognizer();
  ValueNotifier<bool>? _isCollapsed;

  ValueNotifier<bool> get _effectiveIsCollapsed =>
      widget.isCollapsed ?? (_isCollapsed ??= ValueNotifier(true));

  @override
  void initState() {
    super.initState();
    _recognizer.onTap = _onTap;
  }

  @override
  void didUpdateWidget(UIReadMoreText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed == null && oldWidget.isCollapsed != null) {
      final oldValue = oldWidget.isCollapsed!.value;
      (_isCollapsed ??= ValueNotifier(oldValue)).value = oldValue;
    }
  }

  @override
  void dispose() {
    _recognizer.dispose();
    _isCollapsed?.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.isExpandable) {
      _effectiveIsCollapsed.value = !_effectiveIsCollapsed.value;
    }
  }

  RegExp? _mergeRegexPatterns(List<UIReadMoreAnnotation>? annotations) {
    if (annotations == null || annotations.isEmpty) return null;
    if (annotations.length == 1) return annotations[0].regExp;
    return RegExp(
      annotations
          .map(
            (a) =>
                '(${a.regExp.pattern.replaceAll(_nonCapturingGroupPattern, '(?:')})',
          )
          .join('|'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _effectiveIsCollapsed,
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, bool isCollapsed, Widget? child) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    } else {
      effectiveTextStyle = widget.style!;
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle.merge(
        const TextStyle(fontWeight: FontWeight.bold),
      );
    }

    final registrar = SelectionContainer.maybeOf(context);
    final textScaler = widget.textScaler ?? MediaQuery.textScalerOf(context);
    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final locale = widget.locale ?? Localizations.maybeLocaleOf(context);
    final softWrap = widget.softWrap ?? defaultTextStyle.softWrap;
    final overflow = widget.overflow ?? defaultTextStyle.overflow;
    final textWidthBasis =
        widget.textWidthBasis ?? defaultTextStyle.textWidthBasis;
    final textHeightBehavior =
        widget.textHeightBehavior ??
        defaultTextStyle.textHeightBehavior ??
        DefaultTextHeightBehavior.maybeOf(context);
    final selectionColor =
        widget.selectionColor ??
        DefaultSelectionStyle.of(context).selectionColor ??
        DefaultSelectionStyle.defaultColor;

    final linkColor = widget.linkColor ?? Theme.of(context).colorScheme.primary;
    final defaultLessStyle =
        widget.lessStyle ?? effectiveTextStyle.copyWith(color: linkColor);
    final defaultMoreStyle =
        widget.moreStyle ?? effectiveTextStyle.copyWith(color: linkColor);
    final defaultDelimiterStyle = widget.delimiterStyle ?? effectiveTextStyle;

    final link = TextSpan(
      text: isCollapsed ? widget.trimCollapsedText : widget.trimExpandedText,
      style: isCollapsed ? defaultMoreStyle : defaultLessStyle,
      recognizer: _recognizer,
    );

    final delimiter = TextSpan(
      text: isCollapsed && widget.trimCollapsedText.isNotEmpty
          ? widget.delimiter
          : '',
      style: defaultDelimiterStyle,
      recognizer: _recognizer,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final maxWidth = constraints.maxWidth;

        TextSpan? preTextSpan;
        TextSpan? postTextSpan;

        if (widget.richPreData != null) {
          preTextSpan = widget.richPreData;
        } else if (widget.preDataText != null) {
          preTextSpan = TextSpan(
            text: '${widget.preDataText!} ',
            style: widget.preDataTextStyle ?? effectiveTextStyle,
          );
        }

        if (widget.richPostData != null) {
          postTextSpan = widget.richPostData;
        } else if (widget.postDataText != null) {
          postTextSpan = TextSpan(
            text: ' ${widget.postDataText!}',
            style: widget.postDataTextStyle ?? effectiveTextStyle,
          );
        }

        final TextSpan dataTextSpan;
        if (widget.richData != null) {
          assert(_isTextSpan(widget.richData!));
          dataTextSpan = TextSpan(
            style: effectiveTextStyle,
            children: [widget.richData!],
          );
        } else {
          dataTextSpan = _buildAnnotatedTextSpan(
            data: widget.data!,
            textStyle: effectiveTextStyle,
            regExp: _mergeRegexPatterns(widget.annotations),
            annotations: widget.annotations,
          );
        }

        final text = TextSpan(
          children: [
            if (preTextSpan != null) preTextSpan,
            dataTextSpan,
            if (postTextSpan != null) postTextSpan,
          ],
        );

        final textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          textScaler: textScaler,
          maxLines: widget.trimLines,
          strutStyle: widget.strutStyle,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          ellipsis: overflow == TextOverflow.ellipsis ? widget.delimiter : null,
        )..layout(maxWidth: maxWidth);
        final linkSize = textPainter.size;

        textPainter.text = delimiter;
        textPainter.layout(maxWidth: maxWidth);
        final delimiterSize = textPainter.size;

        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        var linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final readMoreSize = linkSize.width + delimiterSize.width;
          final pos = textPainter.getPositionForOffset(
            Offset(
              textDirection == TextDirection.rtl
                  ? readMoreSize
                  : textSize.width - readMoreSize,
              textSize.height,
            ),
          );
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          final pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }

        late final TextSpan textSpan;
        switch (widget.trimMode) {
          case UIReadMoreTrimMode.length:
            if (widget.richData != null) {
              final trimResult = _trimTextSpan(
                textSpan: dataTextSpan,
                spanStartIndex: 0,
                endIndex: widget.trimLength,
                splitByRunes: true,
              );
              textSpan = trimResult.didTrim
                  ? TextSpan(
                      children: [
                        if (isCollapsed) trimResult.textSpan else dataTextSpan,
                        delimiter,
                        link,
                      ],
                    )
                  : dataTextSpan;
            } else if (widget.trimLength < widget.data!.runes.length) {
              final effectiveDataTextSpan = isCollapsed
                  ? _trimTextSpan(
                      textSpan: dataTextSpan,
                      spanStartIndex: 0,
                      endIndex: widget.trimLength,
                      splitByRunes: true,
                    ).textSpan
                  : dataTextSpan;
              textSpan = TextSpan(
                children: [effectiveDataTextSpan, delimiter, link],
              );
            } else {
              textSpan = dataTextSpan;
            }
          case UIReadMoreTrimMode.line:
            if (textPainter.didExceedMaxLines) {
              final effectiveDataTextSpan = isCollapsed
                  ? _trimTextSpan(
                      textSpan: dataTextSpan,
                      spanStartIndex: 0,
                      endIndex: endIndex,
                      splitByRunes: false,
                    ).textSpan
                  : dataTextSpan;
              textSpan = TextSpan(
                children: [
                  effectiveDataTextSpan,
                  if (linkLongerThanLine) const TextSpan(text: _kLineSeparator),
                  delimiter,
                  link,
                ],
              );
            } else {
              textSpan = dataTextSpan;
            }
        }

        return RichText(
          text: TextSpan(
            children: [
              if (preTextSpan != null) preTextSpan,
              textSpan,
              if (postTextSpan != null) postTextSpan,
            ],
          ),
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaler: textScaler,
          strutStyle: widget.strutStyle,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionRegistrar: registrar,
          selectionColor: selectionColor,
        );
      },
    );

    if (registrar != null) {
      result = MouseRegion(
        cursor:
            DefaultSelectionStyle.of(context).mouseCursor ??
            SystemMouseCursors.text,
        child: result,
      );
    }
    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(child: result),
      );
    }
    return result;
  }

  TextSpan _buildAnnotatedTextSpan({
    required String data,
    required TextStyle textStyle,
    required RegExp? regExp,
    required List<UIReadMoreAnnotation>? annotations,
  }) {
    if (regExp == null || data.isEmpty) {
      return TextSpan(text: data, style: textStyle);
    }

    final contents = <TextSpan>[];
    data.splitMapJoin(
      regExp,
      onMatch: (Match regexMatch) {
        final matchedText = regexMatch.group(0)!;
        late final UIReadMoreAnnotation matchedAnnotation;

        if (annotations!.length == 1) {
          matchedAnnotation = annotations[0];
        } else {
          for (var i = 0; i < regexMatch.groupCount; i++) {
            if (matchedText == regexMatch.group(i + 1)) {
              matchedAnnotation = annotations[i];
              break;
            }
          }
        }

        final content = matchedAnnotation.spanBuilder(
          text: matchedText,
          textStyle: textStyle,
        );
        assert(_isTextSpan(content));
        contents.add(content);
        return '';
      },
      onNonMatch: (String unmatchedText) {
        contents.add(TextSpan(text: unmatchedText));
        return '';
      },
    );

    return TextSpan(style: textStyle, children: contents);
  }

  _TextSpanTrimResult _trimTextSpan({
    required TextSpan textSpan,
    required int spanStartIndex,
    required int endIndex,
    required bool splitByRunes,
  }) {
    var spanEndIndex = spanStartIndex;
    final text = textSpan.text;

    if (text != null) {
      final textLen = splitByRunes ? text.runes.length : text.length;
      spanEndIndex += textLen;

      if (spanEndIndex >= endIndex) {
        final newText = splitByRunes
            ? String.fromCharCodes(text.runes, 0, endIndex - spanStartIndex)
            : text.substring(0, endIndex - spanStartIndex);

        return _TextSpanTrimResult(
          textSpan: TextSpan(
            text: newText,
            style: textSpan.style,
            recognizer: textSpan.recognizer,
            mouseCursor: textSpan.mouseCursor,
            onEnter: textSpan.onEnter,
            onExit: textSpan.onExit,
            semanticsLabel: textSpan.semanticsLabel,
            locale: textSpan.locale,
            spellOut: textSpan.spellOut,
          ),
          spanEndIndex: spanEndIndex,
          didTrim: true,
        );
      }
    }

    var didTrim = false;
    final newChildren = <InlineSpan>[];
    final children = textSpan.children;

    if (children != null) {
      for (final child in children) {
        if (child is TextSpan) {
          final result = _trimTextSpan(
            textSpan: child,
            spanStartIndex: spanEndIndex,
            endIndex: endIndex,
            splitByRunes: splitByRunes,
          );
          spanEndIndex = result.spanEndIndex;
          newChildren.add(result.textSpan);
          if (result.didTrim) {
            didTrim = true;
            break;
          }
        } else {
          newChildren.add(child);
        }
      }
    }

    return _TextSpanTrimResult(
      textSpan: didTrim
          ? TextSpan(
              text: textSpan.text,
              children: newChildren,
              style: textSpan.style,
              recognizer: textSpan.recognizer,
              mouseCursor: textSpan.mouseCursor,
              onEnter: textSpan.onEnter,
              onExit: textSpan.onExit,
              semanticsLabel: textSpan.semanticsLabel,
              locale: textSpan.locale,
              spellOut: textSpan.spellOut,
            )
          : textSpan,
      spanEndIndex: spanEndIndex,
      didTrim: didTrim,
    );
  }

  bool _isTextSpan(InlineSpan span) {
    if (span is! TextSpan) return false;
    final children = span.children;
    if (children == null || children.isEmpty) return true;
    return children.every(_isTextSpan);
  }
}

@immutable
class _TextSpanTrimResult {
  const _TextSpanTrimResult({
    required this.textSpan,
    required this.spanEndIndex,
    required this.didTrim,
  });

  final TextSpan textSpan;
  final int spanEndIndex;
  final bool didTrim;
}
