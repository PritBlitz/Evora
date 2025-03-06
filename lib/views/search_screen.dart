import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'TeamDetailScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _teams = [];
  bool _isLoading = false;

  Future<void> _searchTeams() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final String collegeName = Uri.encodeComponent(_controller.text);
    final String url =
        'https://evora-production.up.railway.app/api/teams/college/$collegeName';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _teams = data['teams'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _teams = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _teams = [];
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _teams = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.r,
                  )
                ],
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (value) => _searchTeams(),
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                  hintText: "Search for teams...",
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 16.sp),
                  prefixIcon: Icon(Icons.search, color: Colors.white, size: 24.sp),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : Expanded(
              child: _teams.isEmpty
                  ? Center(
                child: Text(
                  "No teams found",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70),
                ),
              )
                  : ListView.builder(
                itemCount: _teams.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamDetailScreen(
                              teamName: _teams[index]['teamName']),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10.r,
                            offset: Offset(0, 5.h),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _teams[index]['teamName'],
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            _teams[index]['collegeName'],
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
