import 'package:flutter/material.dart';
import '../widgets/driving_records.dart';
import '../widgets/recent_drive_widget.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const RecentDriveWidget(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Text(
              "Driving Records",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.28,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    const DrivingRecordsCard(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    const DrivingRecordsCard(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    const DrivingRecordsCard(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
