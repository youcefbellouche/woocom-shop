import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/category.dart';
import 'package:woocommerce_app/models/product.dart';
import 'package:woocommerce_app/pages/product_details.dart';
import 'package:woocommerce_app/pages/products_by_categories.dart';

import '../config.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({Key key, this.data}) : super(key: key);

  Category data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPageCat(
              cat: data.categoryName,
              categoryId: data.categoryId,
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffE65829).withAlpha(40),
                  ),
                  Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/480px-No_image_available.svg.png",
                    height: 160,
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 5),
                Text(
                  data.categoryName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 14,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
