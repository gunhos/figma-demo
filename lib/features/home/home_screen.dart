import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_controller.dart';

// ── Mock data ──────────────────────────────────────────────────────────────

class _Profile {
  const _Profile({
    required this.name,
    required this.age,
    required this.distance,
    required this.imageUrl,
    required this.passions,
  });
  final String name;
  final int age;
  final String distance;
  final String imageUrl;
  final List<String> passions;
}

const _mockProfiles = [
  _Profile(
    name: 'Sarah',
    age: 26,
    distance: '2 km away',
    imageUrl: 'https://picsum.photos/seed/sarah/400/600',
    passions: ['Yoga', 'Traveling', 'Photography'],
  ),
  _Profile(
    name: 'Emma',
    age: 24,
    distance: '5 km away',
    imageUrl: 'https://picsum.photos/seed/emma/400/600',
    passions: ['Music', 'Cooking', 'Art'],
  ),
  _Profile(
    name: 'Olivia',
    age: 28,
    distance: '8 km away',
    imageUrl: 'https://picsum.photos/seed/olivia/400/600',
    passions: ['Running', 'Reading', 'Movies'],
  ),
  _Profile(
    name: 'Mia',
    age: 23,
    distance: '12 km away',
    imageUrl: 'https://picsum.photos/seed/mia/400/600',
    passions: ['Karaoke', 'Swimming', 'Shopping'],
  ),
  _Profile(
    name: 'Ava',
    age: 27,
    distance: '3 km away',
    imageUrl: 'https://picsum.photos/seed/ava/400/600',
    passions: ['Tennis', 'Video Games', 'Drinking'],
  ),
];

// ── Screen ─────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _navIndex = 0;

  late final AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  bool _animating = false;

  List<_Profile> get _remaining =>
      _mockProfiles.skip(_currentIndex).toList();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _resetAnims(Offset.zero);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _resetAnims(Offset endOffset) {
    _slideAnim = Tween<Offset>(begin: Offset.zero, end: endOffset)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _fadeAnim = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
  }

  Future<void> _dismiss(bool liked) async {
    if (_animating) return;
    _animating = true;
    _resetAnims(liked ? const Offset(1.5, -0.2) : const Offset(-1.5, -0.2));
    _animCtrl.reset();
    await _animCtrl.forward();
    setState(() {
      _currentIndex++;
      _animating = false;
    });
    _animCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showProfileMenu(context),
            child: _CurrentUserAvatar(),
          ),
          const Spacer(),
          const Text(
            'Discover',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_remaining.isEmpty) {
      return _EmptyState(onReset: () => setState(() => _currentIndex = 0));
    }

    return Column(
      children: [
        Expanded(child: _buildCardStack()),
        const SizedBox(height: 24),
        _buildActionRow(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCardStack() {
    if (_remaining.isEmpty) return const SizedBox.shrink();

    final hasNext = _remaining.length > 1;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (hasNext)
          Positioned(
            bottom: 0,
            child: _ProfileCard(
              profile: _remaining[1],
              scale: 0.94,
              elevation: 0,
            ),
          ),
        SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: _ProfileCard(
                profile: _remaining.first, scale: 1.0, elevation: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: Icons.close,
          color: const Color(0xFFE94057),
          size: 56,
          onTap: () => _dismiss(false),
        ),
        const SizedBox(width: 16),
        _ActionButton(
          icon: Icons.star,
          color: const Color(0xFF6E88F8),
          size: 44,
          onTap: () => _dismiss(true),
        ),
        const SizedBox(width: 16),
        _ActionButton(
          icon: Icons.favorite,
          color: const Color(0xFF4AC27E),
          size: 56,
          onTap: () => _dismiss(true),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    const items = [
      (Icons.home_outlined, Icons.home, 'Home'),
      (Icons.favorite_border, Icons.favorite, 'Matches'),
      (Icons.chat_bubble_outline, Icons.chat_bubble, 'Messages'),
      (Icons.person_outline, Icons.person, 'Profile'),
    ];

    return BottomNavigationBar(
      currentIndex: _navIndex,
      onTap: (i) {
        if (i == 3) {
          _showProfileMenu(context);
        } else {
          setState(() => _navIndex = i);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFE94057),
      unselectedItemColor: const Color(0xFFAAAAAA),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
      backgroundColor: Colors.white,
      items: items
          .map((e) => BottomNavigationBarItem(
                icon: Icon(e.$1),
                activeIcon: Icon(e.$2),
                label: e.$3,
              ))
          .toList(),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ProfileMenuSheet(
        onSignOut: () async {
          Navigator.pop(context);
          await ref.read(authControllerProvider).signOut();
          if (context.mounted) context.go('/sign-in');
        },
      ),
    );
  }
}

// ── Profile card ────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.scale,
    required this.elevation,
  });

  final _Profile profile;
  final double scale;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width - 40;
    final h = w * 1.35;

    return Transform.scale(
      scale: scale,
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: w,
          height: h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                profile.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(color: const Color(0xFFE0E0E0)),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${profile.name}, ${profile.age}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.verified,
                            color: Color(0xFF6E88F8), size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          profile.distance,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: profile.passions
                          .map(
                            (p) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.6)),
                              ),
                              child: Text(
                                p,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Action button ───────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }
}

// ── Current user avatar ──────────────────────────────────────────────────────

class _CurrentUserAvatar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoUrl = ref.watch(authStateProvider).valueOrNull?.photoURL;

    if (photoUrl != null) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(photoUrl),
      );
    }
    return const CircleAvatar(
      radius: 22,
      backgroundColor: Color(0xFFE8E6EA),
      child: Icon(Icons.person, color: Color(0xFFAAAAAA)),
    );
  }
}

// ── Profile menu sheet ──────────────────────────────────────────────────────

class _ProfileMenuSheet extends ConsumerWidget {
  const _ProfileMenuSheet({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (user?.photoURL != null)
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
          const SizedBox(height: 12),
          Text(
            user?.displayName ?? '',
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? '',
            style:
                const TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onSignOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE94057),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Sign out',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border,
                size: 80, color: Color(0xFFE8E6EA)),
            const SizedBox(height: 24),
            const Text(
              "You've seen everyone!",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for new people near you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE94057),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: Text('Start over',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
