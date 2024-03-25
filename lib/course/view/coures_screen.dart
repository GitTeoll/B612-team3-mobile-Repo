import 'package:b612_project_team3/common/component/search_box.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>
    with AutomaticKeepAliveClientMixin<CourseScreen> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  double googleMapSize = 0.6;
  double minChildSize = 0.1;
  Position? currentPosition;
  bool isFullScreen = false;
  bool lock = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(listener);
    setCurrentPosition();
  }

  void listener() {
    if (_controller.size > 0.40001) {
      return;
    } else {
      setState(() {
        googleMapSize = 1.0 - _controller.size;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    _controller.dispose();
    super.dispose();
  }

  void setCurrentPosition() async {
    currentPosition = await getCurrentPosition();
    setState(() {});
  }

  Future<Position> getCurrentPosition() async {
    await Geolocator.getPositionStream().listen((_) {}).cancel();

    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (currentPosition == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SizedBox(
              height: constraints.maxHeight * (googleMapSize + 0.1),
              child: GoogleMap(
                padding: EdgeInsets.only(
                  top: constraints.maxHeight * 0.2,
                  bottom: isFullScreen ? 0 : constraints.maxHeight * 0.1,
                ),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentPosition!.latitude,
                    currentPosition!.longitude,
                  ),
                  zoom: 17,
                ),
                onTap: (_) {
                  if (isFullScreen) {
                    isFullScreen = false;
                  } else if (_controller.size < 0.10001) {
                    isFullScreen = true;
                  } else {
                    _controller.animateTo(
                      0.1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  }
                  setState(() {});
                },
                myLocationEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
            Positioned(
              top: constraints.maxHeight * 0.1,
              left: constraints.maxWidth * 0.1,
              child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: !isFullScreen,
                child: SizedBox(
                  width: constraints.maxWidth * 0.8,
                  child: SearchBox(
                    onFieldSubmitted: (content) {},
                  ),
                ),
              ),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: !isFullScreen,
              child: DraggableScrollableSheet(
                controller: _controller,
                initialChildSize: 0.4,
                minChildSize: minChildSize,
                maxChildSize: 0.8,
                snap: true,
                snapSizes: const [0.1, 0.4, 0.8],
                builder: (context, scrollController) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      color: Colors.white,
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverAppBar(
                          flexibleSpace: GestureDetector(
                            onVerticalDragUpdate: (details) async {
                              if (lock) {
                                return;
                              }
                              lock = true;
                              if (details.delta.dy < 0 &&
                                  _controller.size < 0.10001) {
                                await _controller.animateTo(
                                  0.4,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear,
                                );
                              } else if (details.delta.dy < 0 &&
                                  _controller.size < 0.40001) {
                                await _controller.animateTo(
                                  0.8,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear,
                                );
                              } else if (details.delta.dy > 0 &&
                                  _controller.size > 0.79990) {
                                await _controller.animateTo(
                                  0.4,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear,
                                );
                              } else if (details.delta.dy > 0 &&
                                  _controller.size > 0.39990) {
                                await _controller.animateTo(
                                  0.1,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear,
                                );
                              }
                            },
                            onVerticalDragEnd: (_) {
                              lock = false;
                            },
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          primary: false,
                          pinned: true,
                          elevation: 0.0,
                          scrolledUnderElevation: 0.0,
                          automaticallyImplyLeading: false,
                          toolbarHeight: 40,
                        ),
                        SliverList.separated(
                          itemBuilder: (context, index) {
                            return Container(
                              height: 40,
                              color: Colors.red,
                              child: Text('$index'),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16.0),
                          itemCount: 30,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
