import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/product.dart';
import 'package:woocommerce_app/provider/products_provider.dart';
import 'package:woocommerce_app/widgets/widget_product_card.dart';

import '../api_service.dart';
import 'base_page.dart';

class ProductPage extends BasePage {
  ProductPage({Key key, this.categoryId, this.tagsId}) : super(key: key);

  int categoryId;
  int tagsId;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
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
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productsList.setLoadingState(LoadMoreStatus.LOADING);
        productsList.fetchProducts(
          ++_page,
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
        _productFilters(),
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

  Widget _productFilters() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _searchQuery,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Chercher",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none),
                fillColor: Color(0xffe6e6ec),
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffe6e6ec),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: PopupMenuButton(
              onSelected: (sortBy) {
                var productsList =
                    Provider.of<ProductsProvider>(context, listen: false);

                productsList.resetStreams();
                productsList.setSortOrder(sortBy);
                productsList.fetchProducts(
                  _page,
                );
              },
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map((item) {
                  return PopupMenuItem(
                    value: item,
                    child: Container(
                      child: Text(item.text),
                    ),
                  );
                }).toList();
              },
              icon: Icon(Icons.tune),
            ),
          ),
        ],
      ),
    );
  }
}
