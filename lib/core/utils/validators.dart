class Validators {
  Validators._();

  static String? phone(String? val) {
    if (val == null || val.isEmpty) return 'Phone number is required';
    if (val.length != 10) return 'Enter a valid 10-digit mobile number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(val)) return 'Enter a valid Indian mobile number';
    return null;
  }

  static String? otp(String? val) {
    if (val == null || val.length != 6) return 'Enter the 6-digit OTP';
    return null;
  }

  static String? required(String? val, [String field = 'This field']) {
    if (val == null || val.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? minLength(String? val, int min, [String field = 'This field']) {
    if (val == null || val.trim().length < min) return '$field must be at least $min characters';
    return null;
  }

  static String? email(String? val) {
    if (val == null || val.isEmpty) return null; // optional
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return 'Enter a valid email';
    return null;
  }
}
