class AppAssets {
  AppAssets._();

  static const String _basePath = 'assets';
  static const String _iconsPath = '$_basePath/icons';
  static const String _animationPath = '$_basePath/animations';

  // SVGs
  static const String googleIcon = '$_iconsPath/google.svg';
  static const String facebookIcon = '$_iconsPath/facebook.svg';
  static const String appleIcon = '$_iconsPath/apple.svg';
  static const String squatAnimation = '$_animationPath/squat.json';
  static const String gymDumbbellAnimation = '$_animationPath/gymdubble.json';
  static const String scheduleAnimation =
      '$_animationPath/cancelledGymClass.json';

  // You can add more categories here as well, such as:
  // static const String _imagesPath = '$_basePath/images';
  // static const String logo = '$_imagesPath/logo.png';
}
