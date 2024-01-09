import 'package:b612_project_team3/course/component/course_card.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: 0,
        itemBuilder: (context, index) {
          return const CourseCard();
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 24.0);
        },
        itemCount: 20,
      ),
    );
  }
}
