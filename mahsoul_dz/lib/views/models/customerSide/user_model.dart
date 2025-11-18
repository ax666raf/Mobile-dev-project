class User {
  String? fullName;
  String? email;
  String? password;
  String? confirmPassword;
  bool agreeToTerms;
  bool subscribeToUpdates;

  User({
    this.fullName,
    this.email,
    this.password,
    this.confirmPassword,
    this.agreeToTerms = false,
    this.subscribeToUpdates = false,
  });
}