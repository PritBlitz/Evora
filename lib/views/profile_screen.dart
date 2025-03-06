import 'package:eventforge/views/leaderboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              Divider(height: 20.h),
              _buildSectionTitle('Leaderboard'),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.trophy, color: Colors.orange, size: 20.sp),
                title: Text('View Leaderboard', style: TextStyle(fontSize: 16.sp)),
                trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                  );
                },
              ),
              Divider(height: 20.h),
              _buildSectionTitle('Event-Related Information'),
              _buildListTile('Number of Events Organized', FontAwesomeIcons.listCheck),
              _buildListTile('Upcoming Events', FontAwesomeIcons.calendar),
              _buildListTile('Past Events Hosted', FontAwesomeIcons.history),
              _buildListTile('Total Participants Across Events', FontAwesomeIcons.users),
              _buildListTile('Event Creation Stats', FontAwesomeIcons.chartBar),
              _buildListTile('Events Attended', FontAwesomeIcons.ticket),
              _buildListTile('Upcoming Registered Events', FontAwesomeIcons.calendarCheck),
              _buildListTile('Total Events Participated', FontAwesomeIcons.trophy),
              _buildListTile('Badges & Achievements', FontAwesomeIcons.award),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: CircleAvatar(
            radius: 50.r,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'John Doe',
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          '@johndoe',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    return ListTile(
      leading: FaIcon(icon, color: Colors.blue, size: 20.sp),
      title: Text(title, style: TextStyle(fontSize: 16.sp)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
      onTap: () {},
    );
  }
}
