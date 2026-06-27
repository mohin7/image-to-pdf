import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/components/app_bottom_nav_bar.dart';
import '../design_system/tokens/app_colors.dart';
import '../features/compress_pdf/compress_screen.dart';
import '../features/home/home_screen.dart';
import '../features/merge_pdf/merge_screen.dart';
import '../features/my_files/my_files_screen.dart';
import '../features/settings/providers/settings_notifier.dart';
import '../features/settings/settings_screen.dart';
import '../features/split_pdf/split_screen.dart';

const _tabs = [
  AppTabItem(
    icon: CupertinoIcons.photo_on_rectangle,
    activeIcon: CupertinoIcons.photo_fill_on_rectangle_fill,
    label: 'Convert',
  ),
  AppTabItem(
    icon: CupertinoIcons.doc_on_doc,
    activeIcon: CupertinoIcons.doc_on_doc_fill,
    label: 'Merge',
  ),
  AppTabItem(
    icon: CupertinoIcons.arrow_down_doc,
    activeIcon: CupertinoIcons.arrow_down_doc_fill,
    label: 'Compress',
  ),
  AppTabItem(
    icon: CupertinoIcons.scissors,
    activeIcon: CupertinoIcons.scissors,
    label: 'Split',
  ),
  AppTabItem(
    icon: CupertinoIcons.folder,
    activeIcon: CupertinoIcons.folder_fill,
    label: 'My Files',
  ),
  AppTabItem(
    icon: CupertinoIcons.settings,
    activeIcon: CupertinoIcons.settings_solid,
    label: 'Settings',
  ),
];

class MainTabScreen extends ConsumerStatefulWidget {
  const MainTabScreen({super.key});

  @override
  ConsumerState<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends ConsumerState<MainTabScreen> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    MergeScreen(),
    CompressScreen(),
    SplitScreen(),
    MyFilesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final fontScale =
        ref.watch(settingsProvider.select((s) => s.fontScale));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(fontScale),
      ),
      child: CupertinoPageScaffold(
        backgroundColor: AppColors.backgroundPrimary.resolveFrom(context),
        child: Stack(
          children: [
            // Screen content — each tab is kept alive via IndexedStack
            // We add 56.0 to the bottom padding so screens know about the floating tab bar
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: MediaQuery.of(context).padding.copyWith(
                  bottom: MediaQuery.of(context).padding.bottom + 56.0,
                ),
              ),
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),

            // Custom bottom nav bar floats above content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AppBottomNavBar(
                items: _tabs,
                currentIndex: _currentIndex,
                onTap: (i) => setState(() => _currentIndex = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
