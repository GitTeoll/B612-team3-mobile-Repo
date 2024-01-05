import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 38, 0, 0),
        child: Container(
          color: Colors.grey,
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 1.0,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: const Column(
            children: [
              Row(
                children: [
                  Text(
                    "내정보",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 20),
                  Text("NULL DATA")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
