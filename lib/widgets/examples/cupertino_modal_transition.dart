import 'package:flutter/cupertino.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Home')),
      child: Center(
        child: CupertinoButton.filled(
          child: const Text('Open Fullscreen Dialog'),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog:
                    true, // 👈 This triggers the CupertinoFullscreenDialogTransition
                builder: (context) => const FullscreenDialogPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FullscreenDialogPage extends StatelessWidget {
  const FullscreenDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Fullscreen Dialog'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.clear),
        ),
      ),
      child: const Center(
        child: Text('This is a fullscreen Cupertino-style dialog!'),
      ),
    );
  }
}
