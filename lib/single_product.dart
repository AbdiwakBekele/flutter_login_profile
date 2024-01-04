import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SingleProduct extends StatelessWidget {
  final productName;
  final productDescription;
  final productPrice;
  final productImage;

  const SingleProduct({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Description'),
      ),
      body: Column(
        children: [
          Image.network(
            'http://flutter.omishtujoy.com/' + productImage,
            width: 100,
          ),
          Text("Product Name: $productName"),
          Text("Product Name: $productDescription"),
          Text("Product Name: $productPrice")
        ],
      ),
    );
  }
}
