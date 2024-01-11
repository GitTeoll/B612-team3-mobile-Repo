import 'package:flutter/material.dart';

class DrivingRecordsCard extends StatelessWidget {
  const DrivingRecordsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.36,
        height: MediaQuery.of(context).size.height * 0.265,
        //가장 외곽 container decoration 설정

        decoration: BoxDecoration(
          color: Colors.white,
          //container 굴곡률
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
          //container 입체 설정
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 0,
              blurRadius: 5.0,
              offset: const Offset(2, 10), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                //연두 원 설정
                Container(
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 186, 237, 140),
                      // borderRadius: BorderRadius.circular(15),
                      shape: BoxShape.circle),
                  //연두 원 안의 text 설정
                  // child: const Center(
                  //   child: Text(
                  //     "2.4km",
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  // ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            //지도가 들어갈 container 설정
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              width: MediaQuery.of(context).size.width * 0.32,
              height: MediaQuery.of(context).size.height * 0.11,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            //text data 설정
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                const Text('NULL DATA'),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                const Text('NULL DATA'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
