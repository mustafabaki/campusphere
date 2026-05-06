import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';
import 'package:campusphere_frontend/pages/Home/home.dart';

/// Main application shell that provides a consistent bottom navigation bar
/// across all authenticated pages. Uses [IndexedStack] to preserve page
/// state when switching tabs.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    _PlaceholderPage(title: 'Hub', icon: Icons.grid_view),
    _PlaceholderPage(title: 'Services', icon: Icons.local_library),
    _PlaceholderPage(title: 'Map', icon: Icons.map_outlined),
    _PlaceholderPage(title: 'Student ID', icon: Icons.qr_code_2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryContainer.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRect(
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isActive: _currentIndex == 0,
                    onTap: () => _onTabTapped(0),
                  ),
                  _NavItem(
                    icon: Icons.grid_view_outlined,
                    activeIcon: Icons.grid_view,
                    label: 'Hub',
                    isActive: _currentIndex == 1,
                    onTap: () => _onTabTapped(1),
                  ),
                  _NavItem(
                    icon: Icons.local_library_outlined,
                    activeIcon: Icons.local_library,
                    label: 'Services',
                    isActive: _currentIndex == 2,
                    onTap: () => _onTabTapped(2),
                  ),
                  _NavItem(
                    icon: Icons.map_outlined,
                    activeIcon: Icons.map,
                    label: 'Map',
                    isActive: _currentIndex == 3,
                    onTap: () => _onTabTapped(3),
                  ),
                  _NavItem(
                    icon: Icons.qr_code_2_outlined,
                    activeIcon: Icons.qr_code_2,
                    label: 'ID',
                    isActive: _currentIndex == 4,
                    onTap: () => _onTabTapped(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

/// A single bottom navigation item with active/inactive states.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive
                    ? AppColors.universityBlue
                    : Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? AppColors.universityBlue
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder page for unimplemented tabs.
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, color: AppColors.universityBlue, size: 26),
            const SizedBox(width: 10),
            Text(
              'CampuSphere',
              style: GoogleFonts.lexend(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.universityBlue,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.outlineVariant),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.lexend(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
