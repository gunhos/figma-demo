import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _brandRed = Color(0xFFE94057);

  static const _pages = [
    _PageData(
      title: 'Algorithm',
      subtitle:
          'Users going through a vetting process to ensure you never match with bots.',
      leftPhoto:
          'https://www.figma.com/api/mcp/asset/b42bffe1-b9e4-4871-92e9-49d610db5e20',
      centerPhoto:
          'https://www.figma.com/api/mcp/asset/1f0fef80-9d92-420b-9e92-68f73dbc847f',
      rightPhoto:
          'https://www.figma.com/api/mcp/asset/e27bc72c-b486-45bd-a37b-26410f72bebd',
    ),
    _PageData(
      title: 'Matches',
      subtitle:
          'We match you with people that have a large array of similar interests.',
      leftPhoto:
          'https://www.figma.com/api/mcp/asset/6752e33d-3e59-4938-84ba-20f1ee81152b',
      centerPhoto:
          'https://www.figma.com/api/mcp/asset/84d67ec8-2b75-4f67-ae39-e118e3070858',
      rightPhoto:
          'https://www.figma.com/api/mcp/asset/ca6b4b5c-a2eb-4743-ab76-592f82c5d22c',
    ),
    // Screen 3 — Figma rate-limited during fetch; same layout, placeholder content
    _PageData(
      title: 'Premium',
      subtitle:
          'Unlock exclusive features and find your perfect match faster.',
      leftPhoto:
          'https://www.figma.com/api/mcp/asset/b42bffe1-b9e4-4871-92e9-49d610db5e20',
      centerPhoto:
          'https://www.figma.com/api/mcp/asset/84d67ec8-2b75-4f67-ae39-e118e3070858',
      rightPhoto:
          'https://www.figma.com/api/mcp/asset/e27bc72c-b486-45bd-a37b-26410f72bebd',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToSignIn() => context.go('/sign-in');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _PageContent(page: _pages[i]),
              ),
            ),
            _DotsIndicator(count: _pages.length, current: _currentPage),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _goToSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Create an account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withValues(alpha: 0.7),
                  ),
                ),
                GestureDetector(
                  onTap: _goToSignIn,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 14,
                      color: _brandRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  const _PageData({
    required this.title,
    required this.subtitle,
    required this.leftPhoto,
    required this.centerPhoto,
    required this.rightPhoto,
  });

  final String title;
  final String subtitle;
  final String leftPhoto;
  final String centerPhoto;
  final String rightPhoto;
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.page});

  final _PageData page;

  static const _secondary = Color(0xFF323755);
  static const _brandRed = Color(0xFFE94057);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        _PhotoStack(page: page),
        const SizedBox(height: 32),
        Text(
          page.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _brandRed,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: _secondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoStack extends StatelessWidget {
  const _PhotoStack({required this.page});

  final _PageData page;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final scale = w / 375;

        final centerW = 235 * scale;
        final centerH = 360 * scale;
        final sideW = 200 * scale;
        final sideH = 300 * scale;
        final totalH = centerH + 30 * scale;

        return ClipRect(
          child: SizedBox(
            width: w,
            height: totalH,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: -154 * scale,
                  top: 30 * scale,
                  child: _PhotoCard(url: page.leftPhoto, width: sideW, height: sideH),
                ),
                Positioned(
                  left: 70 * scale,
                  top: 0,
                  child: _PhotoCard(url: page.centerPhoto, width: centerW, height: centerH),
                ),
                Positioned(
                  left: 329 * scale,
                  top: 30 * scale,
                  child: _PhotoCard(url: page.rightPhoto, width: sideW, height: sideH),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.url, required this.width, required this.height});

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFFF3F3F3),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE94057) : const Color(0xFFE8E6EA),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
