import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qubic_ai/core/utils/constants/colors.dart';
import 'package:qubic_ai/core/utils/extension/extension.dart';

import '../../viewmodel/search/search_bloc.dart';
import '../../viewmodel/validation/validation_cubit.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.searchController,
    required this.searchBloc,
    required this.validationCubit,
  });

  final TextEditingController searchController;
  final SearchBloc searchBloc;
  final ValidationCubit validationCubit;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: TextField(
        controller: widget.searchController,
        style: context.textTheme.bodyMedium,
        textDirection: widget.validationCubit
            .getTextDirection(widget.searchController.text),
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: true,
          filled: true,
          fillColor: ColorManager.dark,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          hintText: 'Search chat history',
          suffix: IconButton(
            icon: const Icon(Icons.search),
            color: ColorManager.grey,
            onPressed: () {},
          ),
        ),
        onChanged: _handleSearchChange,
      ),
    );
  }

  void _handleSearchChange(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.searchController.text.trim() == value.trim()) {
        widget.searchBloc.add(SearchQueryChanged(value));
      }
    });
  }
}
