import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:funvas/funvas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jester Big Bass WebView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://jester-big-bass.online/jbb/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: LoaderFunvasContainer(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LoaderFunvasContainer extends StatelessWidget {
  const LoaderFunvasContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return FunvasContainer(
      funvas: LoaderFunvas(),
    );
  }
}

class LoaderFunvas extends Funvas {
  @override
  void u(double t) {
    final double size = x as double;
    final double center = size / 2;
    final int count = 8;
    for (var i = 0; i < count; i++) {
      final double angle = t * 2 + i * 2 * math.pi / count;
      final double radius = size * 0.35;
      final double xPos = center + radius * math.cos(angle);
      final double yPos = center + radius * math.sin(angle);
      final paint = Paint()
        ..color = Color.fromARGB(
          ((255 * ((i + 1) / count)).toInt()),
          33,
          150,
          243,
        );
      c.drawCircle(Offset(xPos, yPos), size * 0.08, paint);
    }
  }
}