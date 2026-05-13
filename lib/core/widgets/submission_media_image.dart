import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/services/submission_media_access.dart';

class SubmissionMediaImage extends StatelessWidget {
  final String reference;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const SubmissionMediaImage({
    super.key,
    required this.reference,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = SubmissionMediaAccess.isSubmissionObjectReference(reference)
        ? SubmissionMediaAccess.authenticatedObjectUrl(reference)
        : reference.trim();
    final headers = SubmissionMediaAccess.isSubmissionObjectReference(reference)
        ? SubmissionMediaAccess.authHeaders()
        : const <String, String>{};

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      httpHeaders: headers,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => placeholder ?? const SizedBox.shrink(),
      errorWidget: (_, __, ___) => errorWidget ?? placeholder ?? const SizedBox.shrink(),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}
