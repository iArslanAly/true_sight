class LoginExtrasCache {
  static bool _consumed = false;

  static bool consumeOnce() {
    if (_consumed) return false;
    _consumed = true;
    return true;
  }
}
