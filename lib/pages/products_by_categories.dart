import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/product.dart';
import 'package:woocommerce_app/provider/products_provider.dart';
import 'package:woocommerce_app/widgets/widget_product_card.dart';
import 'package:woocommerce_app/models/category.dart';

import '../api_service.dart';
import 'base_page.dart';

class ProductPageCat extends BasePage {
  ProductPageCat({Key key, this.cat, this.categoryId, this.tagsId})
      : super(key: key);

  String cat;

  int categoryId;
  int tagsId;

  @override
  _ProductPageCatState createState() => _ProductPageCatState();
}

class _ProductPageCatState extends BasePageState<ProductPageCat> {
  APIService apiService;
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool isLoading = false;
  final _searchQuery = new TextEditingController();
  Timer _debounce;

  final _sortByOptions = [
    SortBy("popularity", "Populaire", "asc"),
    SortBy("modified", "Récent", "asc"),
    SortBy("price", "Prix Décroissant", "desc"),
    SortBy("price", "Prix Croissant", "asc"),
  ];

  @override
  void initState() {
    super.initState();
    var productsList = Provider.of<ProductsProvider>(context, listen: false);
    productsList.resetStreams();
    productsList.setLoadingState(LoadMoreStatus.INITIAL);
    productsList.fetchProducts(
      _page,
      categoryId: this.widget.categoryId.toString(),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productsList.setLoadingState(LoadMoreStatus.LOADING);
        productsList.fetchProducts(
          ++_page,
          categoryId: this.widget.categoryId.toString(),
        );
      }
    });

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
        SizedBox(
          height: 20,
        ),
        Flexible(child: _productsList()),
      ],
    );
  }

  //https://cybdom.tech/flutter-tutorial-flutter-job-portal-part-1-ui-design/
  Widget _productsList() {
    return new Consumer<ProductsProvider>(
      builder: (context, productsModel, child) {
        if (productsModel.allProducts != null &&
            productsModel.allProducts.length > 0 &&
            productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
          return Column(
            children: [
              Text(
                this.widget.cat,
                style: new TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10.0),
                  children: productsModel.allProducts.map((Product item) {
                    return ProductCard(data: item);
                  }).toList(),
                ),
              ),
              Visibility(
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 35.0,
                  width: 35,
                  child: CircularProgressIndicator(),
                ),
                visible:
                    productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING,
              )
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
