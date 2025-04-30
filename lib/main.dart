import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Для корректной работы InAppWebView
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  pusWeb(url: 'https://jester-big-bass.online/jbb/',),
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
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri('https://jester-big-bass.online/jbb/'),
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
              ),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
            },
          ),
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

class pusWeb extends StatefulWidget {
  final String url; // URL, который нужно загрузить в WebView.

  pusWeb({required this.url}); // Конструктор для передачи URL.

  @override
  State<pusWeb> createState() => _pusWebState();
}

class _pusWebState extends State<pusWeb> {
  late InAppWebViewController _webViewController; // Контроллер WebView.
  double _progress = 0; // Прогресс загрузки страницы.

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          InAppWebView(
            initialSettings: InAppWebViewSettings(

              javaScriptEnabled: true, // Enable JavaScript
              javaScriptCanOpenWindowsAutomatically: true, // Allow JS to open new windows
            ),
            initialUrlRequest: URLRequest(url: WebUri(widget.url)), // URL для загрузки.
            onWebViewCreated: (controller) {
              _webViewController = controller; // Инициализация контроллера.
            },
            onLoadStart: (controller, url) {
              setState(() {
                _progress = 0; // При начале загрузки сбрасываем прогресс.
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _progress = 1; // Загрузка завершена.
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100; // Обновление прогресса загрузки.
              });
            },
          ),
          if (_progress < 1) // Показываем индикатор загрузки, пока страница не загрузится.
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}