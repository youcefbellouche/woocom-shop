import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/country.dart';

import '../api_service.dart';

class MastersProvider with ChangeNotifier {
  APIService _apiService;
  List<Country> _countryList;
  Country _selectedCountry;
  States _selectedState;

  List<Country> get allCountries => _countryList;
  Country get selectedCountry => _selectedCountry;
  States get selectedState => _selectedState;

  MastersProvider() {
    _apiService = new APIService();
  }

  resetStreams() {
    _countryList = new List<Country>();
    _selectedCountry = null;
    _selectedState = null;
  }

  fetchCountries() async {
    List<Country> itemModel = await _apiService.getCountries();

    if (itemModel.length > 0) {
      _countryList.addAll(itemModel);
    }

    notifyListeners();
  }

  fetchAllMasters() async {
    await fetchCountries();
  }

  setSelectedCountry(Country country) {
    this._selectedCountry = country;
    notifyListeners();
  }

  setSelectedState(States state) {
    this._selectedState = state;
    notifyListeners();
  }
}
