import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

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
                    "My team",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: TextButton(
                                        onPressed: () {
                                          context.go('/addnewteam');
                                          context.pop();
                                        },
                                        child: const Text('새 팀 만들기'),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: TextButton(
                                        onPressed: () {
                                          context.go('/searchteam');
                                          context.pop();
                                        },
                                        child: const Text('팀 찾기'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                height: 240,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset: const Offset(1, 5),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: 5,
                  viewportFraction: 0.333,
                  scale: -0.5,
                  pagination: const SwiperPagination(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
