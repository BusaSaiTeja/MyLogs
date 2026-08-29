import 'package:flutter/material.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';

/// Pill-style tab bar with a physical sliding pill indicator that glides across tabs.
class PillTabBar extends StatefulWidget {
  const PillTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.trailing,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Widget? trailing;

  @override
  State<PillTabBar> createState() => _PillTabBarState();
}

class _PillTabBarState extends State<PillTabBar> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _stackKey = GlobalKey();
  final List<GlobalKey> _tabKeys = [];

  double _indicatorLeft = 0;
  double _indicatorWidth = 0;
  bool _hasCalculated = false;

  @override
  void initState() {
    super.initState();
    _tabKeys.addAll(List.generate(widget.tabs.length, (_) => GlobalKey()));
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicatorPosition(animateScroll: false));
  }

  @override
  void didUpdateWidget(covariant PillTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != _tabKeys.length) {
      _tabKeys.clear();
      _tabKeys.addAll(List.generate(widget.tabs.length, (_) => GlobalKey()));
    }
    if (oldWidget.selectedIndex != widget.selectedIndex || oldWidget.tabs != widget.tabs) {
      _updateIndicatorPosition(animateScroll: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateIndicatorPosition({bool animateScroll = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.selectedIndex < 0 || widget.selectedIndex >= _tabKeys.length) return;

      final targetKey = _tabKeys[widget.selectedIndex];
      final targetBox = targetKey.currentContext?.findRenderObject() as RenderBox?;
      final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;

      if (targetBox != null && stackBox != null) {
        final targetOffset = targetBox.localToGlobal(Offset.zero, ancestor: stackBox);
        setState(() {
          _indicatorLeft = targetOffset.dx;
          _indicatorWidth = targetBox.size.width;
          _hasCalculated = true;
        });
      }

      if (animateScroll) {
        _scrollToActiveTab();
      }
    });
  }

  void _scrollToActiveTab() {
    if (widget.selectedIndex >= 0 && widget.selectedIndex < _tabKeys.length) {
      final keyContext = _tabKeys[widget.selectedIndex].currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: 0.5,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Stack(
          key: _stackKey,
          children: [
            // ── Physical Sliding Pill Indicator ───────────────────────────────
            if (_hasCalculated && _indicatorWidth > 0)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                left: _indicatorLeft,
                top: 0,
                bottom: 0,
                width: _indicatorWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.09),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Tab Items Row ─────────────────────────────────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(widget.tabs.length, (i) {
                  final isActive = i == widget.selectedIndex;
                  return Padding(
                    key: i < _tabKeys.length ? _tabKeys[i] : null,
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: GestureDetector(
                      onTap: () {
                        widget.onTabSelected(i);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        color: Colors.transparent,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          style: isActive
                              ? AppTypography.labelMdPrimary().copyWith(fontWeight: FontWeight.w600)
                              : AppTypography.labelMdVariant(),
                          child: Text(widget.tabs[i]),
                        ),
                      ),
                    ),
                  );
                }),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 4),
                  widget.trailing!,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
