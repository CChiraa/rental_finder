import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/signin.dart';
import 'package:smart_rental_app/screens/signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F1E7),
              Color(0xFFF2E6D5),
              Color(0xFFEAD8BE),
              Color(0xFFF7EFE5),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundGlowTopRight(),
            _buildBackgroundGlowBottomLeft(),
            _buildSideLeaf(left: true),
            _buildSideLeaf(left: false),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 26),

                    _buildLogo(),

                    const SizedBox(height: 24),

                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF2B2118),
                          Color(0xFF8E6A39),
                          Color(0xFFD8AF5B),
                        ],
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
                        Container(
                          width: 52,
                          height: 1.2,
                          color: const Color(0xFFD3AA57),
                        ),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Color(0xFFD3AA57),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          width: 52,
                          height: 1.2,
                          color: const Color(0xFFD3AA57),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    _buildTaglineCard(),

                    const Spacer(),

                    _buildBottomCard(context),

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

  Widget _buildLogo() {
    return Container(
      width: 152,
      height: 152,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE1BE72).withOpacity(0.45),
            blurRadius: 34,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD7AF5A), width: 2),
          color: const Color(0xFFF8F1E7),
        ),
        child: ClipOval(
          child: Image.asset('images/logo.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTaglineCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD6AA57), width: 1.2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: Color(0xFFC89B47),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            'Find your perfect space\nlive smart, rent better',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5C4630),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB88C45).withOpacity(0.15),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          _primaryButton(context),
          const SizedBox(height: 16),
          _secondaryButton(context),
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

  Widget _secondaryButton(BuildContext context) {
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
        icon: const Icon(
          Icons.person_outline_rounded,
          color: Color(0xFFC28F41),
          size: 24,
        ),
        label: Text(
          'Create Account',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFC28F41),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.16),
          side: const BorderSide(color: Color(0xFFC28F41), width: 1.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundGlowTopRight() {
    return Positioned(
      top: -90,
      right: -60,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFE9BF).withOpacity(0.65),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFE9BF).withOpacity(0.55),
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlowBottomLeft() {
    return Positioned(
      bottom: -120,
      left: -100,
      child: Container(
        width: 280,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(140),
          color: const Color(0xFFFFE7BA).withOpacity(0.35),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFE7BA).withOpacity(0.30),
              blurRadius: 100,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideLeaf({required bool left}) {
    return Positioned(
      left: left ? -12 : null,
      right: left ? null : -12,
      top: left ? 250 : null,
      bottom: left ? null : 180,
      child: Opacity(
        opacity: 0.35,
        child: Column(
          children: const [
            Icon(Icons.spa_outlined, color: Color(0xFFD8B06A), size: 34),
            SizedBox(height: 12),
            Icon(Icons.spa_outlined, color: Color(0xFFD8B06A), size: 32),
            SizedBox(height: 12),
            Icon(Icons.spa_outlined, color: Color(0xFFD8B06A), size: 30),
          ],
        ),
      ),
    );
  }
}
