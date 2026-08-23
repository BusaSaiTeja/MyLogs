import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';
import 'package:my_logs/features/reminders/presentation/widgets/reminder_recurrence_selector.dart';
import 'package:my_logs/features/reminders/presentation/widgets/reminder_time_picker_tile.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({super.key, this.reminderId});
  final String? reminderId;

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _customDaysCtrl;
  DateTime _scheduledTime = DateTime.now().add(const Duration(hours: 1));
  ReminderRecurrence _recurrence = ReminderRecurrence.daily;
  bool _isEnabled = true;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _customDaysCtrl = TextEditingController();
    if (reminderId != null) {
      _isEdit = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final items = ref.read(reminderListProvider).valueOrNull ?? [];
        final r = items.where((r) => r.id == reminderId).firstOrNull;
        if (r == null) return;
        _titleCtrl.text = r.title;
        _customDaysCtrl.text = r.customDaysText ?? '';
        setState(() {
          _scheduledTime = r.scheduledTime;
          _recurrence = r.recurrence;
          _isEnabled = r.isEnabled;
        });
      });
    }
  }

  String? get reminderId => widget.reminderId;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _customDaysCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledTime),
    );
    if (time == null) return;
    setState(() => _scheduledTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final customText = _recurrence == ReminderRecurrence.custom
        ? _customDaysCtrl.text.trim()
        : null;

    try {
      if (_isEdit) {
        final existing = (ref.read(reminderListProvider).valueOrNull ?? [])
            .where((r) => r.id == reminderId)
            .firstOrNull;
        if (existing == null) return;
        await ref.read(reminderListProvider.notifier).updateItem(existing.copyWith(
              title: _titleCtrl.text.trim(),
              scheduledTime: _scheduledTime,
              recurrence: _recurrence,
              customDaysText: customText,
              isEnabled: _isEnabled,
              updatedAt: now,
            ));
      } else {
        await ref.read(reminderListProvider.notifier).add(ReminderItem(
              id: '',
              title: _titleCtrl.text.trim(),
              scheduledTime: _scheduledTime,
              recurrence: _recurrence,
              customDaysText: customText,
              isEnabled: _isEnabled,
              createdAt: now,
              updatedAt: now,
            ));
      }
      if (!mounted) return;
      router.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to save reminder: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
          onPressed: () => context.canPop() ? context.pop() : context.go('/reminders'),
        ),
        title: Text(_isEdit ? 'Edit Reminder' : 'New Reminder',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: false,
        actions: [
          if (_isEdit && reminderId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.error,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Reminder'),
                    content: const Text('Are you sure you want to delete this reminder?'),
                    actions: [
                      TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => ctx.pop(true),
                        style: TextButton.styleFrom(foregroundColor: AppColors.error),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await ref.read(reminderListProvider.notifier).delete(reminderId!);
                  if (context.mounted) {
                    context.canPop() ? context.pop() : context.go('/reminders');
                  }
                }
              },
            ),
          TextButton(onPressed: _save, child: Text('Save', style: AppTypography.labelMdPrimary())),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            Text('Reminder Title', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 6),
            TextFormField(
              controller: _titleCtrl,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              decoration: const InputDecoration(hintText: 'e.g. Morning Briefing'),
              style: AppTypography.bodyLg,
            ),
            const SizedBox(height: AppSpacing.stackGap),
            Text('Scheduled Time', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 6),
            ReminderTimePickerTile(
              scheduledTime: _scheduledTime,
              onTap: _pickDateTime,
            ),
            const SizedBox(height: AppSpacing.stackGap),
            Text('Recurrence', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 8),
            ReminderRecurrenceSelector(
              selectedRecurrence: _recurrence,
              onRecurrenceSelected: (r) => setState(() => _recurrence = r),
              customTextController: _customDaysCtrl,
            ),
            const SizedBox(height: AppSpacing.stackGap),
            Row(
              children: [
                Text('Enable immediately', style: AppTypography.bodyLg),
                const Spacer(),
                Switch(
                  value: _isEnabled,
                  onChanged: (v) => setState(() => _isEnabled = v),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
