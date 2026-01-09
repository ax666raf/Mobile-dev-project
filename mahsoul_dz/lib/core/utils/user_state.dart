/// Global state to track current user type for notification navigation
class UserState {
  static String? _currentUserType;
  
  static String? get currentUserType => _currentUserType;
  
  static void setUserType(String? userType) {
    _currentUserType = userType;
  }
  
  static void clear() {
    _currentUserType = null;
  }
}
