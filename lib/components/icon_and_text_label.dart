import 'package:flutter/material.dart';

class IconAndTextLabel extends StatelessWidget {
  const IconAndTextLabel({
    Key? key,
    required this.icon,
    required this.actionLabel,
    this.fontSize = 10,
  }) : super(key: key);

  final IconData icon;
  final String actionLabel;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(
          actionLabel.toUpperCase(),
          style: Theme.of(context).textTheme.button!.copyWith(
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
