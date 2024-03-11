import 'package:b612_project_team3/common/model/cursor_pagination_model.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class FavoriteTeamCard extends StatelessWidget {
  final CursorPagination<TeamModel> cp;
  final int favoriteCardCount;
  final void Function(int)? onTap;

  const FavoriteTeamCard({
    super.key,
    required this.cp,
    required this.favoriteCardCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Swiper(
        loop: false,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!(index);
              }
            },
            child: Container(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        cp.data[index].name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        cp.data[index].address,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  Text(
                    cp.data[index].kind == 'HOBBY' ? '취미반' : '전문반',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: favoriteCardCount,
        viewportFraction: 0.333,
        scale: -0.5,
        pagination: const SwiperPagination(),
      ),
    );
  }
}
