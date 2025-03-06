import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _rank1PrizeController = TextEditingController();
  final TextEditingController _rank2PrizeController = TextEditingController();
  final TextEditingController _rank3PrizeController = TextEditingController();
  final TextEditingController _teamSizeController = TextEditingController();

  bool _internship = false;
  File? _selectedImage;

  // Function to pick an image from Camera or Gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    Navigator.pop(context); // Close bottom sheet after selection
  }

  Future<void> _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse("https://powerful-art-production.up.railway.app/events");
      var request = http.MultipartRequest("POST", url);
      request.fields['eventName'] = _eventNameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['duration'] = _durationController.text;
      request.fields['eventDate'] = _eventDateController.text;
      request.fields['eventType'] = _eventTypeController.text;
      request.fields['internship'] = _internship.toString();
      request.fields['rank1Prize'] = _rank1PrizeController.text;
      request.fields['rank2Prize'] = _rank2PrizeController.text;
      request.fields['rank3Prize'] = _rank3PrizeController.text;
      request.fields['teamSize'] = _teamSizeController.text;

      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath('poster', _selectedImage!.path));
      }

      var response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event added successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add event")),
        );
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType type = TextInputType.text}) {
    return Card(
      elevation: 3,
      margin:  EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: TextFormField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) => value!.isEmpty ? 'Enter $label' : null,
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
              title: const Text("Take Photo"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.green),
              title: const Text("Choose from Gallery"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Event Name', _eventNameController, Icons.event),
                _buildTextField('Description', _descriptionController, Icons.description),
                _buildTextField('Duration', _durationController, Icons.timer),
                _buildTextField('Event Date', _eventDateController, Icons.date_range),
                _buildTextField('Event Type', _eventTypeController, Icons.category),
                _buildTextField('Rank 1 Prize', _rank1PrizeController, Icons.emoji_events),
                _buildTextField('Rank 2 Prize', _rank2PrizeController, Icons.emoji_events),
                _buildTextField('Rank 3 Prize', _rank3PrizeController, Icons.emoji_events),
                _buildTextField('Team Size', _teamSizeController, Icons.group, type: TextInputType.number),
                 SizedBox(height: 12.h),

                SwitchListTile(
                  title: const Text("Internship Available"),
                  value: _internship,
                  onChanged: (value) => setState(() => _internship = value),
                  secondary: const Icon(Icons.work),
                ),

                 SizedBox(height: 16.h),
                Center(
                  child: Column(
                    children: [
                      _selectedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_selectedImage!,
                            height: 150.h, width: 150.w, fit: BoxFit.cover),
                      )
                          : Container(
                          height: 150.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                            color: Colors.blue,
                          ),
                          child: const Center(
                              child: Text("No Image Selected", textAlign: TextAlign.center))),
                       SizedBox(height: 10.h),
                      ElevatedButton.icon(
                        onPressed: _showImagePickerOptions,
                        icon: const Icon(Icons.add_a_photo, color: Colors.white),
                        label: const Text("Select Image"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),

                 SizedBox(height: 16.h),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _submitEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    icon: const Icon(Icons.send, color: Colors.white),
                    label:  Text(
                      "Submit Event",
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),

                 SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
