extension StringExtension on String {
  bool get isValidName {
    // accepts only letters and spaces, and at least 2 characters
    final nameRegExp = RegExp(r"^[A-Za-z\s]{2,}$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidWeight {
    // accepts only numbers and at least 1 character
    final weightRegExp = RegExp(r"^[0-9]{1,}$");
    return weightRegExp.hasMatch(this);
  }

  bool get isValidPrice {
    // accepts only numbers and at least 1 character
    final priceRegExp = RegExp(r"^[0-9]{1,}$");
    return priceRegExp.hasMatch(this);
  }

  bool get isValidLocation {
    // accepts only letters and spaces, and at least 2 characters
    final locationRegExp = RegExp(r"^[A-Za-z\s]{2,}$");
    return locationRegExp.hasMatch(this);
  }
}



