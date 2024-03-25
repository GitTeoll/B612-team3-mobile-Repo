import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final String? hintText;
  final Function(String) onFieldSubmitted;
  final bool autofocus;

  const SearchBox({
    super.key,
    required this.onFieldSubmitted(String content),
    this.hintText,
    this.autofocus = false,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: TextFormField(
                  autofocus: widget.autofocus,
                  controller: controller,
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onFieldSubmitted: widget.onFieldSubmitted,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(decorationThickness: 0),
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? 'search',
                    hintStyle: const TextStyle(color: Colors.grey),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 4.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                widget.onFieldSubmitted(controller.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
