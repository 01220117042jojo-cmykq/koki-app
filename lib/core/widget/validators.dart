class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value, {String? lastPassword}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter (A-Z)';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter (a-z)';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number (0-9)';
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character (e.g. !@#\$)';
    }

    if (value.contains(' ')) {
      return 'Password cannot contain spaces';
    }

    if (lastPassword != null && value == lastPassword) {
      return 'You cannot use the same old password';
    }

    return null;
  }
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    final cleanPhone = value.trim();

    final RegExp egyptPhoneRegex = RegExp(r'^01[0125][0-9]{8}$');

    if (!egyptPhoneRegex.hasMatch(cleanPhone)) {
      return 'Please enter a valid Egyptian phone number (e.g., 01012345678)';
    }

    return null;
  }
  static String? validateOptionalPhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final cleanPhone = value.trim();
    final RegExp egyptPhoneRegex = RegExp(r'^01[0125][0-9]{8}$');
    if (!egyptPhoneRegex.hasMatch(cleanPhone)) {
      return 'Please enter a valid Egyptian phone number';
    }
    return null;
  }
}
