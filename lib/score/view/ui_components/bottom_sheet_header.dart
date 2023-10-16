import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    required this.title,
    this.subTitle,
    super.key,
  });

  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28),
          ),
        ),
        if (subTitle != null) Text(subTitle!),
        const SizedBox(height: 8),
        const Divider(thickness: 2, height: 2),
      ],
    );
  }
}
