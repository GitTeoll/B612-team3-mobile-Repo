import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:daum_postcode_search/widget.dart';
import 'package:flutter/material.dart';

class AddressSearchingScreen extends StatefulWidget {
  const AddressSearchingScreen({super.key});

  @override
  State<AddressSearchingScreen> createState() => _AddressSearchingScreenState();
}

class _AddressSearchingScreenState extends State<AddressSearchingScreen> {
  bool _isError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    DaumPostcodeSearch daumPostcodeSearch = DaumPostcodeSearch(
      onConsoleMessage: (_, message) => print('주소찾기: $message'),
      onLoadError: (controller, uri, errorCode, message) => setState(
        () {
          _isError = true;
          errorMessage = message;
        },
      ),
      onLoadHttpError: (controller, uri, errorCode, message) => setState(
        () {
          _isError = true;
          errorMessage = message;
        },
      ),
    );

    return DefaultLayout(
      title: '주소 찾기',
      child: Column(
        children: [
          Expanded(
            child: daumPostcodeSearch,
          ),
          Visibility(
            visible: _isError,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(errorMessage ?? ""),
                ElevatedButton(
                  child: const Text("새로고침"),
                  onPressed: () {
                    daumPostcodeSearch.controller?.reload();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
