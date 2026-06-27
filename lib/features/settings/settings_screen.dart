import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/components/flat_card.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../shared/models/compression_level.dart';
import 'models/app_settings.dart';
import 'providers/settings_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
      text: ref.read(settingsProvider).username,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final accent = AppColors.accentRed.resolveFrom(context);
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);
    final bg = AppColors.backgroundPrimary.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.tabBarBackground.resolveFrom(context),
        border: Border(
          bottom: BorderSide(
            color: AppColors.separator.resolveFrom(context),
            width: 0.5,
          ),
        ),
        middle: Text(
          'Settings',
          style: AppTypography.headline.copyWith(color: primary),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sp16,
            AppSpacing.sp20,
            AppSpacing.sp16,
            AppSpacing.sp40 + MediaQuery.of(context).padding.bottom,
          ),
          children: [
            // ── Profile ──────────────────────────────────────────────────
            _ProfileCard(
              settings: settings,
              notifier: notifier,
              nameCtrl: _nameCtrl,
              accent: accent,
              primary: primary,
              secondary: secondary,
            ),
            const SizedBox(height: AppSpacing.sp28),

            // ── Appearance ───────────────────────────────────────────────
            _SectionLabel('APPEARANCE'),
            const SizedBox(height: AppSpacing.sp8),
            FlatCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _NavRow(
                    icon: CupertinoIcons.sun_max_fill,
                    badgeColor: const Color(0xFF007AFF),
                    label: 'Theme',
                    value: settings.themeMode.label,
                    onTap: () => _pickTheme(context, settings, notifier),
                  ),
                  _RowDivider(),
                  _NavRow(
                    icon: CupertinoIcons.textformat_size,
                    badgeColor: const Color(0xFF9B59B6),
                    label: 'Text Size',
                    value: settings.fontSize.label,
                    onTap: () => _pickFontSize(context, settings, notifier),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sp28),

            // ── PDF Defaults ─────────────────────────────────────────────
            _SectionLabel('PDF DEFAULTS'),
            const SizedBox(height: AppSpacing.sp8),
            FlatCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _NavRow(
                    icon: CupertinoIcons.doc_fill,
                    badgeColor: const Color(0xFFFF9500),
                    label: 'Default Page Size',
                    value: settings.defaultPageSize.label,
                    onTap: () => _pickPageSize(context, settings, notifier),
                  ),
                  _RowDivider(),
                  _NavRow(
                    icon: CupertinoIcons.arrow_down_doc_fill,
                    badgeColor: const Color(0xFF34C759),
                    label: 'Default Compression',
                    value: settings.defaultCompression.label,
                    onTap: () => _pickCompression(context, settings, notifier),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sp28),

            // ── Preferences ──────────────────────────────────────────────
            _SectionLabel('PREFERENCES'),
            const SizedBox(height: AppSpacing.sp8),
            FlatCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _ToggleRow(
                    icon: CupertinoIcons.square_arrow_down_fill,
                    badgeColor: const Color(0xFF00897B),
                    label: 'Auto-save PDFs',
                    subtitle: 'Automatically save converted files',
                    value: settings.autoSavePdfs,
                    accent: accent,
                    onChanged: notifier.setAutoSavePdfs,
                  ),
                  _RowDivider(),
                  _ToggleRow(
                    icon: CupertinoIcons.bolt_fill,
                    badgeColor: const Color(0xFFFF5722),
                    label: 'Haptic Feedback',
                    subtitle: 'Vibrate on actions and confirmations',
                    value: settings.hapticFeedback,
                    accent: accent,
                    onChanged: notifier.setHapticFeedback,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sp28),

            // ── About ────────────────────────────────────────────────────
            _SectionLabel('ABOUT'),
            const SizedBox(height: AppSpacing.sp8),
            FlatCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _InfoRow(
                    icon: CupertinoIcons.info_circle_fill,
                    badgeColor: AppColors.labelTertiary.resolveFrom(context),
                    label: 'Version',
                    value: '1.0.0',
                  ),
                  _RowDivider(),
                  _NavRow(
                    icon: CupertinoIcons.star_fill,
                    badgeColor: const Color(0xFFFFCC00),
                    label: 'Rate Image to PDF',
                    value: '',
                    onTap: () {},
                  ),
                  _RowDivider(),
                  _NavRow(
                    icon: CupertinoIcons.lock_shield_fill,
                    badgeColor: const Color(0xFF007AFF),
                    label: 'Privacy Policy',
                    value: '',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Pickers ───────────────────────────────────────────────────────────────

  Future<void> _pickTheme(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) async {
    final result = await showCupertinoModalPopup<AppThemeMode>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Theme'),
        actions: AppThemeMode.values
            .map(
              (m) => CupertinoActionSheetAction(
                isDefaultAction: settings.themeMode == m,
                onPressed: () => Navigator.pop(ctx, m),
                child: Text(m.label),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
    if (result != null) notifier.setThemeMode(result);
  }

  Future<void> _pickFontSize(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) async {
    final result = await showCupertinoModalPopup<AppFontSize>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Text Size'),
        actions: AppFontSize.values
            .map(
              (s) => CupertinoActionSheetAction(
                isDefaultAction: settings.fontSize == s,
                onPressed: () => Navigator.pop(ctx, s),
                child: Text(s.label),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
    if (result != null) notifier.setFontSize(result);
  }

  Future<void> _pickPageSize(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) async {
    final result = await showCupertinoModalPopup<DefaultPageSize>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Default Page Size'),
        actions: DefaultPageSize.values
            .map(
              (s) => CupertinoActionSheetAction(
                isDefaultAction: settings.defaultPageSize == s,
                onPressed: () => Navigator.pop(ctx, s),
                child: Text(s.label),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
    if (result != null) notifier.setDefaultPageSize(result);
  }

  Future<void> _pickCompression(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) async {
    final result = await showCupertinoModalPopup<CompressionLevel>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Default Compression'),
        message: const Text('Applied automatically when compressing PDFs'),
        actions: CompressionLevel.values
            .map(
              (l) => CupertinoActionSheetAction(
                isDefaultAction: settings.defaultCompression == l,
                onPressed: () => Navigator.pop(ctx, l),
                child: Text(l.label),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
    if (result != null) notifier.setDefaultCompression(result);
  }
}

// ── Profile Card ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.settings,
    required this.notifier,
    required this.nameCtrl,
    required this.accent,
    required this.primary,
    required this.secondary,
  });

  final AppSettings settings;
  final SettingsNotifier notifier;
  final TextEditingController nameCtrl;
  final Color accent;
  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final initial = settings.username.isNotEmpty
        ? settings.username.trimLeft()[0].toUpperCase()
        : null;

    return FlatCard(
      padding: const EdgeInsets.all(AppSpacing.sp16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar ──────────────────────────────────────────────────
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent,
                  accent.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: initial != null
                ? Center(
                    child: Text(
                      initial,
                      style: AppTypography.title2Bold.copyWith(
                        color: CupertinoColors.white,
                      ),
                    ),
                  )
                : const Icon(
                    CupertinoIcons.person_fill,
                    color: CupertinoColors.white,
                    size: 28,
                  ),
          ),
          const SizedBox(width: AppSpacing.sp16),

          // ── Name field ───────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Display Name',
                  style: AppTypography.caption1.copyWith(color: secondary),
                ),
                const SizedBox(height: 4),
                CupertinoTextField(
                  controller: nameCtrl,
                  placeholder: 'Your name',
                  style: AppTypography.body.copyWith(color: primary),
                  placeholderStyle: AppTypography.body.copyWith(
                    color: AppColors.labelTertiary.resolveFrom(context),
                  ),
                  decoration: null,
                  padding: EdgeInsets.zero,
                  textInputAction: TextInputAction.done,
                  onChanged: notifier.setUsername,
                  onSubmitted: notifier.setUsername,
                ),
              ],
            ),
          ),

          // ── Edit indicator ───────────────────────────────────────────
          Icon(
            CupertinoIcons.pencil,
            size: 16,
            color: AppColors.labelTertiary.resolveFrom(context),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sp4),
      child: Text(
        title,
        style: AppTypography.caption2.copyWith(
          color: AppColors.labelSecondary.resolveFrom(context),
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Row Divider ───────────────────────────────────────────────────────────────

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.only(left: 60.0), // icon badge width + padding
      color: AppColors.separator.resolveFrom(context),
    );
  }
}

// ── Nav Row ───────────────────────────────────────────────────────────────────

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.badgeColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final Color badgeColor;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);
    final tertiary = AppColors.labelTertiary.resolveFrom(context);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp16,
          vertical: AppSpacing.sp12,
        ),
        child: Row(
          children: [
            _IconBadge(icon: icon, color: badgeColor),
            const SizedBox(width: AppSpacing.sp12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(color: primary),
              ),
            ),
            if (value.isNotEmpty) ...[
              Text(value, style: AppTypography.body.copyWith(color: secondary)),
              const SizedBox(width: AppSpacing.sp4),
            ],
            Icon(CupertinoIcons.chevron_right, size: 14, color: tertiary),
          ],
        ),
      ),
    );
  }
}

// ── Toggle Row ────────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.badgeColor,
    required this.label,
    required this.value,
    required this.accent,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final Color badgeColor;
  final String label;
  final String? subtitle;
  final bool value;
  final Color accent;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp16,
        vertical: AppSpacing.sp10,
      ),
      child: Row(
        children: [
          _IconBadge(icon: icon, color: badgeColor),
          const SizedBox(width: AppSpacing.sp12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.body.copyWith(color: primary)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.caption1.copyWith(color: secondary),
                  ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: accent,
          ),
        ],
      ),
    );
  }
}

// ── Info Row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.badgeColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color badgeColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp16,
        vertical: AppSpacing.sp12,
      ),
      child: Row(
        children: [
          _IconBadge(icon: icon, color: badgeColor),
          const SizedBox(width: AppSpacing.sp12),
          Expanded(
            child: Text(label, style: AppTypography.body.copyWith(color: primary)),
          ),
          Text(value, style: AppTypography.body.copyWith(color: secondary)),
        ],
      ),
    );
  }
}

// ── Icon Badge (iOS Settings style) ──────────────────────────────────────────

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: CupertinoColors.white, size: 17),
    );
  }
}
