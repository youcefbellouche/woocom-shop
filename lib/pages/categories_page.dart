import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/category.dart';
import 'package:woocommerce_app/models/product.dart';
import 'package:woocommerce_app/provider/products_provider.dart';
import 'package:woocommerce_app/widgets/widget_categories_card.dart';
import 'package:woocommerce_app/widgets/widget_product_card.dart';

import '../api_service.dart';
import 'base_page.dart';

class CategoriesPage extends BasePage {
  CategoriesPage({Key key, this.data}) : super(key: key);

  Future<List<Category>> data;

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends BasePageState<CategoriesPage> {
  APIService apiService;
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool isLoading = false;
  final _searchQuery = new TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    super.initState();

    _searchQuery.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    var productsList = Provider.of<ProductsProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        productsList.resetStreams();
        productsList.setLoadingState(LoadMoreStatus.INITIAL);
        productsList.fetchProducts(_page, strSearch: _searchQuery.text);
      },
    );
  }

  @override
  Widget pageUI() {
    return Column(
      children: [
        Flexible(child: _categoriesList()),
      ],
    );
  }

  //https://cybdom.tech/flutter-tutorial-flutter-job-portal-part-1-ui-design/
  Widget _categoriesList() {
    return FutureBuilder(
      future: this.widget.data,
      builder: (BuildContext context, AsyncSnapshot<List<Category>> model) {
        if (model.data != null && model.data.length > 0) {
          return Column(
            children: [
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10.0),
                  children: model.data.map((Category item) {
                    return CategoryCard(data: item);
                  }).toList(),
                ),
              ),
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
