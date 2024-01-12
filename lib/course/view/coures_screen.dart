import 'package:b612_project_team3/common/component/search_box.dart';
import 'package:b612_project_team3/course/component/course_card.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Let's ride a bike",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SearchBox(
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text(
                    '근처 주행 코스',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
            renderCourseBox(),
            const SizedBox(
              height: 16.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '인기있는 주행 코스',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            renderCourseBox(),
            const SizedBox(
              height: 16.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '~~ 코스',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            renderCourseBox(),
          ],
        ),
      ),
    );
  }

  SizedBox renderCourseBox() {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        cacheExtent: 0,
        itemBuilder: (context, index) {
          return const CourseCard();
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 16.0);
        },
        itemCount: 10,
      ),
    );
  }
}
