import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PassionsScreen extends StatefulWidget {
  const PassionsScreen({super.key});

  @override
  State<PassionsScreen> createState() => _PassionsScreenState();
}

class _PassionsScreenState extends State<PassionsScreen> {
  static const _brandRed = Color(0xFFE94057);
  static const _maxSelections = 5;

  final _selected = <String>{};

  static const _passions = [
    'Photography', 'Shopping', 'Karaoke', 'Yoga',
    'Cooking', 'Tennis', 'Running', 'Swimming',
    'Art', 'Traveling', 'Extreme Sports', 'Music',
    'Drinking', 'Video Games', 'Movies', 'Reading',
  ];

  void _toggle(String passion) {
    setState(() {
      if (_selected.contains(passion)) {
        _selected.remove(passion);
      } else if (_selected.length < _maxSelections) {
        _selected.add(passion);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Your passions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Let everyone know what you are passionate about.',
                style: TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _passions
                    .map((p) => _PassionChip(
                          label: p,
                          selected: _selected.contains(p),
                          disabled: !_selected.contains(p) &&
                              _selected.length >= _maxSelections,
                          onTap: () => _toggle(p),
                        ))
                    .toList(),
              ),
              const Spacer(),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _selected.isNotEmpty
                      ? () => context.go('/phone-number')
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandRed,
                    disabledBackgroundColor: _brandRed.withValues(alpha: 0.4),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassionChip extends StatelessWidget {
  const _PassionChip({
    required this.label,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE94057) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected
                ? const Color(0xFFE94057)
                : disabled
                    ? const Color(0xFFE8E6EA).withValues(alpha: 0.4)
                    : const Color(0xFFE8E6EA),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : disabled
                    ? const Color(0xFFBBBBBB)
                    : Colors.black,
          ),
        ),
      ),
    );
  }
}
