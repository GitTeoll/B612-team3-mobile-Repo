import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchBox({
    required this.onChanged,
    super.key,
  });

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
              child: TextFormField(
                onChanged: onChanged,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 4.0,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const Icon(Icons.search_rounded),
          ],
        ),
      ),
    );
  }
}
