import 'package:b612_project_team3/common/const/colors.dart';
import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

class DriveDone extends StatelessWidget {
  static String get routeName => 'drivedone';

  const DriveDone({super.key});

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.grey),
    );
    String review = "";
    double rating = 3;

    return DefaultLayout(
      title: 'Your Ride',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 0,
                      blurRadius: 5.0,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 42.0,
                    horizontal: 24.0,
                  ),
                  child: Column(
                    children: [
                      const CustomContainer(content: '00:42:58'),
                      const SizedBox(height: 8.0),
                      const CustomContainer(content: '2.4km'),
                      const SizedBox(height: 50.0),
                      RatingBar(
                        glow: false,
                        minRating: 1,
                        initialRating: 3,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star,
                            color: PRIMARY_COLOR,
                          ),
                          half: const Icon(
                            Icons.star_half,
                            color: PRIMARY_COLOR,
                          ),
                          empty: const Icon(
                            Icons.star_outline,
                            color: PRIMARY_COLOR,
                          ),
                        ),
                        onRatingUpdate: (value) {
                          rating = value;
                        },
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: '후기',
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.all(16.0),
                          border: outlineInputBorder,
                          focusedBorder: outlineInputBorder,
                          enabledBorder: outlineInputBorder,
                        ),
                        maxLines: 4,
                        onChanged: (value) {
                          review = value;
                        },
                        onTapOutside: (_) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      ActionButton(
                        size: 100,
                        content: '등록',
                        ontap: () {
                          context.go('/');
                        },
                      ),
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

class CustomContainer extends StatelessWidget {
  final String content;

  const CustomContainer({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PRIMARY_COLOR,
        borderRadius: BorderRadius.circular(16.0),
      ),
      width: 160,
      child: Center(
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }
}
