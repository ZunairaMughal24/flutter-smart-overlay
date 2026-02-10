import 'package:flutter/material.dart';
import 'package:smart_overlay/smart_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Overlay Demo',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _isLoggingIn = false;
  bool _isSyncing = false;

  void _handleSync() async {
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _isSyncing = false);
    }
  }

  void _handleLogin() async {
    setState(() => _isLoggingIn = true);

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _isLoggingIn = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged in successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Overlay Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DemoButton(
                label: 'Show Full Screen Loader',
                color: Colors.blue,
                onPressed: () async {
                  context.showLoader(message: 'Preparing your workspace...');
                  await Future.delayed(const Duration(seconds: 3));
                  if (context.mounted) {
                    context.hideOverlay();
                  }
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isLoggingIn ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoggingIn
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              ScallopedProgressIndicator(
                                size: 30,
                                strokeWidth: 2,
                                color: Colors.white,
                                waveCount: 8,
                              ),
                              SizedBox(width: 12),
                              Text('Logging in...'),
                            ],
                          )
                        : const Text(
                            'Login with Scalloped Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _isSyncing ? null : _handleSync,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _isSyncing
                            ? Colors.purple.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: _isSyncing
                          ? Colors.purple.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Premium Gradient Style',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            _isSyncing
                                ? 'Synchronizing data...'
                                : 'Tap to witness the magic',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: _isSyncing
                                  ? Colors.purple
                                  : Colors.grey.shade600,
                              fontWeight: _isSyncing
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 60,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _isSyncing
                              ? const ScallopedProgressIndicator(
                                  key: ValueKey('loader'),
                                  size: 60,
                                  strokeWidth: 3,
                                  waveCount: 12,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple,
                                      Colors.blueAccent,
                                      Colors.greenAccent,
                                      Colors.orangeAccent,
                                      Colors.redAccent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                )
                              : Center(
                                  key: const ValueKey('icon'),
                                  child: Text(
                                    'Start',
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'The indicator works anywhere!',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _DemoButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
