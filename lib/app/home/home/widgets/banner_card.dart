import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../utils/date_formator.dart';
import '../model/home_banner.dart';

Widget bannerCard(HomeBannerModel banner) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Stack(
      children: [
        /// IMAGE
        CachedNetworkImage(
          imageUrl: banner.image,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        /// GRADIENT OVERLAY (EXACT)
        Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        /// TEXT POSITION (EXACT)
        Positioned(
          left: 16,
          top: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),

              const SizedBox(height: 6),

              Text(
                banner.discountText ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              if (banner.validTill != null)
                Text(
                  'Until ${formatBannerDate(banner.validTill!)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}