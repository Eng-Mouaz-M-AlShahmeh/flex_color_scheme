import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../../../shared/controllers/theme_controller.dart';
import '../../../../shared/widgets/universal/switch_list_tile_adaptive.dart';
import 'surface_mode_buttons.dart';

// Panel used to define how primary color is blended into surfaces and
// onColors.
class SurfaceBlends extends StatelessWidget {
  const SurfaceBlends(
    this.controller, {
    super.key,
    required this.allBlends,
  });
  final ThemeController controller;
  final bool allBlends;

  String explainMode(final FlexSurfaceMode mode) {
    switch (mode) {
      case FlexSurfaceMode.level:
        return 'Flat blend\nAll surfaces at blend level 1x\n';
      case FlexSurfaceMode.highBackgroundLowScaffold:
        return 'High background, low scaffold\n'
            'Background 3/2x  Surface 1x  Scaffold 1/2x\n';
      case FlexSurfaceMode.highSurfaceLowScaffold:
        return 'High surface, low scaffold\n'
            'Surface 3/2x  Background 1x  Scaffold 1/2x\n';
      case FlexSurfaceMode.highScaffoldLowSurface:
        return 'High scaffold, low surface\n'
            'Scaffold 3x  Background 1x  Surface 1/2x\n';
      case FlexSurfaceMode.highScaffoldLevelSurface:
        return 'High scaffold, level surface\n'
            'Scaffold 3x  Background 2x  Surface 1x\n';
      case FlexSurfaceMode.levelSurfacesLowScaffold:
        return 'Level surfaces, low scaffold\n'
            'Surface & Background 1x  Scaffold 1/2x\n';
      case FlexSurfaceMode.highScaffoldLowSurfaces:
        return 'High scaffold, low surfaces (default)\n'
            'Scaffold 3x  Surface and Background 1/2x\n';
      case FlexSurfaceMode.levelSurfacesLowScaffoldVariantDialog:
        return 'Tertiary container dialog, low scaffold\n'
            'Surface & Background 1x  Scaffold 1/2x\n'
            'Dialog 1x blend of tertiary container color';
      case FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog:
        return 'High scaffold, tertiary container dialog\n'
            'Scaffold 3x  Surface and Background 1/2x\n'
            'Dialog 1/2x blend of tertiary container color';
      case FlexSurfaceMode.custom:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        const ListTile(
          title: Text('Blended surfaces and backgrounds'),
          isThreeLine: true,
          subtitle: Text(
            'Material Design 2 guide briefly mentions using surfaces with '
            'primary color alpha blends. FlexColorScheme surface blends '
            'implements it.\n'
            '\n'
            'Material Design 3 has a new color system where a hint of primary '
            'color is also used on surfaces. It is done via its neutral tonal '
            'palettes that are shifted slightly towards the primary color. '
            'If you use M3 seeded ColorSchemes and set blend level to zero, '
            'you get the M3 design. With surface blends, you can further '
            'strengthen the effect and vary blend levels by surface type.',
          ),
        ),
        if (isLight) ...<Widget>[
          ListTile(
            title: const Text('Light theme blend mode'),
            subtitle: Text(explainMode(controller.surfaceModeLight)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SurfaceModeButtons(
                mode: controller.surfaceModeLight,
                onChanged: controller.setSurfaceModeLight,
                showAllModes: allBlends,
              ),
              const SizedBox(width: 16),
            ],
          ),
          const ListTile(
            title: Text('Light theme blend level'),
            subtitle: Text('Adjust the surface, background, scaffold and '
                'dialog blend level. Also impacts surfaces when '
                'seed colors are used. Seed based surfaces already include '
                'a touch of primary, but you can make it stronger with '
                'surface blends'),
          ),
          ListTile(
            title: Slider.adaptive(
              min: 0,
              max: 40,
              divisions: 40,
              label: controller.blendLevel.toString(),
              value: controller.blendLevel.toDouble(),
              onChanged: (double value) {
                controller.setBlendLevel(value.toInt());
              },
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'LEVEL',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${controller.blendLevel}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            enabled: controller.useSubThemes && controller.useFlexColorScheme,
            title: const Text('Light theme onColors blend level'),
            subtitle: const Text('When seed colors are not used, this affects '
                'onContainers, onSurface and onBackground, plus main '
                'onColors when the onColor blending switch is ON'),
          ),
          ListTile(
            enabled: controller.useSubThemes && controller.useFlexColorScheme,
            title: Slider.adaptive(
              min: 0,
              max: 40,
              divisions: 40,
              label: controller.blendOnLevel.toString(),
              value: controller.useSubThemes && controller.useFlexColorScheme
                  ? controller.blendOnLevel.toDouble()
                  : 0,
              onChanged:
                  controller.useSubThemes && controller.useFlexColorScheme
                      ? (double value) {
                          controller.setBlendOnLevel(value.toInt());
                        }
                      : null,
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'LEVEL',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    // ignore: lines_longer_than_80_chars
                    '${controller.useSubThemes && controller.useFlexColorScheme ? controller.blendOnLevel : ""}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SwitchListTileAdaptive(
            title: const Text('Light theme main colors use onColor blending'),
            subtitle:
                const Text('In M3 design, only container colors use color '
                    'pair tinted onColor. Main colors use black or white. '
                    'Keep this OFF to do so. Set to ON to use it with '
                    'onPrimary, onSecondary, onTertiary and onError, when seed '
                    'colors are not used'),
            value: controller.blendLightOnColors &&
                controller.useSubThemes &&
                controller.useFlexColorScheme,
            onChanged: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.setBlendLightOnColors
                : null,
          ),
          SwitchListTileAdaptive(
            title: const Text('Plain white'),
            subtitle: const Text(
              'White Scaffold in all blend modes, '
              'other surfaces become 5% lighter',
            ),
            value: controller.lightIsWhite,
            onChanged: controller.setLightIsWhite,
          ),
        ] else ...<Widget>[
          ListTile(
            title: const Text('Dark theme blend mode'),
            subtitle: Text(explainMode(controller.surfaceModeDark)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SurfaceModeButtons(
                mode: controller.surfaceModeDark,
                onChanged: controller.setSurfaceModeDark,
                showAllModes: allBlends,
              ),
              const SizedBox(width: 16),
            ],
          ),
          const ListTile(
            title: Text('Dark theme blend level'),
            subtitle: Text('Adjust the surface, background, scaffold and '
                'dialog blend level. Also impacts surfaces when '
                'seed colors are used. Seed based surfaces already include '
                'a touch of primary, but you can make it stronger with '
                'surface blends'),
          ),
          ListTile(
            title: Slider.adaptive(
              min: 0,
              max: 40,
              divisions: 40,
              label: controller.blendLevelDark.toString(),
              value: controller.blendLevelDark.toDouble(),
              onChanged: (double value) {
                controller.setBlendLevelDark(value.toInt());
              },
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'LEVEL',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${controller.blendLevelDark}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            enabled: controller.useSubThemes && controller.useFlexColorScheme,
            title: const Text('Dark theme onColors blend level'),
            subtitle: const Text('When seed colors are not used, this affects '
                'onContainers, onSurface and onBackground, plus main '
                'onColors when the onColor blending switch is ON'),
          ),
          ListTile(
            enabled: controller.useSubThemes && controller.useFlexColorScheme,
            title: Slider.adaptive(
              min: 0,
              max: 40,
              divisions: 40,
              label: controller.blendOnLevelDark.toString(),
              value: controller.useSubThemes && controller.useFlexColorScheme
                  ? controller.blendOnLevelDark.toDouble()
                  : 0,
              onChanged:
                  controller.useSubThemes && controller.useFlexColorScheme
                      ? (double value) {
                          controller.setBlendOnLevelDark(value.toInt());
                        }
                      : null,
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'LEVEL',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    // ignore: lines_longer_than_80_chars
                    '${controller.useSubThemes && controller.useFlexColorScheme ? controller.blendOnLevelDark : ""}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SwitchListTileAdaptive(
            title: const Text('Dark theme main colors use onColor blending'),
            subtitle: const Text(
                'In M3 dark design, not only container colors use '
                'color pair tinted onColor, but also main colors do. '
                'Keep this ON to also use it with onPrimary, onSecondary, '
                'onTertiary and onError colors in dark mode, when seed colors '
                'are not used'),
            value: controller.blendDarkOnColors &&
                controller.useSubThemes &&
                controller.useFlexColorScheme,
            onChanged: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.setBlendDarkOnColors
                : null,
          ),
          SwitchListTileAdaptive(
            title: const Text('True black'),
            subtitle: const Text(
              'Black Scaffold in all blend modes, '
              'other surfaces become 5% darker',
            ),
            value: controller.darkIsTrueBlack,
            onChanged: controller.setDarkIsTrueBlack,
          ),
        ],
      ],
    );
  }
}
