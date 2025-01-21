class FormValidator {
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validateOtp(String? otp) {
    if (otp == null || otp.trim().isEmpty) {
      return 'OTP cannot be empty';
    }
    if (otp.trim().length != 4) {
      return 'OTP must be 4 digits';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(otp.trim())) {
      return 'OTP must contain only numbers';
    }
    return null;
  }

  static String? validateDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return 'Description cannot be empty';
    }
    return null;
  }

  static String? validateLatitude(String? latitude) {
    if (latitude == null || latitude.trim().isEmpty) {
      return 'Latitude cannot be empty';
    }
    final lat = double.tryParse(latitude.trim());
    if (lat == null || lat < -90 || lat > 90) {
      return 'Enter a valid latitude';
    }
    return null;
  }

  static String? validateLongitude(String? longitude) {
    if (longitude == null || longitude.trim().isEmpty) {
      return 'Longitude cannot be empty';
    }
    final long = double.tryParse(longitude.trim());
    if (long == null || long < -180 || long > 180) {
      return 'Enter a valid longitude';
    }
    return null;
  }
}
