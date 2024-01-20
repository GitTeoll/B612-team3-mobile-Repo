import 'dart:async';
import 'dart:math';

import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
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
  late DateTime startTime;
  late Timer timer;
  int elapsedTime = 0;
  double totalTravelDistance = 0.0;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    startTimer();
    getCurrentLocation();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          ++elapsedTime;
        });
      },
    );
  }

  void getCurrentLocation() async {
    curPosition = await Geolocator.getLastKnownPosition();
    curPosition ??= await Geolocator.getCurrentPosition();
    setState(() {});
    googleMapController = await _controller.future;

    positionStream = Geolocator.getPositionStream().listen(positionListener);
  }

  void positionListener(Position position) async {
    totalTravelDistance += Geolocator.distanceBetween(
      curPosition!.latitude,
      curPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    curPosition = position;

    polylineCoordinates.add(
      LatLng(curPosition!.latitude, curPosition!.longitude),
    );

    googleMapController!.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          curPosition!.latitude,
          curPosition!.longitude,
        ),
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
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
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(46.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size =
                        min(constraints.maxHeight, constraints.maxWidth);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              curPosition == null
                                  ? '0.0'
                                  : curPosition!.speed.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'speed',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'm/s',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        ActionButton(
                          size: size,
                          content: 'Stop!',
                          ontap: () {
                            context.pop();
                          },
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SOS',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 8,
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              totalTravelDistance.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'm',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              elapsedTime.toString(),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'sec',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '125',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'bpm',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
