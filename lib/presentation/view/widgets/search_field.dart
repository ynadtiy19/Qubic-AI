import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qubic_ai/core/utils/constants/colors.dart';
import 'package:qubic_ai/core/utils/extension/extension.dart';

import '../../../core/utils/helper/regexp_methods.dart';
import '../../viewmodel/search/search_bloc.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.searchController,
    required this.searchBloc,
  });

  final TextEditingController searchController;
  final SearchBloc searchBloc;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce;
  bool _isSearching = false;
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BounceIn(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: ColoredBox(
          color: ColorManager.dark,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autocorrect: true,
                  textInputAction: TextInputAction.search,
                  textAlignVertical: TextAlignVertical.center,
                  controller: widget.searchController,
                  style: context.textTheme.bodyMedium,
                  textDirection: RegExpManager.getTextDirection(
                      widget.searchController.text),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    hintText: 'Search chat history',
                  ),
                  onChanged: _handleSearchChange,
                ),
              ),
              IconButton(
                icon: Icon(!_isSearching ? Icons.search : Icons.close),
                color: ColorManager.grey,
                onPressed: () {
                  _isSearching = false;
                  widget.searchController.clear();
                  widget.searchBloc.add(SearchQueryChanged(''));
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSearchChange(String value) {
    if (value.trim().isEmpty || value.trim().length <= 1) {
      _isSearching = value.trim().isNotEmpty;
      setState(() {});
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.searchController.text.trim() == value.trim()) {
        widget.searchBloc.add(SearchQueryChanged(value));
      }
    });
  }
}
