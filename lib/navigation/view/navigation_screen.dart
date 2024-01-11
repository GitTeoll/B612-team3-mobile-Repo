import 'dart:async';

import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class NavigationScreen extends StatefulWidget {
  static String get routeName => 'navigation';

  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late StreamSubscription<Position> positionStream;
  late KakaoMapController mapController;
  late LatLng latLng;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    positionStream.cancel();

    super.dispose();
  }

  void positionListener(Position position) {
    latLng = LatLng(position.latitude, position.longitude);

    mapController.setCenter(latLng);
    mapController.addMarker(
      markers: [
        Marker(
          markerId: latLng.toString(),
          latLng: latLng,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [
          Flexible(
            flex: 4,
            child: KakaoMap(
              onMapCreated: (controller) {
                mapController = controller;
                positionStream =
                    Geolocator.getPositionStream().listen(positionListener);
              },
            ),
          ),
          const Flexible(
            flex: 1,
            child: SizedBox(
              child: Center(
                child: Text(
                  'test',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
