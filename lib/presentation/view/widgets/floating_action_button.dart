import 'package:flutter/material.dart';

import '../../../core/utils/constants/colors.dart';

class BuildFloatingActionButton extends StatelessWidget {
  const BuildFloatingActionButton({super.key, this.onPressed, this.iconData});
  final void Function()? onPressed;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton.small(
        shape: const CircleBorder(),
        splashColor: ColorManager.white.withOpacity(0.3),
        elevation: 2,
        onPressed: onPressed,
        backgroundColor: ColorManager.purple,
        child: Icon(
          iconData ?? Icons.arrow_downward,
          color: ColorManager.white,
        ),
      ),
    );
  }
}
