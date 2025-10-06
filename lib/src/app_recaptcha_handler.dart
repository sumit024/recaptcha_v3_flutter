import 'package:recaptcha_v3_flutter/src/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppRecaptchaHandler {
  AppRecaptchaHandler._();

  static AppRecaptchaHandler? _instance;

  late WebViewController _controller;
  String? _siteKey;
  String? _captchaToken;

  String? get captchaToken => _captchaToken;

  static AppRecaptchaHandler get instance =>
      _instance ??= AppRecaptchaHandler._();

  /// Setups the data site key
  void setupSiteKey({required String dataSiteKey}) {
    _siteKey = dataSiteKey;
  }

  /// Updates the WebView controller
  void updateController({required WebViewController controller}) {
    _controller = controller;

    if (_siteKey != null) {
      // Only call readyCaptcha when siteKey is set
      _controller.runJavaScript(
        '${AppConstants.readyCaptcha}("$_siteKey", "submit")',
      );
    }
  }

  /// Updates the generated token
  void updateToken({required String generatedToken}) {
    _captchaToken = generatedToken;
  }

  /// Executes reCAPTCHA V3 with optional action
  static void executeV3({String action = 'submit'}) {
    if (instance._siteKey == null) {
      return;
    }

    instance._controller.runJavaScript(
      '${AppConstants.executeCaptcha}("${instance._siteKey}", "$action")',
    );
  }
}
