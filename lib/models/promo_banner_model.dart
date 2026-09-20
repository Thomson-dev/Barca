import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

class PromoBannerItem {
  const PromoBannerItem({
    required this.icon,
    required this.label,
    this.isNew = false,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final bool isNew;
  final bool filled;
}

const mockPromoBanners = [
  PromoBannerItem(icon: Iconsax.play, label: 'Barça Play', filled: true),
  PromoBannerItem(icon: Iconsax.ticket, label: 'Next Matches'),
  PromoBannerItem(icon: Iconsax.bag, label: 'Third Kit', isNew: true),
  PromoBannerItem(icon: Iconsax.sun, label: 'Summer Museum'),
];
