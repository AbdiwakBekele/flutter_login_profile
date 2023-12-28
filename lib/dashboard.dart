import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_login/products.dart';
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

  Future<void> createProduct() async {
    final url = Uri.parse(
        'http://192.168.1.28/projects/flutter_api_updated/create.php');

    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath('image', image!.path),
    );

    request.fields['product_name'] = product_name.text;
    request.fields['product_description'] = product_description.text;
    request.fields['product_price'] = product_price.text;

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      try {
        final Map<String, dynamic> data = json.decode(responseBody);

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
            Image.network(
              'http://192.168.1.28/projects/flutter_api_updated/images/1703767434Screenshot_20231227_094924_CBE Mobile Banking.jpg',
              width: 50,
            ),
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProductList();
                  },
                ));
              },
              child: Text("upload"),
            )),
          ],
        ),
      ),
    );
  }
}
