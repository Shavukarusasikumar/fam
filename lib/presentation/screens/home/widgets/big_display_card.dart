import 'package:fam/data/models/crad_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fam/domain/entities/formatted_text_entity.dart';
import 'package:fam/presentation/bloc/card/card_bloc.dart';
import 'package:fam/presentation/bloc/card/card_event.dart';

class BigDisplayCard extends StatefulWidget {
  final CardItem card;
  const BigDisplayCard({super.key, required this.card});

  @override
  State<BigDisplayCard> createState() => _BigDisplayCardState();
}

class _BigDisplayCardState extends State<BigDisplayCard> {
  bool _isExpanded = true;
  bool _isHolding = false;

  void _handleLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isHolding = true;
      _isExpanded = false;
    });
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isHolding = false;
    });
  }

  void _handleTap() {
    if (!_isHolding) {
      setState(() {
        _isExpanded = true;
      });
    }
  }

  Future<void> _launchURL(String? url) async {
    if (url == null) return;
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  Widget _buildFormattedText(FormattedTextData formattedText) {
    final List<TextSpan> textSpans = [];
    final parts = formattedText.text.split('{}');
    int entityIndex = 0;

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        if (parts[i].trim() == "with action") {
          textSpans.add(TextSpan(
            text: parts[i],
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ));
        } else {
          textSpans.add(TextSpan(text: parts[i]));
        }
      }
      if (entityIndex < formattedText.entities.length) {
        if (entityIndex % 1 == 0) {
          textSpans.add(const TextSpan(text: '\n'));
        }
        final entity = formattedText.entities[entityIndex];
        textSpans.add(
          TextSpan(
            text: entity.text,
            style: TextStyle(
              color: entity.color != null
                  ? Color(int.parse(entity.color!.replaceAll('#', '0xFF')))
                  : Colors.white,
              fontSize: entity.fontSize ?? 30,
              fontWeight: entity.fontFamily?.contains('semi_bold') == true
                  ? FontWeight.w600
                  : FontWeight.normal,
              decoration: entity.fontStyle == 'underline'
                  ? TextDecoration.underline
                  : null,
              fontFamily: 'Metropolis',
            ),
          ),
        );
        entityIndex++;
      }
    }

    return RichText(
      textAlign:
          formattedText.align == 'center' ? TextAlign.center : TextAlign.left,
      text: TextSpan(children: textSpans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onLongPressStart: _handleLongPressStart,
        onLongPressEnd: _handleLongPressEnd,
        onTap: _handleTap,
        child: Stack(
          children: [
            AnimatedContainer(
              height: 368.h,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(
                _isExpanded ? 0 : 80.r,
                0,
                0,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF4A53B3),
                borderRadius: BorderRadius.circular(24),
                image: widget.card.bgImage != null
                    ? DecorationImage(
                        image: NetworkImage(widget.card.bgImage!),
                        fit: BoxFit.fill,
                      )
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.card.icon != null)
                      Image.network(
                        widget.card.icon!,
                        height: 48.h,
                        width: 48.w,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error_outline),
                      ),
                    SizedBox(height: 90.h),
                    if (widget.card.formattedTitle != null)
                      _buildFormattedText(widget.card.formattedTitle!)
                    else
                      Text(
                        widget.card.title,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    SizedBox(height: 20.h),
                    if (widget.card.cta != null)
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: GestureDetector(
                          onTap: () => _launchURL(widget.card.url),
                          child: Container(
                            width: 130.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            child: Center(
                              child: Text(
                                widget.card.cta!.first.text,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (!_isExpanded)
              Positioned(
                left: 20.w,
                top: 120.h,
                child: Column(
                  children: [
                    _buildIcon(Icons.notifications_rounded, 'remind later', () {
                      context.read<CardBloc>().add(
                            RemindLaterCard(widget.card.id),
                          );
                    }),
                    SizedBox(height: 20.h),
                    _buildIcon(Icons.close_sharp, 'dismiss now', () {
                      context.read<CardBloc>().add(
                            DismissCard(widget.card.id),
                          );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, String title, GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        height: 60.h,
        width: 65.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.amber),
            SizedBox(height: 5.h),
            Text(
              title,
              style: TextStyle(fontSize: 8.sp, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20.r, color: Colors.black87),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
