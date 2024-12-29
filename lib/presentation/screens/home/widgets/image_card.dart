import 'package:fam/data/models/crad_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageCard extends StatelessWidget {
  final CardItem card;

  const ImageCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(
            int.parse(card.bgColor?.replaceAll('#', '0xFF') ?? '0xFFFFFFFF')),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          card.bgImage ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error_outline),
        ),
      ),
    );
  }
}
