import 'package:flutter/material.dart';

class RecentDriveWidget extends StatelessWidget {
  const RecentDriveWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Container(
        //가장 외곽 container decoration 설정
        decoration: BoxDecoration(
          color: Colors.white,
          //외곽 굴곡률 설정
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
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
        height: MediaQuery.of(context).size.height * 0.44,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: Column(
          children: [
            const Row(
              children: [
                //"Recent Drive"
                Text(
                  "Recent Drive",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            //"Tect data"
            const Row(
              children: [
                Text("text data"),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            //지도가 들어갈 container 설정
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              // width: MediaQuery.of(context).size.width * 0.75,
            ),
            const SizedBox(
              height: 18,
            ),
            //연두 도형 설정
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //죄측부터 타원 1
                Container(
                  width: MediaQuery.of(context).size.width * 0.27,
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 186, 237, 140),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "00:42:58",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                //타원 2
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.04,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 186, 237, 140),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "2.4km",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                //원 3
                Container(
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 186, 237, 140),
                      // borderRadius: BorderRadius.circular(15),
                      shape: BoxShape.circle),
                  //원 내부 텍스트 설정
                  // child: const Center(
                  //     child: Text(
                  //       "2.4km",
                  //       style: TextStyle(fontSize: 20),
                  //     ),
                  //     ),
                ),
                //원 4 <원 3과 동일>
                Container(
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 186, 237, 140),
                      // borderRadius: BorderRadius.circular(15),
                      shape: BoxShape.circle),
                  child: const Center(
                      // child: Text(
                      //   "2.4km",
                      //   style: TextStyle(fontSize: 20),
                      // ),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
