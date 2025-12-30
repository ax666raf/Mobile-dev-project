extension StringExtension on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    return length >= 6;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^0[2,3,5,6,7][0-9]{8}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^[A-Za-z\s]{2,}$");
    return nameRegExp.hasMatch(this);
  }

  // Accepts integers in the range 1..40 only
  bool get isValidExperience {
    final experienceRegExp = RegExp(r"^([1-9]|[1-3][0-9]|40)$");
    return experienceRegExp.hasMatch(trim());
  }
}



