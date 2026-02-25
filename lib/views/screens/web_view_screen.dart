import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/views/widgets/footer.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _loadingProgress = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _loadingProgress = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Industry Contacts'),
        centerTitle: true,
        backgroundColor: AppTheme.of(context).accent1,
        scrolledUnderElevation: 0,
        elevation: 0,
        bottom: _isLoading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: LinearProgressIndicator(
                  value: _loadingProgress / 100.0,
                  backgroundColor: AppTheme.of(context).primaryBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.of(context).primaryBackground,
                  ),
                ),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  Container(
                    color: AppTheme.of(context).primaryBackground,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.of(context).accent1,
                          ),
                          // const SizedBox(height: 16),
                          // Text(
                          //   'Loading...',
                          //   style: AppTheme.of(context).bodyMedium.copyWith(
                          //     color: AppTheme.of(context).accent1,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
