import 'dart:math';

import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapNavigationScreen extends StatelessWidget {
  const GMapNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [
          Flexible(
            flex: 4,
            child: FutureBuilder(
              future: getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('에러 발생'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    ),
                    zoom: 16,
                  ),
                  myLocationEnabled: true,
                );
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = min(constraints.maxHeight, constraints.maxWidth);
                  return ActionButton(
                    ontap: () {
                      context.go('/navigation');
                    },
                    size: size,
                    content: 'Start!',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Position?> getCurrentLocation() async {
    Position? curPosition;
    try {
      curPosition = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 4),
      );
    } catch (e) {
      curPosition = await Geolocator.getLastKnownPosition();
    }
    return curPosition;
  }
}
