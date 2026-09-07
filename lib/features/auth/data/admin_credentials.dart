abstract final class AdminCredentials {
  static const String email = 'mohitnegi699@gmail.com';
  static const String password = '123456789';
  static const String displayName = 'Mohit Negi';
  static const String initials = 'MN';

  static bool matches({required String email, required String password}) {
    return email.trim() == AdminCredentials.email &&
        password == AdminCredentials.password;
  }
}
