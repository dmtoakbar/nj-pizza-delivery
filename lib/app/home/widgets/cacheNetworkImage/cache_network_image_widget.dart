import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child:
            imageUrl == null || imageUrl!.isEmpty
                ? _errorWidget()
                : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: fit,
                  color: color,
                  placeholder: (context, url) => _loadingWidget(),
                  errorWidget: (context, url, error) => _errorWidget(),
                ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image_outlined,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
