import 'dart:convert';
import 'dart:io';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:path_provider/path_provider.dart';

class AuthenticationProvider {
  bool isAuthorized;
  String errorMessage;

  AppUser user;

  AuthenticationProvider(this.isAuthorized,
      {this.errorMessage = "Unexpected Error"});

  AuthenticationProvider.fromJSON(Map json)
      : this.isAuthorized = json["authorized"],
        this.user = AppUser.fromJSON(json["user"]),
        this.errorMessage = "Unexpected Error";

  Map toJSON() => {
    "authorized": isAuthorized,
    "user": user.toJSON(),
  };

  static Future<AuthenticationProvider> autoLogin() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();

      String loginCredentialsFilePath = appDocDir.path + "/login-creds.json";

      File file = File(loginCredentialsFilePath);

      if (file.existsSync()) {
        String content = file.readAsStringSync();

        Map json = jsonDecode(content);
        return AuthenticationProvider.fromJSON(json);
      } else
        return AuthenticationProvider(false);
    } catch (e, s) {
      print("AuthenticationProvider: AutoLogin: UnexpectedError: $e: $s");
      return AuthenticationProvider(false);
    }
  }

  Future<void> cache() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();

      String loginCredentialsFilePath = appDocDir.path + "/login-creds.json";

      File file = File(loginCredentialsFilePath);

      file.writeAsStringSync(jsonEncode(this.toJSON()));

      return null;
    } catch (e, s) {
      print("AuthenticationProvider: Cache: UnexpectedError: $e: $s");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();

      String loginCredentialsFilePath = appDocDir.path + "/login-creds.json";

      File file = File(loginCredentialsFilePath);

      file.deleteSync();

      return null;
    } catch (e, s) {
      print("AuthenticationProvider: SignOut: UnexpectedError: $e: $s");
      return null;
    }
  }
}