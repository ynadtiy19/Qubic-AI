import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qubic_ai/core/utils/constants/colors.dart';
import 'package:qubic_ai/core/utils/extensions/extensions.dart';

import '../../../core/utils/helper/regexp_methods.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.searchController,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController searchController;
  final Function(String) onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return BounceIn(
      child: ColoredBox(
        color: ColorManager.dark,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                autocorrect: true,
                textInputAction: TextInputAction.search,
                textAlignVertical: TextAlignVertical.center,
                controller: searchController,
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontSize: 15.spMin),
                textDirection:
                    RegExpManager.getTextDirection(searchController.text),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  hintText: 'Search chat history',
                ),
                onChanged: onChanged,
              ),
            ),
            IconButton(
              icon: Icon(
                  searchController.text.isEmpty ? Icons.search : Icons.close),
              color: ColorManager.grey,
              onPressed: onClear,
            ),
          ],
        ),
      ).withAllPadding(4),
    );
  }
}
