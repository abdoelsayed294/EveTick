import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class EventCoverImage extends StatelessWidget {
  const EventCoverImage({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(color: context.colors.thirdBlue);
    if (url.isEmpty) return placeholder;

    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : placeholder,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
