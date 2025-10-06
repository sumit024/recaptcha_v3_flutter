import 'package:flutter/material.dart';
import 'package:recaptcha_v3_flutter/src/app_recaptcha_webview.dart';

class AppRecaptchaWidget extends StatelessWidget {
  final Function(String token) onTokenReceived;
  final Function()? onLoading;
  final Function(String message)? onError;

  const AppRecaptchaWidget({
    required this.onTokenReceived,
    this.onLoading,
    this.onError,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppReCaptchaWebView(
      onTokenReceived: onTokenReceived,
      onLoading: onLoading,
      onError: onError,
      width: double.maxFinite,
      height: 0,  // making it invisible (v3 is invisible)
    );
  }
}
