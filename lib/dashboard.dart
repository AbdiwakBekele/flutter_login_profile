import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController product_name = TextEditingController();
  TextEditingController product_description = TextEditingController();

  Future<void> uploadImage(File selectedImage) async {
    final url = Uri.parse(
        'http://192.168.1.18/projects/flutter_api_updated/upload_photo.php');

    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath('image', selectedImage.path),
    );

    request.headers['Content-Type'] = 'multipart/form-data';

    final response = await request.send();

    if (response.statusCode == 200) {
      print("Image uploaded successfully");
    } else {
      print("Error, Uploading");
    }
  }

  Future<void> createProduct() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.18/projects/flutter_api_updated/create.php'),
      body: {
        'product_name': product_name.text,
        'product_description': product_description.text,
      },
    );

    final Map<String, dynamic> data = json.decode(response.body);

    if (data['success']) {
      print('Product Registered successful');
    } else {
      print('Product Registrationg Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: product_name,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: product_description,
            decoration: InputDecoration(labelText: 'Product Descripton'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: createProduct,
            child: Text('Create Product'),
          ),
          Center(
              child: ElevatedButton(
            onPressed: () async {
              final ImagePicker imagePicker = ImagePicker();
              final XFile? image =
                  await imagePicker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                uploadImage(File(image.path));
              }
            },
            child: Text("upload"),
          )),
        ],
      ),
    );
  }
}
