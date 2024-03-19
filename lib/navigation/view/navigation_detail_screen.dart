import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/navigation/component/navigation_controller.dart';
import 'package:b612_project_team3/navigation/component/navigation_status_bar.dart';
import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:b612_project_team3/record/provider/current_record_model_provider.dart';
import 'package:b612_project_team3/record/provider/drive_done_record_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationDetailScreen extends ConsumerWidget {
  static String get routeName => 'navigation';

  final bool original;

  const NavigationDetailScreen({
    super.key,
    required this.original,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRecordModel = ref.watch(currentRecordModelProvider(original));
    final driveDoneRecordModel = ref.watch(driveDoneRecordModelProvider);
    final googleMapController = ref
        .watch(currentRecordModelProvider(original).notifier)
        .googleMapController;

    if (currentRecordModel is! CurrentRecordModel ||
        driveDoneRecordModel is DriveDoneRecordModel) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return DefaultLayout(
        backgroundColor: Colors.grey.shade700,
        title: '',
        appBarHeight: 0,
        child: Column(
          children: [
            Flexible(
              flex: 9,
              child: GoogleMap(
                onMapCreated: (controller) {
                  ref
                      .read(currentRecordModelProvider(original).notifier)
                      .startCameraTracking(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentRecordModel.curPosition.latitude,
                    currentRecordModel.curPosition.longitude,
                  ),
                  zoom: 17,
                  bearing: ref
                          .read(currentRecordModelProvider(original).notifier)
                          .initialBearing ??
                      0.0,
                ),
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("Tracking"),
                    points: currentRecordModel.polylineCoordinates,
                    color: Colors.red,
                    width: 6,
                  ),
                },
                markers: currentRecordModel.markers,
                myLocationEnabled: true,
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: googleMapController != null
                  ? NavigationController(
                      ref: ref,
                      currentRecordModel: currentRecordModel,
                      original: original,
                    )
                  : const SizedBox(),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 10,
                ),
                child: Center(
                  child: googleMapController != null
                      ? NavigationStatusBar(
                          currentRecordModel: currentRecordModel,
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
