import '../../imports/imports.dart';

/// A wrapper widget that handles different icon libraries (Material IconData & HugeIcons).
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
  });

  /// The icon to display (can be [IconData] or [HugeIcons] icon format).
  final dynamic icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (icon is IconData) {
      return Icon(
        icon as IconData,
        size: size,
        color: color,
      );
    }

    return HugeIcon(
      icon: icon,
      size: size ?? 24.0,
      color: color ?? Theme.of(context).iconTheme.color ?? Colors.black,
    );
  }
}

