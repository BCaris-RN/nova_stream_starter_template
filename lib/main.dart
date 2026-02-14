import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const NovaStreamHubApp());
}

class NovaStreamHubApp extends StatelessWidget {
  const NovaStreamHubApp({super.key, this.showSplash = true});

  final bool showSplash;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaStream Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF08080A),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F7FF),
          secondary: Color(0xFFBC00FF),
          surface: Color(0xFF0D0D0F),
        ),
      ),
      home: _AppRoot(showSplash: showSplash),
    );
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot({required this.showSplash});

  final bool showSplash;

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  bool _showMainApp = false;

  @override
  void initState() {
    super.initState();
    if (!widget.showSplash) {
      _showMainApp = true;
      return;
    }

    Future<void>.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showMainApp = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 650),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _showMainApp
          ? const NovaHubScreen(key: ValueKey('hub'))
          : const _NovaSplashScreen(key: ValueKey('splash')),
    );
  }
}

class _NovaSplashScreen extends StatefulWidget {
  const _NovaSplashScreen({super.key});

  @override
  State<_NovaSplashScreen> createState() => _NovaSplashScreenState();
}

class _NovaSplashScreenState extends State<_NovaSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final logoSize = width < 700 ? 44.0 : 58.0;
    final logoWordmarkWidth = width < 700 ? 170.0 : 210.0;
    final subtitleSize = width < 700 ? 14.0 : 16.0;

    return Scaffold(
      body: Stack(
        children: [
          const _AuraBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final progress = Curves.easeInOut.transform(
                          _controller.value,
                        );

                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            _PulseOrbit(progress: progress),
                            Container(
                              width: 190,
                              height: 190,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.03),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.14),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: _controller.value * math.pi * 2,
                              child: const SizedBox(
                                width: 228,
                                height: 228,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: _OrbitDot(
                                        color: Color(0xFF00F7FF),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: _OrbitDot(
                                        color: Color(0xFFBC00FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: logoWordmarkWidth,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: ShaderMask(
                                  shaderCallback: (bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0xFF00F7FF),
                                        Color(0xFFBC00FF),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    'NOVA.',
                                    maxLines: 1,
                                    softWrap: false,
                                    style: GoogleFonts.syne(
                                      color: Colors.white,
                                      fontSize: logoSize,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Stream hub boot sequence in progress',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      letterSpacing: 0.3,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: 280,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        height: 7,
                        color: Colors.white.withValues(alpha: 0.08),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final progress = Curves.easeInOut.transform(
                              _controller.value,
                            );
                            final widthFactor = 0.22 + (progress * 0.78);

                            return Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: widthFactor,
                                child: child,
                              ),
                            );
                          },
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF00F7FF), Color(0xFFBC00FF)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseOrbit extends StatelessWidget {
  const _PulseOrbit({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _PulseRing(progress: progress, baseColor: const Color(0xFF00F7FF)),
        _PulseRing(
          progress: (progress + 0.5) % 1,
          baseColor: const Color(0xFFBC00FF),
        ),
      ],
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.progress, required this.baseColor});

  final double progress;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.72 + (progress * 0.75),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: baseColor.withValues(alpha: (1 - progress) * 0.38),
            width: 1.8,
          ),
        ),
      ),
    );
  }
}

class _OrbitDot extends StatelessWidget {
  const _OrbitDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.55),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class NovaHubScreen extends StatefulWidget {
  const NovaHubScreen({super.key});

  @override
  State<NovaHubScreen> createState() => _NovaHubScreenState();
}

class _NovaHubScreenState extends State<NovaHubScreen>
    with TickerProviderStateMixin {
  String _currentScreen = 'discovery';
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  void _navigateTo(String screen) {
    setState(() {
      _currentScreen = screen;
    });
    _staggerController
      ..reset()
      ..forward();
  }

  Widget _buildCurrentView() {
    switch (_currentScreen) {
      case 'details':
        return _DetailsView(onBack: () => _navigateTo('discovery'));
      case 'library':
        return const _LibraryView();
      case 'settings':
        return const _SystemConfigView();
      case 'discovery':
      default:
        return _DiscoveryView(
          controller: _staggerController,
          onSelect: () => _navigateTo('details'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AuraBackground(),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              final currentView = _buildCurrentView();
              final activeSection = _currentScreen == 'details'
                  ? 'discovery'
                  : _currentScreen;

              return Row(
                children: [
                  if (isDesktop)
                    _Sidebar(
                      activeScreen: activeSection,
                      onNavigate: _navigateTo,
                    ),
                  Expanded(
                    child: isDesktop
                        ? currentView
                        : Column(
                            children: [
                              if (_currentScreen != 'details')
                                _MobileSectionTabs(
                                  activeScreen: activeSection,
                                  onNavigate: _navigateTo,
                                ),
                              Expanded(child: currentView),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DiscoveryView extends StatelessWidget {
  const _DiscoveryView({required this.controller, required this.onSelect});

  final AnimationController controller;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Streams',
            style: GoogleFonts.syne(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Experience the next generation of interactive media.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 64),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 450,
              mainAxisSpacing: 32,
              crossAxisSpacing: 32,
              childAspectRatio: 16 / 10,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final delay = index * 0.1;
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final opacity = CurvedAnimation(
                    parent: controller,
                    curve: Interval(
                      delay.clamp(0, 0.5),
                      (delay + 0.5).clamp(0, 1),
                      curve: Curves.easeOut,
                    ),
                  ).value;
                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - opacity)),
                      child: _DiscoveryCard(onTap: onSelect),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DiscoveryCard extends StatefulWidget {
  const _DiscoveryCard({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_DiscoveryCard> createState() => _DiscoveryCardState();
}

class _DiscoveryCardState extends State<_DiscoveryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = false),
        onTapUp: (_) => setState(() => _isHovered = true),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1,
          duration: const Duration(milliseconds: 200),
          child: _GlassPanel(
            borderColor: _isHovered
                ? const Color(0xFF00F7FF).withValues(alpha: 0.5)
                : null,
            child: Stack(
              children: [
                const _Shimmer(),
                Positioned(
                  bottom: 24,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00F7FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Atmospheric Flow v4',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00F7FF)),
            label: const Text(
              'Back to Dashboard',
              style: TextStyle(color: Color(0xFF00F7FF)),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Atmospheric Flow',
            style: GoogleFonts.syne(
              fontSize: 80,
              fontWeight: FontWeight.w900,
              height: 0.9,
            ),
          ),
          const SizedBox(height: 48),
          _GlassPanel(
            height: 450,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'High-fidelity system initialization completed. Functional scroll enabled for deep-dive content analysis...',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF94A3B8),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 800),
        ],
      ),
    );
  }
}

class _LibraryView extends StatelessWidget {
  const _LibraryView();

  static const _collections = <({String title, String detail, Color accent})>[
    (
      title: 'Atmospheric Flow v4',
      detail: 'Saved 2h ago  •  4K interactive',
      accent: Color(0xFF00F7FF),
    ),
    (
      title: 'Neon Drift Sessions',
      detail: 'Queued  •  3 creators followed',
      accent: Color(0xFFBC00FF),
    ),
    (
      title: 'Pulse Reactor Archives',
      detail: 'Last opened yesterday',
      accent: Color(0xFF22C55E),
    ),
    (
      title: 'Midnight Signal Lab',
      detail: 'Downloaded for offline preview',
      accent: Color(0xFFF59E0B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Library',
            style: GoogleFonts.syne(
              fontSize: 62,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Saved Experiences',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 38),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 430,
              mainAxisSpacing: 26,
              crossAxisSpacing: 26,
              childAspectRatio: 16 / 10,
            ),
            itemCount: _collections.length,
            itemBuilder: (context, index) {
              final item = _collections[index];
              return _GlassPanel(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              item.accent.withValues(alpha: 0.22),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Icon(
                        Icons.bookmark_added_rounded,
                        color: item.accent.withValues(alpha: 0.9),
                        size: 28,
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.detail,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.74),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SystemConfigView extends StatefulWidget {
  const _SystemConfigView();

  @override
  State<_SystemConfigView> createState() => _SystemConfigViewState();
}

class _SystemConfigViewState extends State<_SystemConfigView> {
  bool _adaptiveBitrate = true;
  bool _hdrPipeline = true;
  bool _usageTelemetry = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Config',
            style: GoogleFonts.syne(
              fontSize: 62,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tune playback, runtime profile, and diagnostics.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 34),
          _GlassPanel(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Runtime Profile',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 18),
                  _ConfigStatusRow(
                    label: 'Active Renderer',
                    value: 'NovaRT / DX12 Hybrid',
                  ),
                  SizedBox(height: 12),
                  _ConfigStatusRow(
                    label: 'Target Resolution',
                    value: '3840 x 2160',
                  ),
                  SizedBox(height: 12),
                  _ConfigStatusRow(
                    label: 'Frame Sync',
                    value: 'Adaptive 120Hz',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          _GlassPanel(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Runtime Diagnostics',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  _ConfigSwitchTile(
                    label: 'Adaptive bitrate correction',
                    detail: 'Balances stream quality against network jitter.',
                    value: _adaptiveBitrate,
                    onChanged: (value) {
                      setState(() {
                        _adaptiveBitrate = value;
                      });
                    },
                  ),
                  _ConfigSwitchTile(
                    label: 'HDR post-processing pipeline',
                    detail: 'Applies highlight remap and bloom limiter.',
                    value: _hdrPipeline,
                    onChanged: (value) {
                      setState(() {
                        _hdrPipeline = value;
                      });
                    },
                  ),
                  _ConfigSwitchTile(
                    label: 'Anonymous usage telemetry',
                    detail: 'Shares non-identifiable runtime metrics.',
                    value: _usageTelemetry,
                    onChanged: (value) {
                      setState(() {
                        _usageTelemetry = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigStatusRow extends StatelessWidget {
  const _ConfigStatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00F7FF),
          ),
        ),
      ],
    );
  }
}

class _ConfigSwitchTile extends StatelessWidget {
  const _ConfigSwitchTile({
    required this.label,
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.66),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF00F7FF),
            activeTrackColor: const Color(0xFF00F7FF).withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}

class _MobileSectionTabs extends StatelessWidget {
  const _MobileSectionTabs({
    required this.activeScreen,
    required this.onNavigate,
  });

  final String activeScreen;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _MobileTabChip(
                label: 'Discovery',
                isActive: activeScreen == 'discovery',
                onTap: () => onNavigate('discovery'),
              ),
              const SizedBox(width: 8),
              _MobileTabChip(
                label: 'Library',
                isActive: activeScreen == 'library',
                onTap: () => onNavigate('library'),
              ),
              const SizedBox(width: 8),
              _MobileTabChip(
                label: 'System Config',
                isActive: activeScreen == 'settings',
                onTap: () => onNavigate('settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileTabChip extends StatelessWidget {
  const _MobileTabChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF00F7FF).withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive
                ? const Color(0xFF00F7FF).withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF00F7FF) : const Color(0xFFCBD5E1),
          ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.activeScreen, required this.onNavigate});

  final String activeScreen;
  final Function(String) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white10)),
        color: Color(0xFF08080A),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOVA.',
            style: GoogleFonts.syne(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF00F7FF), Color(0xFFBC00FF)],
                ).createShader(const Rect.fromLTWH(0, 0, 100, 32)),
            ),
          ),
          const SizedBox(height: 64),
          _NavButton(
            label: 'Discovery',
            isActive: activeScreen == 'discovery',
            onTap: () => onNavigate('discovery'),
          ),
          const SizedBox(height: 8),
          _NavButton(
            label: 'My Library',
            isActive: activeScreen == 'library',
            onTap: () => onNavigate('library'),
          ),
          const SizedBox(height: 8),
          _NavButton(
            label: 'System Config',
            isActive: activeScreen == 'settings',
            onTap: () => onNavigate('settings'),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isActive
                ? const Color(0xFF00F7FF).withValues(alpha: 0.05)
                : (_isHovered
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: widget.isActive
                    ? const Color(0xFF00F7FF)
                    : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.only(
                    left: _isHovered && !widget.isActive ? 8 : 0,
                  ),
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: widget.isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: widget.isActive
                          ? const Color(0xFF00F7FF)
                          : (_isHovered
                                ? Colors.white
                                : const Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuraBackground extends StatelessWidget {
  const _AuraBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6),
            radius: 1.2,
            colors: [Color(0x26BC00FF), Colors.transparent],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.8, 0.6),
              radius: 1.2,
              colors: [Color(0x1A00F7FF), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    this.height,
    this.width,
    required this.child,
    this.borderColor,
  });

  final double? height;
  final double? width;
  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Shimmer extends StatefulWidget {
  const _Shimmer();

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned.fill(
          child: FractionallySizedBox(
            widthFactor: 2,
            alignment: Alignment(_controller.value * 4 - 2, 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.4, 0.5, 0.6],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
