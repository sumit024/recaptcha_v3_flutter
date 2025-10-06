class AppConstants {
  AppConstants._();

  static final AppConstants _instance = AppConstants._();

  factory AppConstants() => _instance;

  static const String readyCaptcha = 'readyCaptcha';
  static const String executeCaptcha = 'executeCaptcha';
  static const String captchaJsChannelName = 'Captcha';
  static const String readyJsChannelName = 'Ready';
  static const String hostedRecaptchaDomain =
      'https://get-recaptcha-token.tiiny.site/';
}
