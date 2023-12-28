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
  TextEditingController product_price = TextEditingController();

  ImagePicker picker = new ImagePicker();
  XFile? image;

  Future<void> uploadImage(File selectedImage) async {
    final url = Uri.parse(
        'http://192.168.1.25/projects/flutter_api_updated/upload_photo.php');

    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath('image', selectedImage.path),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print("Image uploaded successfully");
      } else {
        print("Error uploading image");
      }
    } catch (error) {
      print("Error uploading image: $error");
    }
  }

  Future<void> createProduct() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.25/projects/flutter_api_updated/create.php'),
      body: {
        'product_name': product_name.text,
        'product_description': product_description.text,
        'product_price': product_price.text,
      },
    );

    if (response.body.isNotEmpty) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] != null && data['success']) {
          print('Product Registered successful');
        } else {
          print('Product Registration Failed');
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Empty response body');
    }
  }

  // From Gallery
  Future<void> pickImageGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedImage;
    });
  }

  // // From Camera
  Future<void> pickImageCamera() async {
    final pickedImageCamera =
        await picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = pickedImageCamera;
    });
  }

  void showImageOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          content: Container(
            height: 200,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text("Gallary"),
                  onTap: () {
                    pickImageGallery();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Camera"),
                  onTap: () {
                    pickImageCamera();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2)),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          (image != null) ? FileImage(File(image!.path)) : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: 25,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showImageOption(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            TextField(
              controller: product_name,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: product_description,
              decoration: InputDecoration(labelText: 'Product Descripton'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: product_price,
              decoration: InputDecoration(labelText: 'Product Price'),
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
      ),
    );
  }
}
