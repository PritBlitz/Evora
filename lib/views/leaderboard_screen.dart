import 'package:eventforge/views/leaderboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Leaderboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          centerTitle: true,
        ),
        body: const LeaderboardWidget(),
      ),
    );
  }
}

