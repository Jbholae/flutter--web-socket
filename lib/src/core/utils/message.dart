class Messages {
  Messages._();

  // Errors
  static const String severNotFoundError = "Couldn't connect to the server.";
  static const String noInternetError =
      "Oops! Your internet is gone. Please check your internet connection";
  static const String timeoutError = "Request timeout";
  static const String genericError = "Something went wrong, please try again";
  static const String badFormatError = "Internal server error";
  static const String unAuthorizedError = "Unauthorized";

  // Success messages
  static const String profileUpdateSuccess = "Profile updated successfully";

  // Question messages
  static const String foundQuoteFormDataQuestion =
      "Previous details have not yet been completed, do you want to continue or create a new request?";
}
