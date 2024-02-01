import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class NavigationController extends StatefulWidget {
  final Timer timer;
  final Position? curPosition;
  final void Function() startTimer;
  final void Function() setCameraLatLngBounds;

  const NavigationController({
    super.key,
    required this.timer,
    required this.curPosition,
    required this.startTimer,
    required this.setCameraLatLngBounds,
  });

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  bool isStopped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(46.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 36.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = min(constraints.maxHeight, constraints.maxWidth);
            return isStopped
                ? renderStopped(size)
                : renderNotStopped(
                    size: size,
                    setCameraLatLngBounds: widget.setCameraLatLngBounds,
                  );
          },
        ),
      ),
    );
  }

  Row renderNotStopped({
    required double size,
    required void Function() setCameraLatLngBounds,
  }) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.curPosition == null
                        ? '0.0'
                        : (widget.curPosition!.speed * 3.6).toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      fontFeatures: [FontFeature.tabularFigures()],
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
                    'km/h',
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
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                size: size,
                content: 'Stop!',
                ontap: () {
                  setState(() {
                    widget.timer.cancel();
                    isStopped = true;
                    setCameraLatLngBounds();
                  });
                },
              ),
            ],
          ),
        ),
        const Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
        ),
      ],
    );
  }

  Row renderStopped(double size) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                size: size,
                content: '끝내기',
                ontap: () {
                  context.go('/drivedone');
                },
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                size: size,
                content: '계속',
                ontap: () {
                  setState(() {
                    widget.startTimer();
                    isStopped = false;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
