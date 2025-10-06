import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recaptcha_v3_flutter/recaptcha_v3_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppReCaptchaWebView extends StatefulWidget {
  const AppReCaptchaWebView({
    super.key,
    required this.width,
    required this.height,
    required this.onTokenReceived,
    this.onLoading,
    this.onError,
  });

  final double width, height;
  final Function(String token) onTokenReceived;
  final Function()? onLoading; // callback when loading
  final Function(String message)? onError; // callback when error

  @override
  State<AppReCaptchaWebView> createState() => _AppReCaptchaWebViewState();
}

class _AppReCaptchaWebViewState extends State<AppReCaptchaWebView> {
  late final WebViewController _webController;

  @override
  void initState() {
    super.initState();
    _webController = WebViewController();
    _setWebViewConfigs();
  }

  void _setWebViewConfigs() {
    _webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        AppConstants.readyJsChannelName,
        onMessageReceived: (JavaScriptMessage message) {},
      )
      ..addJavaScriptChannel(
        AppConstants.captchaJsChannelName,
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final data = json.decode(message.message);
            final status = data['status'];

            switch (status) {
              case 'loading':
                widget.onLoading?.call();
                break;
              case 'loaded':
                break;
              case 'success':
                final token = data['token'];
                if (token != null) {
                  widget.onTokenReceived(token);
                  AppRecaptchaHandler.instance.updateToken(
                    generatedToken: token,
                  );
                } else {
                  widget.onError?.call('Token missing in success response');
                }
                break;
              case 'error':
                final msg = data['message'] ?? 'Unknown error';
                widget.onError?.call(msg);
                break;
              default:
                widget.onError?.call('Unknown status: $status');
            }
          } catch (e) {
            widget.onError?.call('Invalid message from WebView: $e');
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            // Initialize ready JS only when page fully loads
            _initializeReadyJs(_webController);
          },
          onWebResourceError: (error) {
            widget.onError?.call(
              'Failed to load web page: ${error.description}',
            ); // Handle page load error
          },
        ),
      );

    // Load the HTML URL
    _webController.loadRequest(Uri.parse(AppConstants.hostedRecaptchaDomain));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: WebViewWidget(controller: _webController),
    );
  }

  void _initializeReadyJs(WebViewController controller) {
    AppRecaptchaHandler.instance.updateController(controller: controller);
  }
}
