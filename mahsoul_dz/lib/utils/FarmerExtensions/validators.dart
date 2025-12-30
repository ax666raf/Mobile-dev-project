import 'package:mahsoul_dz/utils/FarmerExtensions/extensions.dart';

class ProductValidators {
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!value.isValidName) {
      return 'Invalid name';
    }
    return null;
  }

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }
    if (!value.isValidWeight) {
      return 'Invalid weight';
    }
    return null;
  }
  String? validatePrice(String? value){
    if(value == null || value.isEmpty){
      return 'Price is required';
    }
    if(!value.isValidPrice){
      return 'Invalid price';
    }
    return null;
    }
    String? validateLocation(String? value){
      if(value == null || value.isEmpty){
        return 'Location is required';
      }
      if(!value.isValidLocation){
        return 'Invalid location';
      }
      return null;
    }
  }

