import 'package:fam/data/models/crad_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicWidthCard extends StatelessWidget {
  final List<CardItem> cards;
  final double height;

  const DynamicWidthCard({
    super.key,
    required this.cards,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:  EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          final hasGradient =
              card.gradientColors != null && card.gradientColors!.isNotEmpty;

          return GestureDetector(
            onTap: () => _handleDeeplink(card.url),
            child: Container(
              margin:  EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: hasGradient
                    ? LinearGradient(
                        colors: card.gradientColors!
                            .map((color) =>
                                Color(int.parse(color.replaceAll('#', '0xFF'))))
                            .toList(),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: card.bgImage != null
                    ? Image.network(
                        card.bgImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error_outline),
                      )
                    : const SizedBox(),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleDeeplink(String? url) async {
    if (url == null) return;
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error handling deeplink: $e');
    }
  }
}
