import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onDarkModeToggle;
  final bool isDarkMode;

  const ProfileScreen({super.key, required this.onDarkModeToggle, required this.isDarkMode});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = AppData.user;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Profil', style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w600)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Profile header
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(user.initials, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.t1)),
                        const SizedBox(height: 2),
                        Text(user.role, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
                        const SizedBox(height: 2),
                        Text(user.dept, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t2)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/edit-profile'),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.t1),
                    ),
                  ),
                ],
              ),
            ),

            // Info section
            _SectionCard(
              title: 'Informasi Akun',
              children: [
                _InfoRow(icon: Icons.mail_outline, label: 'Email', value: user.email),
                _InfoRow(icon: Icons.phone_outlined, label: 'Telepon', value: user.phone),
                _InfoRow(icon: Icons.location_on_outlined, label: 'Lantai', value: user.floor),
              ],
            ),

            // Settings
            _SectionCard(
              title: 'Pengaturan',
              children: [
                _ToggleRow(
                  icon: Icons.dark_mode_outlined,
                  label: 'Mode Gelap',
                  value: widget.isDarkMode,
                  onChanged: (_) => widget.onDarkModeToggle(),
                ),
                _MenuRow(icon: Icons.notifications_outlined, label: 'Notifikasi', onTap: () {}),
                _MenuRow(icon: Icons.language_outlined, label: 'Bahasa', trailing: 'Indonesia', onTap: () {}),
              ],
            ),

            // App info
            _SectionCard(
              title: 'Aplikasi',
              children: [
                _MenuRow(icon: Icons.help_outline, label: 'Bantuan & FAQ', onTap: () {}),
                _MenuRow(icon: Icons.info_outline, label: 'Tentang RoomEase', trailing: 'v1.0.0', onTap: () {}),
              ],
            ),

            // Logout
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.bookedBg),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, size: 20, color: AppColors.red),
                      const SizedBox(width: 8),
                      Text('Keluar', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.red)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(title, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.t2)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(
              children: children.asMap().entries.map((e) {
                final isLast = e.key == children.length - 1;
                return Column(
                  children: [
                    e.value,
                    if (!isLast) const Divider(height: 1, indent: 52),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.t2),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.sora(fontSize: 11, color: AppColors.t3)),
              Text(value, style: GoogleFonts.sora(fontSize: 14, color: AppColors.t1)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _MenuRow({required this.icon, required this.label, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.t2),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: GoogleFonts.sora(fontSize: 14, color: AppColors.t1))),
            if (trailing != null)
              Text(trailing!, style: GoogleFonts.sora(fontSize: 13, color: AppColors.t3)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.t3),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({required this.icon, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.t2),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: GoogleFonts.sora(fontSize: 14, color: AppColors.t1))),
          Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.navy),
        ],
      ),
    );
  }
}
