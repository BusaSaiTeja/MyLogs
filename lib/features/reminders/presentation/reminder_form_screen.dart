import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_logs/core/theme/app_colors.dart';
import 'package:my_logs/core/theme/app_spacing.dart';
import 'package:my_logs/core/theme/app_typography.dart';
import 'package:my_logs/features/reminders/application/reminder_providers.dart';
import 'package:my_logs/features/reminders/domain/models/reminder_item.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({super.key, this.reminderId});
  final String? reminderId;

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  DateTime _scheduledTime = DateTime.now().add(const Duration(hours: 1));
  ReminderRecurrence _recurrence = ReminderRecurrence.daily;
  bool _isEnabled = true;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    if (reminderId != null) {
      _isEdit = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final items = ref.read(reminderListProvider).valueOrNull ?? [];
        final r = items.where((r) => r.id == reminderId).firstOrNull;
        if (r == null) return;
        _titleCtrl.text = r.title;
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
    if (_isEdit) {
      final existing = (ref.read(reminderListProvider).valueOrNull ?? [])
          .where((r) => r.id == reminderId)
          .firstOrNull;
      if (existing == null) return;
      await ref.read(reminderListProvider.notifier).updateItem(existing.copyWith(
            title: _titleCtrl.text.trim(),
            scheduledTime: _scheduledTime,
            recurrence: _recurrence,
            isEnabled: _isEnabled,
            updatedAt: now,
          ));
    } else {
      await ref.read(reminderListProvider.notifier).add(ReminderItem(
            id: '',
            title: _titleCtrl.text.trim(),
            scheduledTime: _scheduledTime,
            recurrence: _recurrence,
            isEnabled: _isEnabled,
            createdAt: now,
            updatedAt: now,
          ));
    }
    if (mounted) context.pop();
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
          onPressed: () => context.go('/'),
        ),
        title: Text(_isEdit ? 'Edit Reminder' : 'New Reminder',
            style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _save, child: Text('Save', style: AppTypography.labelMdPrimary())),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
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
            GestureDetector(
              onTap: _pickDateTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.alarm_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      '${_scheduledTime.day}/${_scheduledTime.month}/${_scheduledTime.year} '
                      '${_scheduledTime.hour.toString().padLeft(2, '0')}:${_scheduledTime.minute.toString().padLeft(2, '0')}',
                      style: AppTypography.bodyLg,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.stackGap),
            Text('Recurrence', style: AppTypography.labelMdVariant()),
            const SizedBox(height: 8),
            Row(
              children: ReminderRecurrence.values.map((r) {
                final isSelected = r == _recurrence;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _recurrence = r),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                        child: Center(
                          child: Text(
                            r.label,
                            style: AppTypography.labelMd.copyWith(
                              color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
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
