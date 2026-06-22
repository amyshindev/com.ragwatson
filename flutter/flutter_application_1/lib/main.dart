import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaestroApp());
}

/// Maestro web theme tokens (`frontend/app/globals.css`, landing hero).
abstract final class MaestroPalette {
  static const accent = Color(0xFF38667E);
  static const accentBlue = Color(0xFF2563EB);
  static const accentBlueHover = Color(0xFF1D4ED8);

  static const lightBg = Color(0xFFF9FAFB);
  static const lightSurface = Color(0xFFF3F4F6);
  static const lightSection = Color(0xFFF3F4F6);
  static const lightText = Color(0xFF111827);
  static const lightTextSecondary = Color(0xFF6B7280);
  static const lightBorder = Color(0xFFE5E7EB);

  static const darkBg = Color(0xFF0A0A0A);
  static const darkSection = Color(0xFF111114);
  static const darkText = Color(0xFFEDEDED);
  static const darkTextSecondary = Color(0xFFA1A1AA);
  static const darkBorder = Color(0xFF27272A);
}

class MaestroApp extends StatefulWidget {
  const MaestroApp({super.key});

  @override
  State<MaestroApp> createState() => _MaestroAppState();
}

class _MaestroAppState extends State<MaestroApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseText = GoogleFonts.notoSansKrTextTheme();
    final heading = GoogleFonts.outfitTextTheme(baseText);

    return MaterialApp(
      title: 'Maestro',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: _buildTheme(heading, Brightness.light),
      darkTheme: _buildTheme(heading, Brightness.dark),
      home: IntroScreen(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }

  ThemeData _buildTheme(TextTheme heading, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? MaestroPalette.darkBg : MaestroPalette.lightBg;
    final fg = isDark ? MaestroPalette.darkText : MaestroPalette.lightText;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: MaestroPalette.accentBlue,
        brightness: brightness,
        surface: bg,
        onSurface: fg,
      ),
      textTheme: heading.apply(
        bodyColor: fg,
        displayColor: fg,
      ),
    );
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _ctaKey = GlobalKey();

  late final AnimationController _heroController;
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;

  Offset _parallax = Offset.zero;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _heroFade = CurvedAnimation(
      parent: _heroController,
      curve: const Cubic(0.22, 1, 0.36, 1),
    );
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_heroFade);
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCta() {
    final context = _ctaKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? MaestroPalette.darkBg : MaestroPalette.lightBg;
    final textPrimary =
        isDark ? MaestroPalette.darkText : MaestroPalette.lightText;
    final textSecondary = isDark
        ? MaestroPalette.darkTextSecondary
        : MaestroPalette.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: bg.withValues(alpha: 0.82),
                surfaceTintColor: Colors.transparent,
                title: _MaestroBrand(isDark: isDark),
                actions: [
                  IconButton(
                    tooltip: isDark ? '라이트 모드' : '다크 모드',
                    onPressed: widget.onToggleTheme,
                    icon: Icon(
                      isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              SliverToBoxAdapter(
                child: _HeroSection(
                  isDark: isDark,
                  parallax: _parallax,
                  fadeAnimation: _heroFade,
                  slideAnimation: _heroSlide,
                  onParallaxDelta: (delta) {
                    setState(() {
                      _parallax += delta;
                      _parallax = Offset(
                        _parallax.dx.clamp(-24.0, 24.0),
                        _parallax.dy.clamp(-24.0, 24.0),
                      );
                    });
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: _HowItWorksSection(isDark: isDark),
              ),
              SliverToBoxAdapter(
                child: _FinalCtaSection(
                  key: _ctaKey,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _BottomPromptBar(
              isDark: isDark,
              onTap: _scrollToCta,
            ),
          ),
        ],
      ),
    );
  }
}

class _MaestroBrand extends StatelessWidget {
  const _MaestroBrand({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? MaestroPalette.darkText : MaestroPalette.lightText;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isDark
                  ? [MaestroPalette.accent, const Color(0xFF6B9EB5)]
                  : [MaestroPalette.accentBlue, MaestroPalette.accent],
            ),
          ),
          child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          'Maestro',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.isDark,
    required this.parallax,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onParallaxDelta,
  });

  final bool isDark;
  final Offset parallax;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final ValueChanged<Offset> onParallaxDelta;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.88;
    final textPrimary =
        isDark ? MaestroPalette.darkText : MaestroPalette.lightText;
    final textSecondary = isDark
        ? MaestroPalette.darkTextSecondary
        : MaestroPalette.lightTextSecondary;

    return SizedBox(
      height: height,
      child: GestureDetector(
        onPanUpdate: (details) {
          onParallaxDelta(details.delta * 0.04);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: parallax,
              child: CustomPaint(
                painter: _HeroMeshPainter(isDark: isDark),
                child: const SizedBox.expand(),
              ),
            ),
            Transform.translate(
              offset: parallax * 1.5,
              child: CustomPaint(
                painter: _HeroGlowPainter(isDark: isDark),
                child: const SizedBox.expand(),
              ),
            ),
            CustomPaint(
              painter: _GrainPainter(isDark: isDark),
              child: const SizedBox.expand(),
            ),
            Center(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Your sound,\nthrough our eye.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: _clampFont(context, 28, 44),
                            fontWeight: FontWeight.w600,
                            height: 1.08,
                            letterSpacing: -0.8,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '당신의 음악을 이해하는 AI 에이전트로,\n숏폼 최적화 아티스틱 비주얼을.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansKr(
                            fontSize: _clampFont(context, 15, 18),
                            height: 1.7,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _clampFont(BuildContext context, double min, double max) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.09).clamp(min, max);
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection({required this.isDark});

  final bool isDark;

  static const _steps = [
    (
      icon: Icons.library_music_outlined,
      title: 'Drop Your Sound',
      description: 'MP3/WAV 파일이나 사운드클라우드/유튜브 링크를 넣습니다.',
    ),
    (
      icon: Icons.psychology_outlined,
      title: 'AI Aesthetic Analysis',
      description: 'AI가 곡의 BPM, 악기 구성, 장르적 감성을 매핑합니다.',
    ),
    (
      icon: Icons.movie_creation_outlined,
      title: 'Get Your Artwork',
      description: '단 몇 초 만에 내 곡에 완벽히 녹아드는 고화질 루프 영상 완성.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sectionBg =
        isDark ? MaestroPalette.darkSection : MaestroPalette.lightSection;
    final borderColor =
        isDark ? MaestroPalette.darkBorder : MaestroPalette.lightBorder;
    final titleColor =
        isDark ? MaestroPalette.darkText : MaestroPalette.lightText;
    final bodyColor = isDark
        ? MaestroPalette.darkTextSecondary
        : MaestroPalette.lightTextSecondary;
    final iconColor =
        isDark ? const Color(0xFF8AADBE) : MaestroPalette.accentBlue;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: sectionBg,
        border: Border(
          top: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 56),
      child: Column(
        children: [
          Text(
            'How it works',
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 40),
          for (var i = 0; i < _steps.length; i++) ...[
            _StepCard(
              icon: _steps[i].icon,
              title: _steps[i].title,
              description: _steps[i].description,
              iconColor: iconColor,
              titleColor: titleColor,
              bodyColor: bodyColor,
            ),
            if (i < _steps.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: bodyColor.withValues(alpha: 0.6),
                  size: 22,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.titleColor,
    required this.bodyColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color titleColor;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        children: [
          Icon(icon, size: 40, color: iconColor),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              height: 1.55,
              color: bodyColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalCtaSection extends StatelessWidget {
  const _FinalCtaSection({
    super.key,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
  });

  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? MaestroPalette.darkBg : MaestroPalette.lightBg;
    final borderColor =
        isDark ? MaestroPalette.darkBorder : MaestroPalette.lightBorder;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 72, 20, 48),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          Text(
            '지금 바로 당신의 음악을\n눈앞에서.',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: _clampFont(context, 26, 36),
              fontWeight: FontWeight.w600,
              height: 1.25,
              letterSpacing: -0.4,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '무료로 시작하세요. 카드 없이.',
            style: GoogleFonts.notoSansKr(
              fontSize: 16,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          _UploadZone(isDark: isDark),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor:
                  isDark ? MaestroPalette.accentBlue : MaestroPalette.accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              '원클릭으로 비주얼 뽑기',
              style: GoogleFonts.notoSansKr(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _clampFont(BuildContext context, double min, double max) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.075).clamp(min, max);
  }
}

class _UploadZone extends StatelessWidget {
  const _UploadZone({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : MaestroPalette.lightBorder;
    final fill = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.white.withValues(alpha: 0.85);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 36,
            color: isDark ? MaestroPalette.darkText : MaestroPalette.accent,
          ),
          const SizedBox(height: 12),
          Text(
            '음악 파일을 여기에 놓으세요',
            style: GoogleFonts.notoSansKr(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? MaestroPalette.darkText : MaestroPalette.lightText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'MP3 · WAV · 링크',
            style: GoogleFonts.notoSansKr(
              fontSize: 13,
              color: isDark
                  ? MaestroPalette.darkTextSecondary
                  : MaestroPalette.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomPromptBar extends StatelessWidget {
  const _BottomPromptBar({
    required this.isDark,
    required this.onTap,
  });

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? const Color(0xFF18181B).withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.92);
    final border = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : MaestroPalette.lightBorder;
    final textColor =
        isDark ? MaestroPalette.darkText : MaestroPalette.lightText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.45)
                    : Colors.grey.shade300.withValues(alpha: 0.45),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '지금 바로 당신의 음악을 눈앞에서.',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: MaestroPalette.accentBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.white,
                    size: 18,
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

class _HeroMeshPainter extends CustomPainter {
  _HeroMeshPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final base = isDark ? MaestroPalette.darkBg : MaestroPalette.lightBg;
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    void radial({
      required Offset center,
      required double radius,
      required Color color,
    }) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    if (isDark) {
      radial(
        center: Offset(size.width * 0.5, size.height * 0.08),
        radius: size.shortestSide * 0.95,
        color: const Color(0xFF1B435E).withValues(alpha: 0.45),
      );
      radial(
        center: Offset(size.width * 0.48, size.height * 0.62),
        radius: size.shortestSide * 0.75,
        color: const Color(0xFF563457).withValues(alpha: 0.38),
      );
      radial(
        center: Offset(size.width * 0.78, size.height * 0.38),
        radius: size.shortestSide * 0.65,
        color: MaestroPalette.accent.withValues(alpha: 0.28),
      );
    } else {
      radial(
        center: Offset(size.width * 0.5, size.height * 0.08),
        radius: size.shortestSide * 0.95,
        color: MaestroPalette.accent.withValues(alpha: 0.22),
      );
      radial(
        center: Offset(size.width * 0.48, size.height * 0.62),
        radius: size.shortestSide * 0.75,
        color: const Color(0xFF563457).withValues(alpha: 0.12),
      );
      radial(
        center: Offset(size.width * 0.78, size.height * 0.38),
        radius: size.shortestSide * 0.65,
        color: MaestroPalette.accent.withValues(alpha: 0.14),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeroMeshPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class _HeroGlowPainter extends CustomPainter {
  _HeroGlowPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.2),
        radius: 1.1,
        colors: isDark
            ? [
                MaestroPalette.accentBlue.withValues(alpha: 0.12),
                Colors.transparent,
              ]
            : [
                MaestroPalette.accentBlue.withValues(alpha: 0.08),
                Colors.transparent,
              ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _HeroGlowPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class _GrainPainter extends CustomPainter {
  _GrainPainter({required this.isDark});

  final bool isDark;
  final _random = math.Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black)
          .withValues(alpha: isDark ? 0.035 : 0.04);
    for (var i = 0; i < 900; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GrainPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
