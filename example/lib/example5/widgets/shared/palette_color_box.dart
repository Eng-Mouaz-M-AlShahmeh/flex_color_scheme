import 'package:flutter/material.dart';

/// A Material widget used as a color indicator to show a color in the
/// TonalPalette.
@immutable
class PaletteColorBox extends StatelessWidget {
  /// Default const constructor for the color indicator.
  const PaletteColorBox(
      {Key? key,
      this.onTap,
      this.color = Colors.blue,
      this.height = 40,
      this.child})
      : assert(height > 0, 'Height must be positive.'),
        super(key: key);

  /// Optional void callback, called when the color indicator is tapped.
  ///
  /// To disable selection and ink effect, omit or assign a null callback.
  final VoidCallback? onTap;

  /// The background color of the color indicator.
  ///
  /// Defaults to [Colors.blue].
  final Color color;

  /// Height of the color indicator.
  ///
  /// Defaults to 40.
  final double height;

  /// Child widget to draw in the color indicator
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final bool isLight =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light;

    return Material(
      type: MaterialType.canvas,
      color: color,
      clipBehavior: Clip.none,
      child: SizedBox(
        height: height,
        child: InkWell(
          focusColor: isLight ? Colors.black26 : Colors.white30,
          hoverColor: isLight ? Colors.black26 : Colors.white30,
          onTap: onTap?.call,
          child: child,
        ),
      ),
    );
  }
}
