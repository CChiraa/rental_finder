import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/signin.dart';
import 'package:smart_rental_app/screens/signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Gradient backgroundGradient = dark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF111827),
              Color(0xFF172554),
              Color(0xFF0F172A),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F1E7),
              Color(0xFFF2E6D5),
              Color(0xFFEAD8BE),
              Color(0xFFF7EFE5),
            ],
          );

    final Color titleStart = dark ? Colors.white : const Color(0xFF2B2118);
    final Color titleMid = dark
        ? const Color(0xFF9DB7E8)
        : const Color(0xFF8E6A39);
    final Color titleEnd = dark
        ? const Color(0xFFE6BC6D)
        : const Color(0xFFD8AF5B);

    final Color lineColor = dark
        ? const Color(0xFF9DB7E8)
        : const Color(0xFFD3AA57);
    final Color sparkleColor = dark
        ? const Color(0xFFE6BC6D)
        : const Color(0xFFD3AA57);

    final Color glassCard = dark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.55);

    final Color glassBorder = dark
        ? Colors.white.withOpacity(0.14)
        : Colors.white.withOpacity(0.70);

    final Color taglineCard = dark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.35);

    final Color taglineText = dark
        ? Colors.white.withOpacity(0.88)
        : const Color(0xFF5C4630);

    final Color outlinedButtonText = dark
        ? colorScheme.secondary
        : const Color(0xFFC28F41);

    final Color outlinedButtonBg = dark
        ? Colors.white.withOpacity(0.04)
        : Colors.white.withOpacity(0.16);

    final Color logoBg = dark
        ? const Color(0xFF111827)
        : const Color(0xFFF8F1E7);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Stack(
          children: [
            _buildBackgroundGlowTopRight(dark),
            _buildBackgroundGlowBottomLeft(dark),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 26),
                    _buildLogo(dark: dark, logoBg: logoBg),
                    const SizedBox(height: 24),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [titleStart, titleMid, titleEnd],
                      ).createShader(bounds),
                      child: Text(
                        'Yuppies Lah',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 52, height: 1.2, color: lineColor),
                        const SizedBox(width: 14),
                        Icon(Icons.auto_awesome, size: 16, color: sparkleColor),
                        const SizedBox(width: 14),
                        Container(width: 52, height: 1.2, color: lineColor),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _buildTaglineCard(
                      dark: dark,
                      cardColor: taglineCard,
                      borderColor: sparkleColor,
                      textColor: taglineText,
                      iconColor: sparkleColor,
                    ),
                    const Spacer(),
                    _buildBottomCard(
                      context,
                      dark: dark,
                      cardColor: glassCard,
                      borderColor: glassBorder,
                      outlinedButtonText: outlinedButtonText,
                      outlinedButtonBg: outlinedButtonBg,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo({required bool dark, required Color logoBg}) {
    return Container(
      width: 152,
      height: 152,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: dark
                ? const Color(0xFF9DB7E8).withOpacity(0.18)
                : const Color(0xFFE1BE72).withOpacity(0.45),
            blurRadius: 34,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: dark ? const Color(0xFF9DB7E8) : const Color(0xFFD7AF5A),
            width: 2,
          ),
          color: logoBg,
        ),
        child: ClipOval(
          child: Image.asset('images/logo.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTaglineCard({
    required bool dark,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote_rounded, color: iconColor, size: 28),
          const SizedBox(height: 4),
          Text(
            'Find your perfect space\nlive smart, rent better',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCard(
    BuildContext context, {
    required bool dark,
    required Color cardColor,
    required Color borderColor,
    required Color outlinedButtonText,
    required Color outlinedButtonBg,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.22)
                : const Color(0xFFB88C45).withOpacity(0.15),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          _primaryButton(context),
          const SizedBox(height: 16),
          _secondaryButton(
            context,
            textColor: outlinedButtonText,
            backgroundColor: outlinedButtonBg,
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE6BC6D), Color(0xFFBE8233)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC89243).withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
            );
          },
          icon: const Icon(Icons.login_rounded, color: Colors.white, size: 24),
          label: Text(
            'Sign In',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton(
    BuildContext context, {
    required Color textColor,
    required Color backgroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          );
        },
        icon: Icon(Icons.person_outline_rounded, color: textColor, size: 24),
        label: Text(
          'Create Account',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: textColor, width: 1.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundGlowTopRight(bool dark) {
    return Positioned(
      top: -90,
      right: -60,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dark
              ? const Color(0xFF1D4ED8).withOpacity(0.18)
              : const Color(0xFFFFE9BF).withOpacity(0.65),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? const Color(0xFF1D4ED8).withOpacity(0.18)
                  : const Color(0xFFFFE9BF).withOpacity(0.55),
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlowBottomLeft(bool dark) {
    return Positioned(
      bottom: -120,
      left: -100,
      child: Container(
        width: 280,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(140),
          color: dark
              ? const Color(0xFF60A5FA).withOpacity(0.10)
              : const Color(0xFFFFE7BA).withOpacity(0.35),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? const Color(0xFF60A5FA).withOpacity(0.10)
                  : const Color(0xFFFFE7BA).withOpacity(0.30),
              blurRadius: 100,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
