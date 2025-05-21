import 'package:flutter/material.dart';
import 'package:communication_practice/utils/theme.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final String hint;
  final TextEditingController? controller;
  final bool autofocus;
  
  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.hint = 'Search...',
    this.controller,
    this.autofocus = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  bool _showClearButton = false;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
  
  void _onTextChanged() {
    setState(() {
      _showClearButton = _controller.text.isNotEmpty;
    });
    widget.onChanged(_controller.text);
  }
  
  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: TextStyle(
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontSize: 14,
        ),
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
      ),
    );
  }
} 