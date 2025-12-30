/// Form validators for the Trip Planner app
class Validators {
  Validators._();

  /// Validate if a field is not empty
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    return null;
  }

  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate password strength
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Validate strong password (includes uppercase, lowercase, number, special char)
  static String? strongPassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Validate password confirmation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate phone number
  static String? phoneNumber(String? value, {int minLength = 10, int maxLength = 15}) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^[+]?[\d\s-]+$');
    final digitsOnly = value.replaceAll(RegExp(r'[\s-]'), '');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    if (digitsOnly.length < minLength || digitsOnly.length > maxLength) {
      return 'Phone number must be between $minLength and $maxLength digits';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.length < length) {
      return fieldName != null 
          ? '$fieldName must be at least $length characters'
          : 'Must be at least $length characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int length, {String? fieldName}) {
    if (value != null && value.length > length) {
      return fieldName != null 
          ? '$fieldName must be at most $length characters'
          : 'Must be at most $length characters';
    }
    return null;
  }

  /// Validate length range
  static String? lengthRange(String? value, int min, int max, {String? fieldName}) {
    if (value == null || value.length < min || value.length > max) {
      return fieldName != null 
          ? '$fieldName must be between $min and $max characters'
          : 'Must be between $min and $max characters';
    }
    return null;
  }

  /// Validate numeric input
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return fieldName != null ? '$fieldName must be a number' : 'Please enter a valid number';
    }
    return null;
  }

  /// Validate URL format
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is optional
    }
    
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validate date is not in the past
  static String? futureDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }
    if (value.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }
    return null;
  }

  /// Validate date range
  static String? dateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'Please select both dates';
    }
    if (endDate.isBefore(startDate)) {
      return 'End date must be after start date';
    }
    return null;
  }

  /// Validate name (only letters and spaces)
  static String? name(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'Name is required';
    }
    
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    
    if (!nameRegex.hasMatch(value.trim())) {
      return fieldName != null 
          ? '$fieldName can only contain letters, spaces, hyphens, and apostrophes'
          : 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
