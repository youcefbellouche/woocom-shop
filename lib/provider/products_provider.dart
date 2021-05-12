import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/product.dart';

import '../api_service.dart';

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

class ProductsProvider with ChangeNotifier {
  APIService _apiService;
  List<Product> _productsList;
  SortBy _sortBy;

  int totalPages = 0;
  int pageSize = 100;

  List<Product> get allProducts => _productsList;
  double get totalRecords => _productsList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductsProvider() {
    resetStreams();
   _sortBy = SortBy("modified", "Latest", "asc");
  }

  void resetStreams() {
    _apiService = APIService();
    _productsList = List<Product>();
  }

  fetchProducts(
    pageNumber, {
    String strSearch,
    String tagName,
    String categoryId,
    String sortBy,
    String sortOrder = "asc",
  }) async {
    List<Product> itemModel = await _apiService.getProducts(
      strSearch: strSearch,
      pageNumber: pageNumber,
      pageSize: this.pageSize,
      tagName: tagName,
      categoryId: categoryId,
      sortBy: this._sortBy.value,
      sortOrder: this._sortBy.sortOrder,
    );

    if (itemModel.length > 0) {
      _productsList.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;    
  }

  setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }
}
