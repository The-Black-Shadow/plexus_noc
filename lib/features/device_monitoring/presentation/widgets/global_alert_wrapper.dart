import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/alert/alert_cubit.dart';


class GlobalAlertWrapper extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const GlobalAlertWrapper({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  State<GlobalAlertWrapper> createState() => _GlobalAlertWrapperState();
}

class _GlobalAlertWrapperState extends State<GlobalAlertWrapper> {
  bool _isDialogShowing = false;

  final ValueNotifier<String> _alertMessageNotifier = ValueNotifier<String>('');

  /// Pending alert message that arrived while the dashboard was not visible.
  String? _pendingAlertMessage;

  /// Whether the dashboard tab is currently the active branch.
  bool get _isDashboardVisible {
    final shell = StatefulNavigationShell.maybeOf(context);
    // If we can't determine the shell (e.g. during disposal), treat as
    // invisible to avoid showing orphan dialogs.
    if (shell == null) return false;
    return shell.currentIndex == 0;
  }

  void _showGlobalAlertDialog(String message) {
    // ── Guard: only show when the dashboard is the active tab ──
    if (!_isDashboardVisible) {
      _pendingAlertMessage = message;
      return;
    }

    _alertMessageNotifier.value = message;

    if (_isDialogShowing) return;

    final context = widget.navigatorKey.currentContext;
    if (context == null) return;

    _isDialogShowing = true;

    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: colorScheme.error,
                size: 32.responsive(context),
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.criticalAlertTitle,
                style: TextStyle(color: colorScheme.error),
              ),
            ],
          ),
          content: ValueListenableBuilder<String>(
            valueListenable: _alertMessageNotifier,
            builder: (context, currentMessage, child) {
              return Text(
                currentMessage,
                style: TextStyle(
                  fontSize: 16.responsive(context),
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _isDialogShowing = false;
                Navigator.of(dialogContext, rootNavigator: true).pop();
              },
              child: const Text(
                AppStrings.alertDismiss,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  /// Called when the dashboard becomes the visible tab again.
  /// Shows any alert that was queued while the user was on another tab.
  void _flushPendingAlert() {
    final pending = _pendingAlertMessage;
    if (pending != null) {
      _pendingAlertMessage = null;
      _showGlobalAlertDialog(pending);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // When the shell index changes back to dashboard, flush any pending alert.
    _flushPendingAlert();
  }

  @override
  void dispose() {
    _alertMessageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlertCubit, AlertState>(
      listener: (context, state) {
        if (state is AlertTriggered) {
          _showGlobalAlertDialog(state.alert.message);
        }
      },
      child: widget.child,
    );
  }
}
