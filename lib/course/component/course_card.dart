import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16.0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.lightBlue.shade100,
        ),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              child: AbsorbPointer(
                absorbing: true,
                child: KakaoMap(
                  center: LatLng(37.550812, 126.925399),
                  currentLevel: 5,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.width / 2,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('전체거리 : ?'),
                      Text('난이도 : ?'),
                      Text('평균 소요시간 : ?'),
                      Text('좋아요 수 : ?'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
