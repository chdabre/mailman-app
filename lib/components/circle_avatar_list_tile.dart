import 'package:flutter/material.dart';

class CircleAvatarListTile extends StatelessWidget {
  const CircleAvatarListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final Function()? onTap;
  final Widget title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      title: title,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary,),
      ),
    );
  }
}
