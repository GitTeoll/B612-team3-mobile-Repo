import 'dart:math';

import 'package:b612_project_team3/common/const/data.dart';
import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:b612_project_team3/team/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapNavigationScreen extends ConsumerWidget {
  const GMapNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamName = ref.watch(selectedTeamProvider);

    return DefaultLayout(
      child: FutureBuilder(
        future: getCurrentPosition(),
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

          return Column(
            children: [
              Flexible(
                flex: 4,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    ),
                    zoom: 16,
                  ),
                  myLocationEnabled: true,
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                '현재 팀 : ${teamName == SOLO ? '솔로 라이딩' : teamName}',
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final resp =
                                          await context.push('/selectteam');

                                      if (resp is String) {
                                        ref
                                            .read(selectedTeamProvider.notifier)
                                            .state = resp;
                                      }
                                    },
                                    child: const Text('팀 선택'),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .read(selectedTeamProvider.notifier)
                                          .state = SOLO;
                                    },
                                    child: const Text('솔로 라이딩'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ActionButton(
                            ontap: () {
                              context.go('/navigation');
                            },
                            size: size,
                            content: 'Start!',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Position> getCurrentPosition() async {
    await Geolocator.getPositionStream().listen((_) {}).cancel();

    return Geolocator.getCurrentPosition();
  }
}
