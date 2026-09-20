import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/promo_banner_model.dart';

class PromoBannerRow extends StatelessWidget {
  const PromoBannerRow({super.key, required this.items});

  final List<PromoBannerItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => _PromoChip(item: items[index]),
      ),
    );
  }
}

class _PromoChip extends StatelessWidget {
  const _PromoChip({required this.item});

  final PromoBannerItem item;

  @override
  Widget build(BuildContext context) {
    const foreground = Color(0xFF050505);

    return Material(
      color: item.filled ? const Color(0xFFE0E0E0) : const Color(0xFFE0E0E0),
      shape: const StadiumBorder(side: BorderSide(color: Color(0xFFDDD8D8))),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.isNew) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 88, 119, 245),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(item.icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(
                item.label.toUpperCase(),
                style: GoogleFonts.oswald(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
