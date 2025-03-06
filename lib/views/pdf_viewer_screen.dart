import 'package:flutter/material.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class PDFViewerScreen extends StatelessWidget {
  final File pdfFile;
  const PDFViewerScreen({super.key, required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Certificate Preview")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            OpenFile.open(pdfFile.path);
          },
          child: const Text("Download Certificate"),
        ),
      ),
    );
  }
}
