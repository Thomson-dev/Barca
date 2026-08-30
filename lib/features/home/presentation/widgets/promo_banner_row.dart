import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../data/for_you_mock_data.dart';

/// Horizontally scrollable row of pill-shaped promo chips (Barça Play,
/// Third Kit, Summer Museum, ...).
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
    final foreground = item.filled ? Colors.white : Colors.black;

    return Material(
      color: item.filled ? Colors.black : Colors.white,
      shape: StadiumBorder(
        side: item.filled ? BorderSide.none : BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.isNew) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
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
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
