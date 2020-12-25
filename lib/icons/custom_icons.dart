import 'package:flutter/widgets.dart';

@immutable
class CustomIconsData extends IconData {
  const CustomIconsData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'CustomIcons',
        );
}

@immutable
class CustomIcons {
  CustomIcons._();

  // Generated code: do not hand-edit.
  static const IconData click = CustomIconsData(0xe000);

  static const IconData diamond = CustomIconsData(0xe001);

  static const IconData dollar = CustomIconsData(0xe002);

  static const IconData dumpling = CustomIconsData(0xe003);
}
