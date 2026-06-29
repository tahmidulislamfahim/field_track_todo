import 'package:field_track_todo/features/nav_bar/controller/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.index,
    required this.label,
    required this.icon,
    required this.controller,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int index;
  final String label;
  final IconData icon;
  final NavBarController controller;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.changeIndex(index),
        child: Obx(() {
          final bool isSelected = controller.currentIndex.value == index;
          final color = isSelected ? activeColor : inactiveColor;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}