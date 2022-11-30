import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;

  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Ink(
            decoration: BoxDecoration(
              color: kButtonColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: Center(
                child: Icon(
                  icon,
                  size: 35.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      ],
    );
  }
}
