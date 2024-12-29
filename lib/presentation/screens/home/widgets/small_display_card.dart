import 'package:fam/data/models/crad_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SmallDisplayCard extends StatelessWidget {
  final List<CardItem> cards;
  final bool isScrollable;
  final SharedPreferences prefs;

  const SmallDisplayCard({
    Key? key,
    required this.cards,
    required this.isScrollable,
    required this.prefs,
  }) : super(key: key);

  String _extractText(CardItem card) {
    if (card.formattedTitle != null && card.formattedTitle!.entities.isNotEmpty) {
      return card.formattedTitle!.entities.first.text;
    }
    return card.title;
  }

  Widget _buildCard(BuildContext context, CardItem card) {
    final displayText = _extractText(card);
    final hasGradient = card.gradientColors != null && card.gradientColors!.isNotEmpty;

    return GestureDetector(
      onTap: () => _handleDeeplink(card.url),
      child: Padding(
        padding:  EdgeInsets.only(top: 10.h),
        child: Container(
          margin:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          constraints:  BoxConstraints(maxWidth: 320.w, minWidth: 300.w),
          decoration: BoxDecoration(
            color: card.bgColor != null
                ? Color(int.parse(card.bgColor!.replaceAll('#', '0xFF')))
                : Colors.white,
            gradient: hasGradient
                ? LinearGradient(
                    colors: card.gradientColors!
                        .map((color) => Color(int.parse(color.replaceAll('#', '0xFF'))))
                        .toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _handleDeeplink(card.url),
              child: Padding(
                padding:  EdgeInsets.all(12.r),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (card.icon != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          card.icon!,
                          width: 48.w,
                          height: 48.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error_outline),
                        ),
                      ),
                     SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayText,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: card.formattedTitle?.entities.first.color != null
                                  ? Color(int.parse(card.formattedTitle!.entities.first.color!.replaceAll('#', '0xFF')))
                                  : Colors.black87,
                            ),
                          ),
                          if (card.description != null)
                            Text(
                              card.description!,
                              style:  TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black54,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox();

    if (isScrollable) {
      return SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cards.length,
          itemBuilder: (context, index) => _buildCard(context, cards[index]),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: cards
            .map((card) => _buildCard(context, card))
            .toList(),
      ),
    );
  }
}