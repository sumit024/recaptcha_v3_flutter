import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:recaptcha_v3_flutter/recaptcha_v3_flutter.dart';

void main() {
  /// This is STEP 1
  /// Initialise your site key
  /// Call it in your main method
  AppRecaptchaHandler.instance.setupSiteKey(dataSiteKey: 'YOUR_SITE_KEY');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "recaptcha_v3_flutter",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppRecaptchaWidget(
            onTokenReceived: _onTokenReceived,
            onError: (error) {
              // display a toast message
            },
            onLoading: () {
              // show a loading indicator
            },
          ),
          ElevatedButton(
            onPressed: () {
              /// This is STEP 2
              /// Execute the Recaptcha V3  using this method call
              AppRecaptchaHandler.executeV3(action: 'login');
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              log(
                'Persisted Token ${AppRecaptchaHandler.instance.captchaToken}',
              );
            },
            child: const Text('Show Token'),
          ),
        ],
      ),
    );
  }

  /// STEP: 3
  /// After calling [AppRecaptchaHandler.executeV3()] you will receive the [token]
  /// Verify your Token using the server

  void _onTokenReceived(String token) {
    log("token: $token");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: SelectableText(token)),
        ),
        duration: const Duration(seconds: 10),
      ),
    );

    // verify token on server
    // send token to server
    // server will verify token

  }
}
