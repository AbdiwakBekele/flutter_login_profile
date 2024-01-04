import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_login/single_product.dart';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String productName;
  final String productDescription;
  final String productPrice;
  final String productImage;

  Product({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImage,
  });

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
      id: data['id'].toString(),
      productName: data['product_name'],
      productDescription: data['product_description'],
      productPrice: data['product_price'],
      productImage: data['product_image'],
    );
  }
}

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    final response = await http.get(
      Uri.parse('http://flutter.omishtujoy.com/read_products.php'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        productList = jsonData.map((data) => Product.fromJson(data)).toList();
      });
    } else {
      // Handle error
      print('Failed to load data. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final Product product = productList[index];
          return ListTile(
            title: Text(product.productName),
            subtitle: Text(product.productDescription),
            trailing: Text(product.productPrice),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'http://flutter.omishtujoy.com/' + product.productImage),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SingleProduct(
                        productName: product.productName,
                        productDescription: product.productDescription,
                        productPrice: product.productPrice,
                        productImage: product.productImage);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
