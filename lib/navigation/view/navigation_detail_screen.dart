import 'dart:async';
import 'dart:math';

import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/navigation/component/navigation_controller.dart';
import 'package:b612_project_team3/navigation/component/navigation_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationDetailScreen extends StatefulWidget {
  static String get routeName => 'navigation';

  const NavigationDetailScreen({super.key});

  @override
  State<NavigationDetailScreen> createState() => _NavigationDetailScreenState();
}

class _NavigationDetailScreenState extends State<NavigationDetailScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? googleMapController;
  StreamSubscription<Position>? positionStream;
  Position? curPosition;
  List<LatLng> polylineCoordinates = [];
  Timer? timer;
  int elapsedTime = 0;
  double totalTravelDistance = 0.0;
  late double minLat;
  late double maxLat;
  late double minLng;
  late double maxLng;
  late LatLngBounds latLngBounds;

  @override
  void initState() {
    super.initState();
    startPositionTracking();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }

    if (positionStream != null) {
      positionStream!.cancel();
    }

    if (googleMapController != null) {
      googleMapController!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: Colors.grey.shade700,
      child: Column(
        children: [
          Flexible(
            flex: 5,
            child: curPosition == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        curPosition!.latitude,
                        curPosition!.longitude,
                      ),
                      zoom: 16,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("tracking"),
                        points: polylineCoordinates,
                        color: Colors.red,
                        width: 6,
                      ),
                    },
                    myLocationEnabled: true,
                  ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: timer != null
                ? NavigationController(
                    timer: timer!,
                    curPosition: curPosition,
                    startTimer: startTimer,
                    setCameraLatLngBounds: setCameraLatLngBounds,
                  )
                : const SizedBox(),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 10,
              ),
              child: Center(
                child: timer != null
                    ? NavigationStatusBar(
                        totalTravelDistance: totalTravelDistance,
                        elapsedTime: elapsedTime,
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          ++elapsedTime;
        });
      },
    );
  }

  void startPositionTracking() async {
    try {
      curPosition = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 4),
      );
    } catch (e) {
      curPosition = await Geolocator.getLastKnownPosition();
    }
    minLat = maxLat = curPosition!.latitude;
    minLng = maxLng = curPosition!.longitude;
    latLngBounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    setState(() {});
    googleMapController = await _controller.future;

    startTimer();
    polylineCoordinates.add(
      LatLng(curPosition!.latitude, curPosition!.longitude),
    );
    positionStream = Geolocator.getPositionStream().listen(positionListener);
  }

  void positionListener(Position position) async {
    if (timer!.isActive) {
      totalTravelDistance += Geolocator.distanceBetween(
            curPosition!.latitude,
            curPosition!.longitude,
            position.latitude,
            position.longitude,
          ) /
          1000;
    }

    curPosition = position;

    minLat = min(minLat, curPosition!.latitude);
    maxLat = max(maxLat, curPosition!.latitude);
    minLng = min(minLng, curPosition!.longitude);
    maxLng = max(maxLng, curPosition!.longitude);

    latLngBounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    polylineCoordinates.add(
      LatLng(curPosition!.latitude, curPosition!.longitude),
    );

    if (timer!.isActive) {
      googleMapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            curPosition!.latitude,
            curPosition!.longitude,
          ),
        ),
      );
    } else {
      setCameraLatLngBounds();
    }

    setState(() {});
  }

  void setCameraLatLngBounds() {
    googleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(latLngBounds, 80),
    );
  }
}
