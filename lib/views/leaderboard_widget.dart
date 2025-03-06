import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {'name': 'Alice', 'score': 250, 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Bob', 'score': 230, 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Charlie', 'score': 210, 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'David', 'score': 190, 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Eve', 'score': 170, 'avatar': 'https://via.placeholder.com/150'},
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['avatar']),
              radius: 25.r,
            ),
            title: Text(
              user['name'],
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Score: ${user['score']}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            trailing: Icon(
              index == 0
                  ? FontAwesomeIcons.crown
                  : index == 1
                  ? FontAwesomeIcons.medal
                  : FontAwesomeIcons.trophy,
              color: index == 0
                  ? Colors.yellow
                  : index == 1
                  ? Colors.grey
                  : Colors.brown,
            ),
          ),
        );
      },
    );
  }
}
