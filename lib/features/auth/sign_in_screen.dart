import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  static const _brandRed = Color(0xFFE94057);

  // Figma asset — expires in 7 days; replace with a local asset after download
  static const _logoUrl =
      'https://www.figma.com/api/mcp/asset/d6a5c752-0dc5-4d47-ab08-23e6a8df2fe7';
  static const _facebookIconUrl =
      'https://www.figma.com/api/mcp/asset/106c9f13-ece5-4ce9-a56c-4be137a8eb1e';
  static const _googleIconUrl =
      'https://www.figma.com/api/mcp/asset/17bda145-3779-4430-9b54-fc92662270ab';
  static const _appleIconUrl =
      'https://www.figma.com/api/mcp/asset/cb7cceb8-6a4f-4ad3-b1c6-d7b60c7cd7a3';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              Center(
                child: SvgPicture.network(_logoUrl, width: 100, height: 100),
              ),
              const Spacer(flex: 3),
              const Text(
                'Sign up to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              _PrimaryButton(
                label: 'Continue with email',
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              _OutlineButton(
                label: 'Use phone number',
                onPressed: () {},
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black.withValues(alpha: 0.4),
                      thickness: 0.5,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or sign up with',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black.withValues(alpha: 0.4),
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                    iconUrl: _facebookIconUrl,
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  _SocialButton(
                    iconUrl: _googleIconUrl,
                    onTap: () => _handleGoogleSignIn(context, controller),
                  ),
                  const SizedBox(width: 16),
                  _SocialButton(
                    iconUrl: _appleIconUrl,
                    onTap: () {},
                  ),
                ],
              ),
              const Spacer(flex: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: _brandRed,
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Terms of use', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 32),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: _brandRed,
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Privacy Policy', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(
    BuildContext context,
    AuthController controller,
  ) async {
    try {
      final result = await controller.signInWithGoogle();
      if (result != null && context.mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: $e')),
        );
      }
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE94057),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE94057),
          side: const BorderSide(color: Color(0xFFF3F3F3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.iconUrl, required this.onTap});

  final String iconUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE8E6EA)),
        ),
        padding: const EdgeInsets.all(14),
        child: SvgPicture.network(iconUrl),
      ),
    );
  }
}
