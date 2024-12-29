import 'package:fam/data/models/crad_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SmallCardWithArrow extends StatelessWidget {
  final CardItem card;
  const SmallCardWithArrow({super.key, required this.card});

  String _extractText() {
    if (card.formattedTitle != null && card.formattedTitle!.entities.isNotEmpty) {
      return card.formattedTitle!.entities.first.text;
    }
    return card.title;
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _extractText();
    
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: card.bgColor != null
            ? Color(int.parse(card.bgColor!.replaceAll('#', '0xFF')))
            : Colors.white,
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
            padding:  EdgeInsets.all(16.r),
            child: Row(
              children: [
                if (card.icon != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      card.icon!,
                      width: 24.w,
                      height: 24.h,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error_outline),
                    ),
                  ),
                 SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: card.formattedTitle?.entities.first.color != null
                          ? Color(int.parse(card.formattedTitle!.entities.first.color!.replaceAll('#', '0xFF')))
                          : Colors.white,
                    ),
                  ),
                ),
                 Icon(Icons.arrow_forward_ios, size: 16.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Future<void> _handleDeeplink(String? url) async {
  if (url == null || url.isEmpty) return;

  try {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, 
      );
    } else {
      debugPrint('Could not launch $url');
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
  }
}
}
