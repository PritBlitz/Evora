import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'pdf_viewer_screen.dart';

class TeamDetailScreen extends StatefulWidget {
  final String teamName;
  const TeamDetailScreen({super.key, required this.teamName});

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  Map<String, dynamic>? _teamData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTeamDetails();
  }

  Future<void> _fetchTeamDetails() async {
    final String url =
        'https://evora-production.up.railway.app/api/teams/${Uri.encodeComponent(widget.teamName)}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _teamData = json.decode(response.body)['team'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load team details';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateCertificate(String studentName) async {
    if (_teamData == null) return;

    final pdf = pw.Document();
    final String collegeName = _teamData!['collegeName'] ?? "Unknown College";
    final String eventName = "Evora Event";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 3),
            ),
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Event Logo Placeholder (Cup Icon)



                // Certificate Title
                pw.Text(
                  "Certificate of Participation",
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
                pw.Divider(thickness: 2, color: PdfColors.grey),
                pw.SizedBox(height: 20),

                // Certificate Content
                pw.Text("This is to certify that",
                    style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),
                pw.SizedBox(height: 10),

                pw.Text(studentName,
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue)),

                pw.SizedBox(height: 10),
                pw.Text("from $collegeName",
                    style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),

                pw.SizedBox(height: 10),
                pw.Text("has successfully participated in",
                    style: pw.TextStyle(fontSize: 18, color: PdfColors.black)),

                pw.SizedBox(height: 10),
                pw.Text(eventName,
                    style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.deepOrange)),

                pw.SizedBox(height: 30),

                // Congratulations Text
                pw.Text("Congratulations!",
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green)),

                pw.SizedBox(height: 40),

                // Signatures Section with Names
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text("_____________",
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Shubham Krishna",
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Event Coordinator",
                            style: pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text("_____________",
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Tushar",
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Organizer",
                            style: pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    try {
      final output = await getExternalStorageDirectory();
      final file = File("${output!.path}/$studentName-certificate.pdf");
      await file.writeAsBytes(await pdf.save());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(pdfFile: file),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while generating the certificate')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.teamName,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        elevation: 4,
      ),
      body: _isLoading
          ? Center(child: Lottie.asset('assets/person.json', width: 200.w))
          : _errorMessage != null
          ? _buildErrorMessage()
          : _teamData == null
          ? _buildNotFoundMessage()
          : _buildTeamDetails(),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Text(
        _errorMessage!,
        style: TextStyle(
            color: Colors.red, fontSize: 16.sp, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNotFoundMessage() {
    return Center(
      child: Text(
        'Team not found',
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
    );
  }

  Widget _buildTeamDetails() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard("🏫 College: ${_teamData!['collegeName']}"),
          SizedBox(height: 15.h),
          Text("👥 Members:",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          SizedBox(height: 5.h),
          Expanded(child: _buildMemberList()),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
          color: Colors.grey[900], borderRadius: BorderRadius.circular(12.r)),
      child: Text(text,
          style: TextStyle(
              fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }

  Widget _buildMemberList() {
    return ListView.builder(
      itemCount: (_teamData!['members'] as List).length,
      itemBuilder: (context, index) {
        final member = _teamData!['members'][index];
        return Card(
          color: Colors.grey[850],
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 24.sp),
            ),
            title: Text(member['name'],
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.sp)),
            subtitle: Text(member['email'],
                style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
            trailing: ElevatedButton(
              onPressed: () => _generateCertificate(member['name']),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text("Generate Certificate",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}
